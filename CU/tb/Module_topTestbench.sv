// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* TOP LEVEL TESTBENCH: All components get instantiated inside this top-level
* module
* */

// // Import C functions to communicate with Bash run.sh script
import "DPI-C" function string getenv(input string name); 

// Standard UVM packages for UVM macros and functions
`include "uvm_macros.svh"
import uvm_pkg::*;

// Constants package
`include "pkg_constants.sv"
import pkg_const::*;
// Timescale is CLKPERIOD/2 = 1ns
// NOTE: Both "timeunit" (unit of time for delays) and "timeprecision",
// simulation time-steps
`timescale 1ns / 1ns

// Number of sequence items to generate (default value, can be overridden via
// cmdline)
int numSeqItems = 100;

// Custom Report Server for cleaner messages
`include "Class_SimpleReportServer.sv"

// DUT Interface and Wrapper files are the only modules alongside the
// top-level Testbench, do they aren't included here, but instead compiled!

// Testbench Class files
`include "Class_CU_Sequence.sv"
`include "Class_CU_Driver.sv"
`include "Class_CU_Monitor.sv"
`include "Class_CU_Agent.sv"
`include "Class_CU_CoverageTracker.sv"
`include "Class_CU_Scoreboard.sv"
`include "Class_CU_Environment.sv"
`include "Class_CU_Test.sv"


