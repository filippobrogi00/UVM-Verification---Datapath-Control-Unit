// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

/*
* ENVIRONMENT:
  * Contains multiple reusable verification components
  * Defines their default configuration as required by the application
  * A "System-level Environment" may also contain sub-"Block-level
  * Environments"
* */

class Class_ControlUnit_Environment extends uvm_env;
  // Register to Factory
  `uvm_component_utils(Class_ControlUnit_Environment)

  // Constructor
  function new(string name = "Class_ControlUnit_Environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Agent
  Class_ControlUnit_Agent ctrlunit_agent;
  // Scoreboard
  Class_ControlUnit_Scoreboard ctrlunit_scoreboard;
  // Coverage Tracker
  Class_ControlUnit_CoverageTracker ctrlunit_coverage_tracker;

  /*
  * BUILD PHASE: Build components
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create components
    ctrlunit_agent = Class_ControlUnit_Agent::type_id::create("ctrlunit_agent", this);
    ctrlunit_scoreboard =
        Class_ControlUnit_Scoreboard::type_id::create("ctrlunit_scoreboard", this);
    ctrlunit_coverage_tracker =
        Class_ControlUnit_CoverageTracker::type_id::create("ctrlunit_coverage_tracker", this);
  endfunction : build_phase

  /*
  * CONNECT PHASE:
    * Connect Analysis Ports from Agent to Scoreboard
    * Connect Functional Coverage component Analysis Ports
  * */
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect Scoreboard's Implementation Port with Monitor's Port
    ctrlunit_agent.ctrlunit_monitor.analysis_port.connect(ctrlunit_scoreboard.analysis_port_imp);

    // Connect CoverageTracker's Implementation port with Monitor's port
    ctrlunit_agent.ctrlunit_monitor.analysis_port.connect(
        ctrlunit_coverage_tracker.analysis_port_imp);
  endfunction : connect_phase


endclass




