// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* ENVIRONMENT:
  * Contains multiple reusable verification components
  * Defines their default configuration as required by the application
  * A "System-level Environment" may also contain sub-"Block-level
  * Environments"
* */


class Class_EXE_Environment extends uvm_env;
  // Register to Factory
  // coverage off
  `uvm_component_utils(Class_EXE_Environment)
  // coverage om

  // Constructor
  function new(string name = "Class_EXE_Environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Agent
  Class_EXE_Agent exe_agent;
  // Scoreboard
  Class_EXE_Scoreboard exe_scoreboard;
  // Coverage Tracker
  Class_EXE_CoverageTracker exe_coverage_tracker;

	// Add fault Injector
//  Class_EXE_FaultInjector exe_fault_injector;

  /*
  * BUILD PHASE: Build components
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create components
    exe_agent = Class_EXE_Agent::type_id::create("exe_agent", this);
    exe_scoreboard = Class_EXE_Scoreboard::type_id::create("exe_scoreboard", this);
    exe_coverage_tracker = Class_EXE_CoverageTracker::type_id::create("exe_coverage_tracker", this);

	// Create Fault Injector
//    exe_fault_injector = Class_EXE_FaultInjector::type_id::create("exe_fault_injector", this);

	endfunction : build_phase

  /*
  * CONNECT PHASE:
    * Connect Analysis Ports from Agent to Scoreboard
    * Connect Functional Coverage component Analysis Ports
  * */
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect Scoreboard's Implementation Port with Monitor's Port
    exe_agent.exe_monitor.analysis_port.connect(exe_scoreboard.analysis_port_imp);

    // Connect CoverageTracker's Implementation port with Monitor's port
    exe_agent.exe_monitor.analysis_port.connect(exe_coverage_tracker.analysis_port_imp);
  endfunction : connect_phase

endclass

