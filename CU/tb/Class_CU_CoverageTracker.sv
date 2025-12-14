// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

import pkg_const::*;

/*
* COVERAGE TRACKER:
  * Implements Covegroups to track Functional Coverage
  * Current Sequence Item is broadcasted by Monitor and received by
  * Coverage Tracker, which then samples coverage.
*/
class Class_CU_CoverageTracker extends uvm_subscriber #(Class_CU_SequenceItem);
  // Register to Factory
  // coverage off bcs
  `uvm_component_utils(Class_CU_CoverageTracker)
  // coverage on bcs

  // Analysis Port implementation (broadcast from Monitor)
  uvm_analysis_imp #(Class_CU_SequenceItem, Class_CU_CoverageTracker) analysis_port_imp;

  // Handle to virtual DUT interface
  virtual Iface_CU #(MICROCODE_MEM_SIZE, FUNC_SIZE, OPCODE_SIZE, IR_SIZE, CW_SIZE) cu_dut_iface;

  /*
  * COVERGROUPS for Functional Coverage
  * */

  // NOTE: "with function sample" => Covergroup parameterized with transaction item
  covergroup Covergroup_CU with function sample (Class_CU_SequenceItem cu_seqitem);

    Coverpoint_IRIN: coverpoint cu_seqitem.IR_IN;

  endgroup : Covergroup_CU

  // Constructor
  function new(string name = "Class_CU_CoverageTracker", uvm_component parent = null);
    super.new(name, parent);
    // Instantiate the covergroup
    Covergroup_CU = new();
  endfunction

  /*
  * FUNCTIONAL COVERAGE UTILITY FUNCTIONS
  * */
  // Start coverage tracking
  virtual function void coverageStart();
    Covergroup_CU.start();
  endfunction

  // Stop coverage tracking
  virtual function void coverageStop();
    Covergroup_CU.stop();
  endfunction

  // Sample coverage at current time
  virtual function void coverageSample(Class_CU_SequenceItem cu_seqitem);
    Covergroup_CU.sample(cu_seqitem);
  endfunction

  // Return coverage
  virtual function real coverageGet();
    return Covergroup_CU.get_inst_coverage();
  endfunction


  /*
  * BUILD PHASE: Create instance of Analysis Port
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // coverage off b

    // Get interface from config DB
    if (!uvm_config_db#(virtual Iface_CU #(MICROCODE_MEM_SIZE, FUNC_SIZE, OPCODE_SIZE, IR_SIZE, CW_SIZE))::get(
            this, "", "cu_dut_iface", cu_dut_iface
        )) begin
      `uvm_error("[COVERAGE TRACKER]", "Failed to get DUT interface")
    end

    // coverage on b

    // Create analysis port
    analysis_port_imp = new("analysis_port_imp", this);
  endfunction : build_phase

  /*
  * WRITE: When Monitor sends a Sequence Item to the Scoreboard and Coverage
  * component, we sample coverage!
  * */
  // NOTE: Superclass uvm_subscriber's write() method has argument name 't',
  //  so it enforces subclasses argument names!
  // NOTE: Wrong to call super.write() as uvm_subscriber class defines write()
  //  method as PURE virtual, meaning only child classes have to give it an
  //  implementation!
  virtual function void write(Class_CU_SequenceItem t);
    // super.write(t);

    // Sample coverage passing in the current Sequence Item broadcasted from
    // Monitor
    coverageSample(t);

  endfunction

  /*
  * REPORT PHASE: Report coverage at end of simulation (phase)
  * */
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    // coverage off bcs
    `uvm_info("BLUE", $sformatf(
              "********** [COVERAGE TRACKER] **********\nFunctional Coverage: %.2f%%", coverageGet()
              ), UVM_MEDIUM);
    // coverage off bcs
  endfunction : report_phase

endclass
