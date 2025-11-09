// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

/*
* TEST:
  * Wrapper for many environments (useful for different protocols)
  * Starts coverage tracking before initiating a test on a transaction
* */

class Class_P4Adder_Test extends uvm_test;

  // Register to Factory
  `uvm_component_utils(Class_P4Adder_Test);

  // Constructor
  function new(string name = "Class_P4Adder_Test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Environment
  Class_P4Adder_Environment      p4adder_environment;

  // Virtual interfaces handles
  virtual Iface_P4Adder #(NBITS) p4adder_dut_iface;
  virtual Iface_MockClock        p4adder_clk_iface;

  /*
  * Test BUILD PHASE : Instantiate and build components declared above
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // coverage off b

    // Get virtual interfaces handles from DB
    if (!uvm_config_db#(virtual Iface_P4Adder #(NBITS))::get(
            this, "", "p4adder_dut_iface", p4adder_dut_iface
        )) begin
      `uvm_fatal("[TEST]", "Could not get DUT interface handle")
    end

    if (!uvm_config_db#(virtual Iface_MockClock)::get(
            this, "", "p4adder_clk_iface", p4adder_clk_iface
        )) begin
      `uvm_fatal("[TEST]", "Could not get Mock Clock interface handle")
    end

    // coverage on b

    // Create Environment
    p4adder_environment = Class_P4Adder_Environment::type_id::create("p4adder_environment", this);
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
    Class_P4Adder_Sequence p4adder_sequence = Class_P4Adder_Sequence::type_id::create(
        "p4adder_sequence", this
    );

    /* Start the test */
    super.run_phase(phase);

    // Do not let phase end
    phase.raise_objection(this);

    // Start Coverage tracking
    p4adder_environment.p4adder_coverage_tracker.coverageStart();

    // Send Sequence (list of many transactions)
    p4adder_sequence.start(p4adder_environment.p4adder_agent.p4adder_sequencer);

    // Stop coverage tracking
    p4adder_environment.p4adder_coverage_tracker.coverageStop();

    // Phase can now end
    phase.drop_objection(this);

  endtask : run_phase
endclass


