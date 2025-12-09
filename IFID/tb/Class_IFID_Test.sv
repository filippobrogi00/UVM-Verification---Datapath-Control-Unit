// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* TEST:
  * Wrapper for many environments (useful for different protocols)
  * Starts coverage tracking before initiating a test on a transaction
* */

class Class_IFID_Test extends uvm_test;

  // Register to Factory
  // coverage off bcs
  `uvm_component_utils(Class_IFID_Test)
  // coverage on bcs

  // Constructor
  function new(string name = "Class_IFID_Test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Environment
  Class_IFID_Environment      ifid_environment;

  // Virtual interfaces handles
  virtual Iface_IFID #(NBITS) ifid_dut_iface;

  /*
  * Test BUILD PHASE : Instantiate and build components declared above
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // coverage off b

    // Get virtual interfaces handles from DB
    if (!uvm_config_db#(virtual Iface_IFID #(NBITS))::get(
            this, "", "ifid_dut_iface", ifid_dut_iface
        )) begin
      `uvm_fatal("[TEST]", "Could not get DUT interface handle")
    end

    // coverage on b

    // Create Environment
    ifid_environment = Class_IFID_Environment::type_id::create("ifid_environment", this);
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

    /* SEQUENCES CREATION */
    // Create "Legal Inputs" test sequence
    Class_IFID_LegalSequence ifid_legalsequence = Class_IFID_LegalSequence::type_id::create(
        "ifid_legalsequence", this
    );

    // Create "Random Inputs" test sequence
    Class_IFID_RandomSequence ifid_randomsequence = Class_IFID_RandomSequence::type_id::create(
        "ifid_randomsequence", this
    );

    // Create "Addition" test sequence
    Class_IFID_AdditionSequence ifid_additionsequence = Class_IFID_AdditionSequence::type_id::create(
        "ifid_legalsequence", this
    );

    /* Start the test */
    super.run_phase(phase);

    // Do not let phase end
    phase.raise_objection(this);

    // Start Coverage tracking
    ifid_environment.ifid_coverage_tracker.coverageStart();

    // Start all sequences in parallel
    fork
      ifid_legalsequence.start(ifid_environment.ifid_agent.ifid_sequencer);
      ifid_randomsequence.start(ifid_environment.ifid_agent.ifid_sequencer);
      ifid_additionsequence.start(ifid_environment.ifid_agent.ifid_sequencer);
    join

    // Stop coverage tracking
    ifid_environment.ifid_coverage_tracker.coverageStop();

    // Phase can now end
    phase.drop_objection(this);

  endtask : run_phase
endclass


