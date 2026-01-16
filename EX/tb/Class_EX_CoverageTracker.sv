// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* COVERAGE TRACKER:
  * Implements Covegroups to track Functional Coverage
  * Current Sequence Item is broadcasted by Monitor and received by
  * Coverage Tracker, which then samples coverage.
*/

class Class_EXE_CoverageTracker extends uvm_subscriber #(Class_EXE_SequenceItem);
  // Register to Factory
    // coverage off
  `uvm_component_utils(Class_EXE_CoverageTracker)
    // coverage on

  // Analysis Port implementation (broadcast from Monitor)
  uvm_analysis_imp #(Class_EXE_SequenceItem, Class_EXE_CoverageTracker) analysis_port_imp;

  // Handle to virtual DUT interface
  virtual Iface_EXE #(NBITS) exe_dut_iface;

  /*
  * COVERGROUPS for Functional Coverage
  * */

  // NOTE: "with function sample" => Covergroup parameterized with transaction item
  covergroup Covergroup_EXE with function sample (Class_EXE_SequenceItem exe_seqitem);
    
	// Multi-bit
    Coverpoint_S1_REG_NPC_OUT:		coverpoint exe_seqitem.S1_REG_NPC_OUT;
    Coverpoint_S2_REG_NPC_OUT:		coverpoint exe_seqitem.S2_REG_NPC_OUT;
    Coverpoint_S2_REG_ADD_WR_OUT:	coverpoint exe_seqitem.S2_REG_ADD_WR_OUT;
    Coverpoint_S2_RFILE_A_OUT:		coverpoint exe_seqitem.S2_RFILE_A_OUT;
    Coverpoint_S2_RFILE_B_OUT:		coverpoint exe_seqitem.S2_RFILE_B_OUT;
    Coverpoint_S2_REG_SE_IMM_OUT:	coverpoint exe_seqitem.S2_REG_SE_IMM_OUT;
    Coverpoint_S2_REG_UE_IMM_OUT:	coverpoint exe_seqitem.S2_REG_UE_IMM_OUT;
    Coverpoint_DP_ALU_OPCODE:		coverpoint exe_seqitem.DP_ALU_OPCODE;

    // Single bit
    Coverpoint_S2_FF_JAL_EN_OUT:	coverpoint exe_seqitem.S2_FF_JAL_EN_OUT;
    Coverpoint_MUX_A_SEL:			coverpoint exe_seqitem.MUX_A_SEL;
    Coverpoint_MUX_B_SEL:			coverpoint exe_seqitem.MUX_B_SEL;
    Coverpoint_ALU_OUTREG_EN:		coverpoint exe_seqitem.ALU_OUTREG_EN;
    Coverpoint_EQ_COND:				coverpoint exe_seqitem.EQ_COND;
    Coverpoint_JMP:					coverpoint exe_seqitem.JMP;
    Coverpoint_EQZ_NEQZ:			coverpoint exe_seqitem.EQZ_NEQZ;

  endgroup : Covergroup_EXE

  // Constructor
  function new(string name = "Class_EXE_CoverageTracker", uvm_component parent = null);
    super.new(name, parent);
    // Instantiate the covergroup
    Covergroup_EXE = new();
  endfunction

  /*
  * FUNCTIONAL COVERAGE UTILITY FUNCTIONS
  * */
  // Start coverage tracking
  virtual function void coverageStart();
    Covergroup_EXE.start();
  endfunction

  // Stop coverage tracking
  virtual function void coverageStop();
    Covergroup_EXE.stop();
  endfunction

  // Sample coverage at current time
  virtual function void coverageSample(Class_EXE_SequenceItem exe_seqitem);
    Covergroup_EXE.sample(exe_seqitem);
  endfunction

  // Return coverage
  virtual function real coverageGet();
    return Covergroup_EXE.get_inst_coverage();
  endfunction


  /*
  * BUILD PHASE: Create instance of Analysis Port
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // coverage off

    // Get interface from config DB
    if (!uvm_config_db#(virtual Iface_EXE #(NBITS))::get(
            this, "", "exe_dut_iface", exe_dut_iface
        )) begin
      `uvm_fatal("[COVERAGE TRACKER]", "Failed to get DUT interface")
    end

    // coverage on

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
  virtual function void write(Class_EXE_SequenceItem t);
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
    	// coverage off
    `uvm_info("COVERAGE TRACKER", $sformatf("Functional Coverage: %.2f%%", coverageGet()),
              UVM_MEDIUM);
    	// coverage on
  endfunction : report_phase

endclass
