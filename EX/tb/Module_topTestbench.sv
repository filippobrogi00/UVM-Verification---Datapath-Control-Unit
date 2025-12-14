// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* TOP LEVEL TESTBENCH: All components get instantiated inside this top-level
* module
* */

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

//`include "Class_EX_FaultInjector.sv"

`include "Class_EX_Environment.sv"
`include "Class_EX_Test.sv"

//`include "Class_EX_FaultTest.sv"    
//`include "Class_EX_MuxAStuckTest.sv"    

module Module_topTestbench;

  	/*
  	* Clock Generation with process
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

  	/*
  	* PROC_RunTest: Test configuration and run process
  	* */
  	initial begin : PROC_RunTest

    	// Install custom report server used by UVM macros for cleaner messages
    	Class_SimpleReportServer exe_simple_report_server = new();
    	uvm_report_server::set_server(exe_simple_report_server);

    	/* Override number of Sequence Items to generate if specified from cmdline */
    	// Check if parameter was specified (numSeqItems overridden with
    	// user-specified value)
    	// coverage off b
    	if ($value$plusargs("NUM_SEQITEMS=%d", numSeqItems)) begin
      		`uvm_info("TB TOP", $sformatf("NUM_SEQITEMS set to %0d from cmdline", numSeqItems), UVM_MEDIUM)
    	end
    	// coverage on b

    	// Store value into config DB for passing it to Sequence component (store
    	// with scope "*")
    	uvm_config_db#(int)::set(null, "*", "numSeqItems", numSeqItems);

    	// Pass Virtual DUT interface handle down to components through Config Object
		uvm_config_db#(virtual Iface_EXE #(
			IR_SIZE, OPERAND_SIZE, I_TYPE_IMM_SIZE, 
			J_TYPE_IMM_SIZE, RF_REGBITS, RF_NUMREGS
		) )::set(null, "*", "exe_dut_iface", exe_dut_iface);

    	// Running test...
    	run_test("Class_EXE_Test");

    	// Stop simulation
    	$display("################# SIMULATION ENDED #################");
    	$stop;
  	end : PROC_RunTest

endmodule
