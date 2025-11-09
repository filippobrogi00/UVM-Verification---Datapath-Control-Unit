// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

/*
* TEST:
  * Wrapper for many environments (useful for different protocols)
  * Starts coverage tracking before initiating a test on a transaction
* */

class Class_ControlUnit_Test extends uvm_test;

  // Register to Factory
  `uvm_component_utils(Class_ControlUnit_Test);

  // Constructor
  function new(string name = "Class_ControlUnit_Test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Environment
  Class_ControlUnit_Environment ctrlunit_environment;

  // Virtual interfaces handles
  virtual Iface_ControlUnit #(OPCODE_SIZE, FUNC_SIZE) ctrlunit_dut_iface;

  /*
  * Test BUILD PHASE : Instantiate and build components declared above
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // coverage off b
    // Get virtual interfaces handles from DB
    if (!uvm_config_db#(virtual Iface_ControlUnit #(OPCODE_SIZE, FUNC_SIZE))::get(
            this, "", "ctrlunit_dut_iface", ctrlunit_dut_iface
        )) begin
      `uvm_fatal("[TEST]", "Could not get DUT interface handle")
    end
    // coverage on b

    // Create Environment
    ctrlunit_environment =
        Class_ControlUnit_Environment::type_id::create("ctrlunit_environment", this);
  endfunction : build_phase


  /*
  * END OF ELABORATION: Print modules hierarchy for easier debug
  * */
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    // Print topology
    // uvm_top.print_topology();  // uvm_top is always the name of the top-level TB module
  endfunction : end_of_elaboration_phase


  /*
  * RUN PHASE:
    * Enable Coverage tracking
    * Start a Sequence for this particular Test
  * */
  virtual task run_phase(uvm_phase phase);
    // Create a Sequence
    Class_ControlUnit_Sequence ctrlunit_sequence = Class_ControlUnit_Sequence::type_id::create(
        "ctrlunit_sequence", this
    );

    // Before starting the test, wait until global reset is de-asserted
    //wait (ctrlunit_dut_iface.rst_n == 1'b1);

    /* Start the test */
    super.run_phase(phase);

    // Do not let phase end
    phase.raise_objection(this);

    // Start Coverage tracking
    ctrlunit_environment.ctrlunit_coverage_tracker.coverageStart();

    // Send Sequence (list of many transactions)
    ctrlunit_sequence.start(ctrlunit_environment.ctrlunit_agent.ctrlunit_sequencer);

    // Stop coverage tracking
    ctrlunit_environment.ctrlunit_coverage_tracker.coverageStop();

    // Phase can now end
    phase.drop_objection(this);

  endtask : run_phase
endclass


