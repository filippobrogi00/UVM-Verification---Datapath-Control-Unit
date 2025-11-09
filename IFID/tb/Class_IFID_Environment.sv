// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

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
  Class_IFID_Agent p4adder_agent;
  // Scoreboard
  Class_IFID_Scoreboard p4adder_scoreboard;
  // Coverage Tracker
  Class_IFID_CoverageTracker p4adder_coverage_tracker;

  /*
  * BUILD PHASE: Build components
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create components
    p4adder_agent = Class_IFID_Agent::type_id::create("p4adder_agent", this);
    p4adder_scoreboard = Class_IFID_Scoreboard::type_id::create("p4adder_scoreboard", this);
    p4adder_coverage_tracker = Class_IFID_CoverageTracker::type_id::create("p4adder_coverage_tracker", this);
  endfunction : build_phase

  /*
  * CONNECT PHASE:
    * Connect Analysis Ports from Agent to Scoreboard
    * Connect Functional Coverage component Analysis Ports
  * */
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect Scoreboard's Implementation Port with Monitor's Port
    p4adder_agent.p4adder_monitor.analysis_port.connect(p4adder_scoreboard.analysis_port_imp);

    // Connect CoverageTracker's Implementation port with Monitor's port
    p4adder_agent.p4adder_monitor.analysis_port.connect(p4adder_coverage_tracker.analysis_port_imp);
  endfunction : connect_phase


endclass




