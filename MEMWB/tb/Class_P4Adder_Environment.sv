// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

/*
* ENVIRONMENT:
  * Contains multiple reusable verification components
  * Defines their default configuration as required by the application
  * A "System-level Environment" may also contain sub-"Block-level
  * Environments"
* */

class Class_P4Adder_Environment extends uvm_env;
  // Register to Factory
  `uvm_component_utils(Class_P4Adder_Environment)

  // Constructor
  function new(string name = "Class_P4Adder_Environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Agent
  Class_P4Adder_Agent p4adder_agent;
  // Scoreboard
  Class_P4Adder_Scoreboard p4adder_scoreboard;
  // Coverage Tracker
  Class_P4Adder_CoverageTracker p4adder_coverage_tracker;

  /*
  * BUILD PHASE: Build components
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create components
    p4adder_agent = Class_P4Adder_Agent::type_id::create("p4adder_agent", this);
    p4adder_scoreboard = Class_P4Adder_Scoreboard::type_id::create("p4adder_scoreboard", this);
    p4adder_coverage_tracker =
        Class_P4Adder_CoverageTracker::type_id::create("p4adder_coverage_tracker", this);
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




