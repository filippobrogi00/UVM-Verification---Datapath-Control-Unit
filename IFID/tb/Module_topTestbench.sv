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

// Number of sequence items to generate (default value, can be overridden via
// cmdline)
int numSeqItems = 100;

// DUT Interface and Wrapper files are the only modules alongside the
// top-level Testbench, do they aren't included here, but instead compiled!

// Custom Report Server for cleaner messages
`include "Class_SimpleReportServer.sv"

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

  // Interfaces instantiation
  // NOTE: (parenthesis needed because these are modules!
  Iface_IFID #(.NBITS(NBITS)) ifid_dut_iface ();

  // Instance DUT using wrapper
  Module_ifid_Wrapper #(.NBITS(NBITS)) p4_adder_toplevel (.ifid_iface(ifid_dut_iface));

  /*
  * PROC_RunTest: Test configuration and run process
  * */
  initial begin : PROC_RunTest

    // Install custom report server used by UVM macros for cleaner messages
    Class_SimpleReportServer ifid_simple_report_server = new();
    uvm_report_server::set_server(ifid_simple_report_server);

    /* Override number of Sequence Items to generate if specified from cmdline */
    // Check if parameter was specified (numSeqItems overridden with
    // user-specified value)

    /* NOTE: Do not modify, these disable coverage tracking for this if statement */
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
    uvm_config_db#(virtual Iface_IFID #(NBITS))::set(null, "*", "ifid_dut_iface",
                                                        ifid_dut_iface);

    // Running test...
    run_test("Class_IFID_Test");

    // Stop simulation
    $display("################# SIMULATION ENDED #################");
    $stop;
  end : PROC_RunTest

endmodule
