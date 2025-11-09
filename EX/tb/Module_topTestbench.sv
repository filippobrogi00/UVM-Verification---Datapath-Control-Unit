// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

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
`include "Class_ControlUnit_Sequence.sv"
`include "Class_ControlUnit_Driver.sv"
`include "Class_ControlUnit_Monitor.sv"
`include "Class_ControlUnit_Agent.sv"
`include "Class_ControlUnit_CoverageTracker.sv"
`include "Class_ControlUnit_Scoreboard.sv"
`include "Class_ControlUnit_Environment.sv"
`include "Class_ControlUnit_Test.sv"

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
    globalRst_n <= 1'b0;  // active
    #CLKPERIOD globalRst_n <= 1'b1;  // de-activate after a clock period
  end : PROC_ResetDUT

  // Interfaces instantiation
  // NOTE: (parenthesis needed because these are modules!
  Iface_ControlUnit #(OPCODE_SIZE, FUNC_SIZE) ctrlunit_dut_iface (
      .clk  (globalClk),
      .rst_n(globalRst_n)
  );

  // Instance DUT using wrapper
  Module_ControlUnit_Wrapper #(OPCODE_SIZE, FUNC_SIZE) ctrlunit_toplevel (
      .ctrlunit_iface(ctrlunit_dut_iface)
   );

  /*
  * PROC_RunTest: Test configuration and run process
  * */
  initial begin : PROC_RunTest

    // Install custom report server used by UVM macros for cleaner messages
    Class_SimpleReportServer ctrlunit_simple_report_server = new();
    uvm_report_server::set_server(ctrlunit_simple_report_server);

    /* Override number of Sequence Items to generate if specified from cmdline */
    // Check if parameter was specified (numSeqItems overridden with
    // user-specified value)
    // coverage off b
    if ($value$plusargs("NUM_SEQITEMS=%d", numSeqItems)) begin
      `uvm_info("TB TOP", $sformatf("NUM_SEQITEMS set to %0d from cmdline", numSeqItems),
                UVM_MEDIUM)
    end
    // coverage on b

    // Store value into config DB for passing it to Sequence component (store
    // with scope "*")
    uvm_config_db#(int)::set(null, "*", "numSeqItems", numSeqItems);

    // Pass Virtual DUT interface handle down to components through Config Object
    uvm_config_db#(virtual Iface_ControlUnit #(OPCODE_SIZE, FUNC_SIZE))::set(
        null, "*", "ctrlunit_dut_iface", ctrlunit_dut_iface);

    // Running test...
    run_test("Class_ControlUnit_Test");

    // Stop simulation
    $display("################# SIMULATION ENDED #################");
    $stop;
  end : PROC_RunTest

endmodule
