// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* COVERAGE TRACKER:
  * Implements Covegroups to track Functional Coverage
  * Current Sequence Item is broadcasted by Monitor and received by
  * Coverage Tracker, which then samples coverage.
*/

class Class_IFID_CoverageTracker extends uvm_subscriber #(Class_IFID_SequenceItem);
  // Register to Factory
  `uvm_component_utils(Class_IFID_CoverageTracker)

  // Analysis Port implementation (broadcast from Monitor)
  uvm_analysis_imp #(Class_IFID_SequenceItem, Class_IFID_CoverageTracker) analysis_port_imp;

  // Handle to virtual DUT interface
  virtual Iface_IFID #(NBITS) ifid_dut_iface;

  /*
  * COVERGROUPS for Functional Coverage
  * */

  // NOTE: "with function sample" => Covergroup parameterized with transaction item
  covergroup Covergroup_IFID with function sample (Class_IFID_SequenceItem ifid_seqitem);

    // Multi-bit
    Coverpoint_DLX_PC_to_DP: coverpoint ifid_seqitem.DLX_PC_to_DP;
    Coverpoint_DLX_IR_to_DP: coverpoint ifid_seqitem.DLX_IR_to_DP;

    // Single bit
    Coverpoint_IR_LATCH_EN: coverpoint ifid_seqitem.IR_LATCH_EN;
    Coverpoint_NPC_LATCH_EN: coverpoint ifid_seqitem.NPC_LATCH_EN;
    Coverpoint_RegA_LATCH_EN: coverpoint ifid_seqitem.RegA_LATCH_EN;
    Coverpoint_SIGN_UNSIGN_EN: coverpoint ifid_seqitem.SIGN_UNSIGN_EN;
    Coverpoint_RegIMM_LATCH_EN: coverpoint ifid_seqitem.RegIMM_LATCH_EN;
    Coverpoint_JAL_EN: coverpoint ifid_seqitem.JAL_EN;
    Coverpoint_RF_WE: coverpoint ifid_seqitem.RF_WE;

    // Multi-bit
    Coverpoint_S4_REG_ADD_WR_OUT: coverpoint ifid_seqitem.S4_REG_ADD_WR_OUT;
    Coverpoint_S5_MUX_DATAIN_OUT: coverpoint ifid_seqitem.S5_MUX_DATAIN_OUT;

  endgroup : Covergroup_IFID

  // Constructor
  function new(string name = "Class_IFID_CoverageTracker", uvm_component parent = null);
    super.new(name, parent);
    // Instantiate the covergroup
    Covergroup_IFID = new();
  endfunction

  /*
  * FUNCTIONAL COVERAGE UTILITY FUNCTIONS
  * */
  // Start coverage tracking
  virtual function void coverageStart();
    Covergroup_IFID.start();
  endfunction

  // Stop coverage tracking
  virtual function void coverageStop();
    Covergroup_IFID.stop();
  endfunction

  // Sample coverage at current time
  virtual function void coverageSample(Class_IFID_SequenceItem ifid_seqitem);
    Covergroup_IFID.sample(ifid_seqitem);
  endfunction

  // Return coverage
  virtual function real coverageGet();
    return Covergroup_IFID.get_inst_coverage();
  endfunction


  /*
  * BUILD PHASE: Create instance of Analysis Port
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // coverage off b

    // Get interface from config DB
    if (!uvm_config_db#(virtual Iface_IFID #(NBITS))::get(
            this, "", "ifid_dut_iface", ifid_dut_iface
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
  virtual function void write(Class_IFID_SequenceItem t);
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
    `uvm_info("COVERAGE TRACKER", $sformatf("Functional Coverage: %.2f%%", coverageGet()),
              UVM_MEDIUM);
  endfunction : report_phase

endclass