module Module_topTestbench;

		`ifdef FAULT_INJECTION_CAMPAIGN

			/* FAULT INJECTION RELATED VARIABLES */ 
			int faultsim_cycle = 0;    
			int faults_file_fd; 
			string faults_file_name;
			string current_fault_line;  						// raw line 
			string current_fault;       						// fault hierarchy extracted from current line
			int    current_inj_value;   						// currently injected value for the fault 
			/* FAULT COVERAGE RELATED VARIABLES */
			int 	 local_detected; 									// to store "detected" UVM DB variable 
			string current_fault_is_detected; 			// "DETECTED" if detected, "UNDETECTED" otherwise
			int  	 classified_faults_fd;			    	// file descriptor 
			string classified_faults_file_name;	  

		`endif // FAULT_INJECTION_CAMPAIGN

		/****************************
		* CLOCK AND RESET PROCESSES *
		****************************/
  	/*
  	* Clock Generation Process
  	* */
  	bit globalClk;
  	always begin : PROC_ClockGen
  	  #(CLKPERIOD / 2) globalClk <= ~globalClk;
  	end : PROC_ClockGen

  	/*
  	* Reset process (DUT has active low!)
  	* */
  	bit globalRst_n;
  	initial begin : PROC_ResetDUT
    	globalRst_n <= 1'b1;  // active
    	#(CLKPERIOD*10) globalRst_n <= 1'b0;  // de-activate after a clock period
    	// globalRst_n <= 1'b0;  // active
    	#(CLKPERIOD*10) globalRst_n <= 1'b1;  // de-activate after a clock period
  	end : PROC_ResetDUT

		/*******************************************
		* DUT INTERFACE AND WRAPPER INSTANTIATION *
		*******************************************/
		// Interfaces instantiation
    // NOTE: () parenthesis after iface name needed because these are modules!
    Iface_CU #(
        .MICROCODE_MEM_SIZE(MICROCODE_MEM_SIZE),
        .FUNC_SIZE(FUNC_SIZE),
        .OP_CODE_SIZE(OPCODE_SIZE),
        .IR_SIZE(IR_SIZE),
        .CW_SIZE(CW_SIZE)
    ) cu_dut_iface (
        .Clk (globalClk),
        .nRst(globalRst_n)
    );

    // Instance DUT using wrapper
    Module_CU_Wrapper #(
        .MICROCODE_MEM_SIZE(MICROCODE_MEM_SIZE),
        .FUNC_SIZE(FUNC_SIZE),
        .OP_CODE_SIZE(OPCODE_SIZE),
        .IR_SIZE(IR_SIZE),
        .CW_SIZE(CW_SIZE)
    ) cu_toplevel ( // WARN: PARSER COMMENT, DO NOT CHANGE/REMOVE
        .cu_iface(cu_dut_iface)
    );


		/*******************************************
  	 *  GLOBAL SINGLE-TIME SIMULATION PROCESS  *
  	 *******************************************/
		
		initial begin : PROC_GlobalSimulation // fault simulation-independent 

			/* TERMINAL AND BASH INTERACTION */
			// Install custom report server used by UVM macros for cleaner messages
			static Class_SimpleReportServer cu_simple_report_server = new();
			uvm_report_server::set_server(cu_simple_report_server);

			/* Override number of Sequence Items to generate if specified from cmdline */
			// Check if parameter was specified (numSeqItems overridden with user-specified value)
			// coverage off b
			if ($value$plusargs("NUM_SEQITEMS=%d", numSeqItems)) begin
				`uvm_info("TB TOP", $sformatf("NUM_SEQITEMS set to %0d from cmdline", numSeqItems), UVM_MEDIUM)
			end
			// coverage on b

			/* PASS UVM DB VARIABLES TO UVM COMPONENTS */
			// Store value into config DB for passing it to Sequence component (store
			// with scope "*")
			uvm_config_db#(int)::set(null, "*", "numSeqItems", numSeqItems);

      // Pass Virtual DUT interface handle down to components through Config Object
      uvm_config_db#(virtual Iface_CU #(
        .MICROCODE_MEM_SIZE(MICROCODE_MEM_SIZE),
        .FUNC_SIZE(FUNC_SIZE),
        .OP_CODE_SIZE(OPCODE_SIZE),
        .IR_SIZE(IR_SIZE),
        .CW_SIZE(CW_SIZE)
      ))::set(null, "*", "cu_dut_iface", cu_dut_iface);

			`ifdef FAULT_INJECTION_CAMPAIGN

				// Open faults file in read mode
				faults_file_name = getenv("ENVVAR_FAULT_LIST_FILE_TEMP");
				if (faults_file_name == "") begin
					`uvm_fatal("TOPLEVEL", "ENVVAR_FAULT_LIST_FILE_TEMP environment variable not set!");
					$finish;
				end

				faults_file_fd = $fopen(faults_file_name, "r");
				if (!(faults_file_fd)) begin
					`uvm_fatal("TOPLEVEL", $sformatf("Could not open faults file: %s", faults_file_name));
					$finish;
				end
				
				// Open output fault-classification file 
				classified_faults_file_name = getenv("CLASSIFIED_FAULTS_FILE");
				if (classified_faults_file_name == "") begin
					`uvm_fatal("TOPLEVEL", "CLASSIFIED_FAULTS_FILE environment variable not set!");
					$finish;
				end

				classified_faults_fd = $fopen(classified_faults_file_name, "a");
				if (!(classified_faults_fd)) begin
					`uvm_fatal("TOPLEVEL", $sformatf("Could not open output file %s", classified_faults_file_name));
					$finish;
				end

				/**************************************************
				* FAULT INJECTION AND SIMULATION CAMPAIGN PROCESS *
				***************************************************/

				// Get current fault from file if not eof 
				while (!($feof(faults_file_fd))) begin
					// Get first line from faults file
					$fgets(current_fault_line, faults_file_fd);

					// Parse current line and split it into fault + injected value
					$sscanf(current_fault_line, "%s %d", current_fault, current_inj_value);

					// Memorize both in shared UVM DB variables "current_fault" and "current_inj_value" 
					uvm_config_db#(string)::set(null, "", "current_fault", current_fault);
					uvm_config_db#(int)::set(null, "", "current_inj_value", current_inj_value);

					// Log
					`uvm_info("BLUE", $sformatf("### Injecting fault: %s ###", current_fault), UVM_MEDIUM);
					`uvm_info("BLUE", $sformatf("### Fault sim cycle %0d ###", faultsim_cycle), UVM_MEDIUM);

					// Update fault simulation cycle
					faultsim_cycle++;  
					
					// Run current fault simulation test 
					// WARN: Do not put any code after test! 
					run_test("Class_CU_Test");

				end

				$fclose(faults_file_fd);
				$fclose(classified_faults_fd);

			`else 

				/************************************
				* STANDARD (FAULT-FREE) SIMULATION  *
				*************************************/
				
				// Running single-time fault-free simulation test...
				run_test("Class_CU_Test");

			`endif // FAULT_INJECTION_CAMPAIGN


  	end : PROC_GlobalSimulation

endmodule
