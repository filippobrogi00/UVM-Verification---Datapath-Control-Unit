// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* TOP LEVEL TESTBENCH: All components get instantiated inside this top-level
* module
* */
`timescale 1ns / 1ns

// Standard UVM packages for UVM macros and functions
`include "uvm_macros.svh"
import uvm_pkg::*;


// Constants package
`include "pkg_constants.sv"
import pkg_const::*;

// Number of sequence items to generate (default value, can be overridden via
// cmdline)
int numSeqItems = 100;

// DUT Interface and Wrapper files are the only modules alongside the
// top-level Testbench, do they aren't included here, but instead compiled!

// Custom Report Server for cleaner messages
// `include "Class_SimpleReportServer.sv"

// Testbench Class files
`include "Class_IFID_Sequence.sv"
`include "Class_IFID_Driver.sv"
`include "Class_IFID_Monitor.sv"
`include "Class_IFID_Agent.sv"
`include "Class_IFID_CoverageTracker.sv"
`include "Class_IFID_Scoreboard.sv"
`include "Class_IFID_Environment.sv"
`include "Class_IFID_Test.sv"

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
    // Start de-asserted
    globalRst_n <= 1'b1;
    // Activate after 2 CCs
    #(CLKPERIOD * 10) globalRst_n <= 1'b0;
    // De-activate after andother 2 CCs
    #(CLKPERIOD * 10) globalRst_n <= 1'b1;
  end : PROC_ResetDUT

  // Interfaces instantiation
  // NOTE: () parenthesis after iface name needed because these are modules!
  Iface_IFID #(
      .IR_SIZE        (IR_SIZE),
      .OPERAND_SIZE   (OPERAND_SIZE),
      .I_TYPE_IMM_SIZE(I_TYPE_IMM_SIZE),
      .J_TYPE_IMM_SIZE(J_TYPE_IMM_SIZE),
      .RF_REGBITS     (RF_REGBITS),
      .RF_NUMREGS     (RF_NUMREGS)
  ) ifid_dut_iface (
      .CLK (globalClk),
      .nRST(globalRst_n)
  );

  // Instance DUT using wrapper
  Module_IFID_Wrapper #(
      .IR_SIZE        (IR_SIZE),
      .OPERAND_SIZE   (OPERAND_SIZE),
      .I_TYPE_IMM_SIZE(I_TYPE_IMM_SIZE),
      .J_TYPE_IMM_SIZE(J_TYPE_IMM_SIZE),
      .RF_REGBITS     (RF_REGBITS),
      .RF_NUMREGS     (RF_NUMREGS)
  ) ifid_toplevel (
      .ifid_iface(ifid_dut_iface)
  );

  /*
  * PROC_RunTest: Test configuration and run process
  * */
  initial begin : PROC_RunTest

    // Install custom report server used by UVM macros for cleaner messages
    // static Class_SimpleReportServer ifid_simple_report_server = new();
    // uvm_report_server::set_server(ifid_simple_report_server);

    /* Override number of Sequence Items to generate if specified from cmdline */
    // Check if parameter was specified (numSeqItems overridden with
    // user-specified value)

    // coverage off bc
    if ($value$plusargs("NUM_SEQITEMS=%d", numSeqItems)) begin
      `uvm_info("TB TOP", $sformatf("NUM_SEQITEMS set to %0d from cmdline", numSeqItems),
                UVM_MEDIUM)
    end
    // coverage on bc

    // Store value into config DB for passing it to Sequence component (store
    // with scope "*")
    uvm_config_db#(int)::set(null, "*", "numSeqItems", numSeqItems);

    // Pass Virtual DUT interface handle down to components through Config Object
    uvm_config_db#(virtual Iface_IFID #(
      IR_SIZE, OPERAND_SIZE, I_TYPE_IMM_SIZE, J_TYPE_IMM_SIZE, RF_REGBITS, RF_NUMREGS)
      )::set(
        null, "*", "ifid_dut_iface", ifid_dut_iface);

    // Running test...
    run_test("Class_IFID_Test");

    // Stop simulation
    // coverage off s
    $display("################# SIMULATION ENDED #################");
    $stop;
    // coverage on s
  end : PROC_RunTest

endmodule
