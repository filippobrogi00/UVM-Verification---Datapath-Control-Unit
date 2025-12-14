// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* ENVIRONMENT:
  * Contains multiple reusable verification components
  * Defines their default configuration as required by the application
  * A "System-level Environment" may also contain sub-"Block-level
  * Environments"
* */

class Class_CU_Environment extends uvm_env;
  // Register to Factory
  // coverage off bcs
  `uvm_component_utils(Class_CU_Environment)
  // coverage on bcs

  // Constructor
  function new(string name = "Class_CU_Environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Agent
  Class_cunit_agent cunit_agent;
  // Scoreboard
  Class_CU_Scoreboard cu_scoreboard;
  // Coverage Tracker
  Class_CU_CoverageTracker cunit_coverage_tracker;

  /*
  * BUILD PHASE: Build components
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create components
    cunit_agent = Class_cunit_agent::type_id::create("cunit_agent", this);
    cu_scoreboard = Class_CU_Scoreboard::type_id::create("cu_scoreboard", this);
    cunit_coverage_tracker =
        Class_CU_CoverageTracker::type_id::create("cunit_coverage_tracker", this);
  endfunction : build_phase

  /*
  * CONNECT PHASE:
    * Connect Analysis Ports from Agent to Scoreboard
    * Connect Functional Coverage component Analysis Ports
  * */
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect Scoreboard's Implementation Port with Monitor's Port
    cunit_agent.cunit_monitor.analysis_port.connect(cu_scoreboard.analysis_port_imp);

    // Connect CoverageTracker's Implementation port with Monitor's port
    cunit_agent.cunit_monitor.analysis_port.connect(cunit_coverage_tracker.analysis_port_imp);
  endfunction : connect_phase

endclass




