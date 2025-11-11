// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* MONITOR:
  * Captures signal activity from the DUT (interface)
  * Translates it into Transaction-Level Data Objects that can be sent to
  * other components.
  * Broadcasts TLOs to both Scoreboard and CoverageTracker components
* */


// Import bins constants
import pkg_const::*;

class Class_IFID_Monitor extends uvm_monitor;
  // Register to Factory
  `uvm_component_utils(Class_IFID_Monitor);

  // Virtual interface handle (later connected through ::get())
  virtual Iface_IFID #(.NBITS(NBITS))          ifid_dut_iface;

  // Analysis Port for broadcasting transaction object to subscriber
  // components
  uvm_analysis_port #(Class_IFID_SequenceItem) analysis_port;

  // Constructor
  function new(string name = "Class_IFID_Monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  /*
  * BUILD PHASE: Create covergroup, analysis port, and get virtual interface
  * handle from DB
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create instance of declared analysis port
    analysis_port = new("analysis_port", this);

    // coverage off b

    // Get DUT virtual interface handle from configuration DB
    if (!uvm_config_db#(virtual Iface_IFID #(NBITS))::get(
            this, "", "ifid_dut_iface", ifid_dut_iface
        )) begin
      `uvm_error("[MONITOR]", "Could not get handle to DUT interface!")
    end

    // coverage on b

  endfunction : build_phase


  /*
  * RUN PHASE:
    * Monitor the interface ( forever ) to catch transactions
    * Write the result into Analysis Port (broadcast to Scoreboard) when
    * complete
  * */
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
      // Create TLO to store transaction whole transaction after
      // DUT has calculated outputs and they're available to get from the interface
      Class_IFID_SequenceItem ifid_seqitem = Class_IFID_SequenceItem::type_id::create(
          "ifid_seqitem", this
      );

      // Wait clock rising edge
      @(posedge ifid_dut_iface.ClockingBlock_IFID);
      // Inputs
      ifid_seqitem.DLX_PC_to_DP      = ifid_dut_iface.DLX_PC_to_DP;
      ifid_seqitem.DLX_IR_to_DP      = ifid_dut_iface.DLX_IR_to_DP;
      ifid_seqitem.IR_LATCH_EN       = ifid_dut_iface.IR_LATCH_EN;
      ifid_seqitem.NPC_LATCH_EN      = ifid_dut_iface.NPC_LATCH_EN;
      ifid_seqitem.RegA_LATCH_EN     = ifid_dut_iface.RegA_LATCH_EN;
      ifid_seqitem.SIGN_UNSIGN_EN    = ifid_dut_iface.SIGN_UNSIGN_EN;
      ifid_seqitem.RegIMM_LATCH_EN   = ifid_dut_iface.RegIMM_LATCH_EN;
      ifid_seqitem.JAL_EN            = ifid_dut_iface.JAL_EN;
      ifid_seqitem.RF_WE             = ifid_dut_iface.RF_WE;
      ifid_seqitem.S4_REG_ADD_WR_OUT = ifid_dut_iface.S4_REG_ADD_WR_OUT;
      ifid_seqitem.S5_MUX_DATAIN_OUT = ifid_dut_iface.S5_MUX_DATAIN_OUT;

      // Outputs
      ifid_seqitem.S1_REG_NPC_OUT    = ifid_dut_iface.S1_REG_NPC_OUT;
      ifid_seqitem.S2_REG_NPC_OUT    = ifid_dut_iface.S2_REG_NPC_OUT;
      ifid_seqitem.S2_FF_JAL_EN_OUT  = ifid_dut_iface.S2_FF_JAL_EN_OUT;
      ifid_seqitem.S2_REG_ADD_WR_OUT = ifid_dut_iface.S2_REG_ADD_WR_OUT;
      ifid_seqitem.S2_RFILE_A_OUT    = ifid_dut_iface.S2_RFILE_A_OUT;
      ifid_seqitem.S2_RFILE_B_OUT    = ifid_dut_iface.S2_RFILE_B_OUT;
      ifid_seqitem.S2_REG_SE_IMM_OUT = ifid_dut_iface.S2_REG_SE_IMM_OUT;
      ifid_seqitem.S2_REG_UE_IMM_OUT = ifid_dut_iface.S2_REG_UE_IMM_OUT;
      ifid_seqitem.S1_ADD_OUT        = ifid_dut_iface.S1_ADD_OUT;


      // Broadcast data object to subscribers (Scoreboard and CoverageTracker)
      analysis_port.write(ifid_seqitem);
    end

  endtask : run_phase

endclass
