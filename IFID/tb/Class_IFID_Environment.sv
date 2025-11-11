// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* ENVIRONMENT:
  * Contains multiple reusable verification components
  * Defines their default configuration as required by the application
  * A "System-level Environment" may also contain sub-"Block-level
  * Environments"
* */

class Class_IFID_Environment extends uvm_env;
  // Register to Factory
  `uvm_component_utils(Class_IFID_Environment)

  // Constructor
  function new(string name = "Class_IFID_Environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Agent
  Class_IFID_Agent ifid_agent;
  // Scoreboard
  Class_IFID_Scoreboard ifid_scoreboard;
  // Coverage Tracker
  Class_IFID_CoverageTracker ifid_coverage_tracker;

  /*
  * BUILD PHASE: Build components
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create components
    ifid_agent = Class_IFID_Agent::type_id::create("ifid_agent", this);
    ifid_scoreboard = Class_IFID_Scoreboard::type_id::create("ifid_scoreboard", this);
    ifid_coverage_tracker =
        Class_IFID_CoverageTracker::type_id::create("ifid_coverage_tracker", this);
  endfunction : build_phase

  /*
  * CONNECT PHASE:
    * Connect Analysis Ports from Agent to Scoreboard
    * Connect Functional Coverage component Analysis Ports
  * */
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect Scoreboard's Implementation Port with Monitor's Port
    ifid_agent.ifid_monitor.analysis_port.connect(ifid_scoreboard.analysis_port_imp);

    // Connect CoverageTracker's Implementation port with Monitor's port
    ifid_agent.ifid_monitor.analysis_port.connect(ifid_coverage_tracker.analysis_port_imp);
  endfunction : connect_phase


endclass




