// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.


/*
* AGENT: Encapsulates Sequencer, Driver and Monitor into a single entity and
* connects them via TLM interfaces.
* */

class Class_CU_Agent extends uvm_agent;

  // Register to Factory
  // coverage off bcs
  `uvm_component_utils(Class_CU_Agent)
  // coverage on bcs

  // Constructor
  function new(string name = "Class_CU_Agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Components instantiation

  /*
  * SEQUENCER:
    * Generates data transactions as Class Objects
    * Sends them to the Driver for "execution"
  * */
  // NOTE: Since Driver is parameterized on SequenceItem, this too!
  uvm_sequencer #(Class_CU_SequenceItem) cu_sequencer;
  Class_CU_Driver                        cu_driver;
  Class_CU_Monitor                       cu_monitor;

  /*
  * BUILD PHASE : Create Monitor, and if Agent is "active", also create Sequencer and Driver
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create Sequencer
    cu_sequencer = uvm_sequencer#(Class_CU_SequenceItem)::type_id::create("cu_sequencer", this);

    // Create Driver
    cu_driver = Class_CU_Driver::type_id::create("cu_driver", this);

    // Create Monitor
    cu_monitor = Class_CU_Monitor::type_id::create("cu_monitor", this);

  endfunction : build_phase

  /*
  * CONNECT PHASE : Connect Sequencer to Driver if agent is active
  * */
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect Driver's Port to Sequencer's Export
    cu_driver.seq_item_port.connect(cu_sequencer.seq_item_export);
  endfunction : connect_phase
endclass


