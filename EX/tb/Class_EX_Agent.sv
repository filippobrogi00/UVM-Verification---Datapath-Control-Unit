// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.


/*
* AGENT: Encapsulates Sequencer, Driver and Monitor into a single entity and
* connects them via TLM interfaces.
* */


class Class_EXE_Agent extends uvm_agent;

  // Register to Factory
  // coverage off
  `uvm_component_utils(Class_EXE_Agent)
  // coverage on
  // Constructor
  function new(string name = "Class_EXE_Agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Components instantiation

  /*
  * SEQUENCER:
    * Generates data transactions as Class Objects
    * Sends them to the Driver for "execution"
  * */
  // NOTE: Since Driver is parameterized on SequenceItem, this too!
  uvm_sequencer #(Class_EXE_SequenceItem) exe_sequencer;
  Class_EXE_Driver                        exe_driver;
  Class_EXE_Monitor                       exe_monitor;

  /*
  * BUILD PHASE : Create Monitor, and if Agent is "active", also create Sequencer and Driver
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create Sequencer
    exe_sequencer = uvm_sequencer#(Class_EXE_SequenceItem)::type_id::create("exe_sequencer", this);

    // Create Driver
    exe_driver = Class_EXE_Driver::type_id::create("exe_driver", this);

    // Create Monitor
    exe_monitor = Class_EXE_Monitor::type_id::create("exe_monitor", this);

  endfunction : build_phase

  /*
  * CONNECT PHASE : Connect Sequencer to Driver if agent is active
  * */
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect Driver's Port to Sequencer's Export
    exe_driver.seq_item_port.connect(exe_sequencer.seq_item_export);
  endfunction : connect_phase
endclass

