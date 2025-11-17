// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* TEST:
  * Wrapper for many environments (useful for different protocols)
  * Starts coverage tracking before initiating a test on a transaction
* */

class Class_EXE_Test extends uvm_test;

  // Register to Factory
  `uvm_component_utils(Class_EXE_Test);

  // Constructor
  function new(string name = "Class_EXE_Test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Environment
  Class_EXE_Environment      exe_environment;

  // Virtual interfaces handles
  virtual Iface_EXE #(NBITS) exe_dut_iface;

  /*
  * Test BUILD PHASE : Instantiate and build components declared above
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // coverage off b

    // Get virtual interfaces handles from DB
    if (!uvm_config_db#(virtual Iface_EXE #(NBITS))::get(
            this, "", "exe_dut_iface", exe_dut_iface
        )) begin
      `uvm_fatal("[TEST]", "Could not get DUT interface handle")
    end

    // coverage on b

    // Create Environment
    exe_environment = Class_EXE_Environment::type_id::create("exe_environment", this);
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
    Class_EXE_Sequence exe_sequence = Class_IFID_Sequence::type_id::create("exe_sequence", this);

    /* Start the test */
    super.run_phase(phase);

    // Do not let phase end
    phase.raise_objection(this);

    // Start Coverage tracking
    exe_environment.exe_coverage_tracker.coverageStart();

    // Send Sequence (list of many transactions)
    exe_sequence.start(exe_environment.exe_agent.exe_sequencer);

    // Stop coverage tracking
    exe_environment.exe_coverage_tracker.coverageStop();

    // Phase can now end
    phase.drop_objection(this);

  endtask : run_phase
endclass


