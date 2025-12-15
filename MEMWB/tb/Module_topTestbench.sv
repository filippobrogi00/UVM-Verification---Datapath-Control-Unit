// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* TOP LEVEL TESTBENCH: All components get instantiated inside this top-level
* module
* */

`include "uvm_macros.svh"
import uvm_pkg::*;

// Constants package
`include "pkg_constants.sv"
import pkg_const::*;

// Timescale is CLKPERIOD/2 = 1ns
`timescale 1ns / 1ns

// Number of sequence items to generate (default value, can be overridden via
// cmdline)
int numSeqItems = 100;

// Custom Report Server for cleaner messages
//`include "Class_SimpleReportServer.sv"

// Testbench Class files
`include "classes/Class_MEMWB_Sequence.sv"
`include "classes/Class_MEMWB_Driver.sv"
`include "classes/Class_MEMWB_Monitor.sv"
`include "classes/Class_MEMWB_Agent.sv"
`include "classes/Class_MEMWB_CoverageTracker.sv"
`include "classes/Class_MEMWB_Scoreboard.sv"
`include "classes/Class_MEMWB_Environment.sv"
`include "classes/Class_MEMWB_Test.sv"

module Module_topTestbench;

  bit globalClk;
  always begin : PROC_ClockGen
    #(CLKPERIOD / 2) globalClk <= ~globalClk;
  end : PROC_ClockGen

  bit globalRst_n;
  initial begin : PROC_ResetDUT
    globalRst_n <= 1'b1;  // active
    #1ns globalRst_n <= 1'b0;  // de-activate after a clock period
    #CLKPERIOD globalRst_n <= 1'b1;  // de-activate after a clock period
  end : PROC_ResetDUT

  // Interfaces instantiation
  // NOTE: (parenthesis needed because these are modules!
  Iface_MEMWB #(IR_SIZE) memwb_dut_iface (
      .clk  (globalClk),
      .rst_n(globalRst_n)
  );

  // Instance DUT using wrapper
  Module_MEMWB_Wrapper #(.IR_SIZE(IR_SIZE)) memwb_toplevel (
    .memwb_iface(memwb_dut_iface)
  );

  /*
  * PROC_RunTest: Test configuration and run process
  * */
  initial begin : PROC_RunTest

    // Install custom report server used by UVM macros for cleaner messages
    //Class_SimpleReportServer memwb_simple_report_server = new();
    //uvm_report_server::set_server(memwb_simple_report_server);

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
    uvm_config_db#(virtual Iface_MEMWB #(IR_SIZE))::set(
        null, "*", "memwb_dut_iface", memwb_dut_iface);

    // Running test...
    run_test("Class_MEMWB_Test");

    // Stop simulation
    $display("################# SIMULATION ENDED #################");
    $stop;
  end : PROC_RunTest

endmodule
