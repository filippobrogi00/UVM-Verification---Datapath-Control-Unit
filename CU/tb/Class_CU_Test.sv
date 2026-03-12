// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

import pkg_const::*;

/*
* TEST:
  * Wrapper for many environments (useful for different protocols)
  * Starts coverage tracking before initiating a test on a transaction
* */

class Class_CU_Test extends uvm_test;

  // Register to Factory
  // coverage off bcs
  `uvm_component_utils(Class_CU_Test)
  // coverage on bcs

  // Constructor
  function new(string name = "Class_CU_Test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Environment
  Class_CU_Environment                                                             cu_environment;

  // Virtual interfaces handles
  virtual Iface_CU #(MICROCODE_MEM_SIZE, FUNC_SIZE, OPCODE_SIZE, IR_SIZE, CW_SIZE) cu_dut_iface;

  /*
  * Test BUILD PHASE : Instantiate and build components declared above
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // coverage off b

    // Get virtual interfaces handles from DB
    if (!uvm_config_db#(virtual Iface_CU #(MICROCODE_MEM_SIZE, FUNC_SIZE, OPCODE_SIZE, IR_SIZE, CW_SIZE))::get(
            this, "", "cu_dut_iface", cu_dut_iface
        )) begin
      `uvm_fatal("[TEST]", "Could not get DUT interface handle")
    end

    // coverage on b

    // Create Environment
    cu_environment = Class_CU_Environment::type_id::create("cu_environment", this);
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
    // Create "I-TYPE instruction" test sequence
    Class_CU_ITYPE_Sequence cu_itype_sequence = Class_CU_ITYPE_Sequence::type_id::create(
        "cu_itype_sequence", this
    );

    // // Create "R-TYPE instruction" test sequence
    Class_CU_RTYPE_Sequence cu_rtype_sequence = Class_CU_RTYPE_Sequence::type_id::create(
        "cu_rtype_sequence", this
    );

    // // Create "J-TYPE instruction" test sequence
    Class_CU_JTYPE_Sequence cu_jtype_sequence = Class_CU_JTYPE_Sequence::type_id::create(
        "cu_jtype_sequence", this
    );

    // Create "Random Inputs" test sequence
    Class_CU_RandomSequence cu_randomsequence = Class_CU_RandomSequence::type_id::create(
        "cu_randomsequence", this
    );

    /* Start the test */
    super.run_phase(phase);

    // Do not let phase end
    phase.raise_objection(this);

    // Start Coverage tracking
    cu_environment.cunit_coverage_tracker.coverageStart();

    // Start all sequences in parallel
    fork
      cu_itype_sequence.start(cu_environment.cunit_agent.cu_sequencer);
      cu_rtype_sequence.start(cu_environment.cunit_agent.cu_sequencer);
      cu_jtype_sequence.start(cu_environment.cunit_agent.cu_sequencer);
      cu_randomsequence.start(cu_environment.cunit_agent.cu_sequencer);
    join

    // Stop coverage tracking
    cu_environment.cunit_coverage_tracker.coverageStop();

    // Phase can now end
    phase.drop_objection(this);

  endtask : run_phase
endclass


