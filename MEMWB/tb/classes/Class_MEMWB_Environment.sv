// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* ENVIRONMENT:
  * Contains multiple reusable verification components
  * Defines their default configuration as required by the application
  * A "System-level Environment" may also contain sub-"Block-level
  * Environments"
* */

// Import bins constants
import pkg_const::*;

class Class_MEMWB_Environment extends uvm_env;
  `uvm_component_utils(Class_MEMWB_Environment)

  function new(string name = "Class_MEMWB_Environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  Class_MEMWB_Agent memwb_agent;
  Class_MEMWB_Scoreboard memwb_scoreboard;
  //Class_MEMWB_CoverageTracker memwb_coverage_tracker;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create components
    memwb_agent = Class_MEMWB_Agent::type_id::create("memwb_agent", this);
    memwb_scoreboard =
        Class_MEMWB_Scoreboard::type_id::create("memwb_scoreboard", this);
    //memwb_coverage_tracker =
    //    Class_MEMWB_CoverageTracker::type_id::create("memwb_coverage_tracker", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect Scoreboard's Implementation Port with Monitor's Port
    for (integer i = 0; i < MEMWB_PIPELINE_STAGES; i++)
    memwb_agent.memwb_monitor[i].analysis_port.connect(memwb_scoreboard.analysis_port_imp);

    // Connect CoverageTracker's Implementation port with Monitor's port
    //memwb_agent.memwb_monitor.analysis_port.connect(
    //    memwb_coverage_tracker.analysis_port_imp);
  endfunction : connect_phase


endclass




