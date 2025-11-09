// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.


/*
* AGENT: Encapsulates Sequencer, Driver and Monitor into a single entity and
* connects them via TLM interfaces.
* */

class Class_ControlUnit_Agent extends uvm_agent;

  // Register to Factory
  `uvm_component_utils(Class_ControlUnit_Agent)

  // Constructor
  function new(string name = "Class_ControlUnit_Agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Components instantiation

  /*
  * SEQUENCER:
    * Generates data transactions as Class Objects
    * Sends them to the Driver for "execution"
  * */
  // NOTE: Since Driver is parameterized on SequenceItem, this too!
  uvm_sequencer #(Class_ControlUnit_SequenceItem) ctrlunit_sequencer;
  Class_ControlUnit_Driver                        ctrlunit_driver;
  Class_ControlUnit_Monitor                       ctrlunit_monitor;

  /*
  * BUILD PHASE : Create Monitor, and if Agent is "active", also create Sequencer and Driver
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create Sequencer
    ctrlunit_sequencer =
        uvm_sequencer#(Class_ControlUnit_SequenceItem)::type_id::create("ctrlunit_sequencer", this);

    // Create Driver
    ctrlunit_driver = Class_ControlUnit_Driver::type_id::create("ctrlunit_driver", this);

    // Create Monitor
    ctrlunit_monitor = Class_ControlUnit_Monitor::type_id::create("ctrlunit_monitor", this);

  endfunction : build_phase

  /*
  * CONNECT PHASE : Connect Sequencer to Driver if agent is active
  * */
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect Driver's Port to Sequencer's Export
    ctrlunit_driver.seq_item_port.connect(ctrlunit_sequencer.seq_item_export);
  endfunction : connect_phase
endclass


