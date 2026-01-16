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
// Unit of time for delays
// `timeunit(CLKPERIOD / 4);
// Simulation time-steps
// `timeprecision(CLKPERIOD / 4);

// Number of sequence items to generate (default value, can be overridden via
// cmdline)
int numSeqItems = 100;

// Custom Report Server for cleaner messages
`include "Class_SimpleReportServer.sv"

// DUT Interface and Wrapper files are the only modules alongside the
// top-level Testbench, do they aren't included here, but instead compiled!

// Testbench Class files
`include "Class_EX_Sequence.sv"
`include "Class_EX_Driver.sv"
`include "Class_EX_Monitor.sv"
`include "Class_EX_Agent.sv"
`include "Class_EX_CoverageTracker.sv"
`include "Class_EX_Scoreboard.sv"
`include "Class_EX_Environment.sv"
`include "Class_EX_Test.sv"


module Module_topTestbench;

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
		// NOTE: (parenthesis needed because these are modules!
		Iface_EXE #(
			IR_SIZE, OPERAND_SIZE, I_TYPE_IMM_SIZE,
			J_TYPE_IMM_SIZE, RF_REGBITS, RF_NUMREGS
		)
		exe_dut_iface (
			.CLK  (globalClk),
			.nRST(globalRst_n)
		);

		// Instance DUT using wrapper
		Module_EXE_Wrapper #(
			IR_SIZE, OPERAND_SIZE, I_TYPE_IMM_SIZE,
			J_TYPE_IMM_SIZE, RF_REGBITS, RF_NUMREGS
		)
		exe_toplevel (
			.exe_iface(exe_dut_iface)
		);


		/*******************************************
  	 *  GLOBAL SINGLE-TIME SIMULATION PROCESS  *
  	 *******************************************/
		
		initial begin : PROC_GlobalSimulation // fault simulation-independent 

			/* TERMINAL AND BASH INTERACTION */
			// Install custom report server used by UVM macros for cleaner messages
			static Class_SimpleReportServer exe_simple_report_server = new();
			uvm_report_server::set_server(exe_simple_report_server);

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
			uvm_config_db#(virtual Iface_EXE #(
				IR_SIZE, OPERAND_SIZE, I_TYPE_IMM_SIZE,
				J_TYPE_IMM_SIZE, RF_REGBITS, RF_NUMREGS
			) )::set(null, "*", "exe_dut_iface", exe_dut_iface);


			`ifdef FAULT_INJECTION_CAMPAIGN

				/**************************************************
				* FAULT INJECTION AND SIMULATION CAMPAIGN PROCESS *
				**************************************************/
				forever begin : PROC_FaultCampaignSimulation

					/* Simulation-related variables */
					static int faultsim_cycle = 0; // counts number of fault simulation cycles
					static int detected_faults = 0; // used for computing FC when fault simulation ends

					/* FIRST FAULT SIMULATION CYCLE => OPEN FAULT FILE AND READ FIRST LINE TO INJECT */
					if (faultsim_cycle == 0) begin
						`uvm_info("GREEN", "################# FAULT INJECTION CAMPAIGN STARTED #################", UVM_MEDIUM);

						// Set initial value of detected faults to 0, both inside UVM DB and bash env variable
						uvm_config_db#(int)::get(null, "", "detected_faults", detected_faults);
						if (!detected_faults) begin
							uvm_config_db#(int)::set(null, "", "detected_faults", 0);
						end
					end 

				  `uvm_info("GREEN", $sformatf("### FAULT SIM CYCLE %0d ###", faultsim_cycle), UVM_MEDIUM);

					faultsim_cycle++;  

					// Run current fault simulation test 
					run_test("Class_EXE_Test");
			
				end : PROC_FaultCampaignSimulation 

			`else 

				/************************************
				* STANDARD (FAULT-FREE) SIMULATION  *
				*************************************/
				// Running single-time fault-free simulation test...
				run_test("Class_EXE_Test");

				// Stop falt-free simulation
				`uvm_info("GREEN", "################# SIMULATION ENDED #################", UVM_MEDIUM);
				$finish;

			`endif // FAULT_INJECTION_CAMPAIGN

  	end : PROC_GlobalSimulation

endmodule


 // [TODO:]
 // 0) Get current fault line from fault file
 // 1) Save it to UVM DB var 
 // 2) Simulate current fault (force + release)
 // 3) Write the current line to "classified_faults.txt" output file as DETECTED or UNDETECTED
 //    (sed the current line to output SA0/SA1, and DETECTED/UNDETECTED
 //     based on scoreboard match/mismatch, which will ideally set a UVM DB variable on error)
 
 // FIXME: 1) Fix correct Fault coverage computation (both detected and total are 0 for now)
 // FIXME: 2) Fix 
