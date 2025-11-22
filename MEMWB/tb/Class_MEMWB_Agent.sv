// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.


/*
* AGENT: Encapsulates Sequencer, Driver and Monitor into a single entity and
* connects them via TLM interfaces.
* */

class Class_MEMWB_Agent extends uvm_agent;

  // Register to Factory
  `uvm_component_utils(Class_MEMWB_Agent)

  // Constructor
  function new(string name = "Class_MEMWB_Agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Components instantiation

  /*
  * SEQUENCER:
    * Generates data transactions as Class Objects
    * Sends them to the Driver for "execution"
  * */
  // NOTE: Since Driver is parameterized on SequenceItem, this too!
  uvm_sequencer #(Class_MEMWB_SequenceItem) memwb_sequencer;
  Class_MEMWB_Driver                        memwb_driver;
  Class_MEMWB_Monitor                       memwb_monitor;

  /*
  * BUILD PHASE : Create Monitor, and if Agent is "active", also create Sequencer and Driver
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create Sequencer
    memwb_sequencer =
        uvm_sequencer#(Class_MEMWB_SequenceItem)::type_id::create("memwb_sequencer", this);

    // Create Driver
    memwb_driver = Class_MEMWB_Driver::type_id::create("memwb_driver", this);

    // Create Monitor
    memwb_monitor = Class_MEMWB_Monitor::type_id::create("memwb_monitor", this);

  endfunction : build_phase

  /*
  * CONNECT PHASE : Connect Sequencer to Driver if agent is active
  * */
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect Driver's Port to Sequencer's Export
    memwb_driver.seq_item_port.connect(memwb_sequencer.seq_item_export);
  endfunction : connect_phase
endclass
