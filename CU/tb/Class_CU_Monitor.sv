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

class Class_CU_Monitor extends uvm_monitor;
  // Register to Factory
  // coverage off bcs
  `uvm_component_utils(Class_CU_Monitor)
  // coverage on bcs

  // Virtual interface handle (later connected through ::get())
  virtual Iface_CU #(.NBITS(NBITS))          cu_dut_iface;

  // Analysis Port for broadcasting transaction object to subscriber
  // components
  uvm_analysis_port #(Class_CU_SequenceItem) analysis_port;

  // Constructor
  function new(string name = "Class_CU_Monitor", uvm_component parent = null);
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
    if (!uvm_config_db#(virtual Iface_CU #(NBITS))::get(
            this, "", "cu_dut_iface", cu_dut_iface
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
      Class_CU_SequenceItem cu_seqitem = Class_CU_SequenceItem::type_id::create("cu_seqitem", this);

      // Wait clock rising edge
      @(posedge cu_dut_iface.ClockingBlock_CU);
      /* INPUTS */
      cu_seqitem.IR_IN           = cu_dut_iface.IR_IN;

      /* OUTPUTS */
      // Stage 1
      cu_seqitem.IR_LATCH_EN     = cu_dut_iface.IR_LATCH_EN;
      cu_seqitem.NPC_LATCH_EN    = cu_dut_iface.NPC_LATCH_EN;
      // Stage 2
      cu_seqitem.RegA_LATCH_EN   = cu_dut_iface.RegA_LATCH_EN;
      cu_seqitem.RegB_LATCH_EN   = cu_dut_iface.RegB_LATCH_EN;
      cu_seqitem.RegIMM_LATCH_EN = cu_dut_iface.RegIMM_LATCH_EN;
      cu_seqitem.JAL_EN          = cu_dut_iface.JAL_EN;
      // Stage 3
      cu_seqitem.MUXA_SEL        = cu_dut_iface.MUXA_SEL;
      cu_seqitem.MUXB_SEL        = cu_dut_iface.MUXB_SEL;
      cu_seqitem.ALU_OUTREG_EN   = cu_dut_iface.ALU_OUTREG_EN;
      cu_seqitem.EQ_COND         = cu_dut_iface.EQ_COND;
      cu_seqitem.JMP             = cu_dut_iface.JMP;
      cu_seqitem.EQZ_NEQZ        = cu_dut_iface.EQZ_NEQZ;
      cu_seqitem.ALU_OPCODE      = cu_dut_iface.ALU_OPCODE;
      // Stage 4
      cu_seqitem.DRAM_WE         = cu_dut_iface.DRAM_WE;
      cu_seqitem.LMD_LATCH_EN    = cu_dut_iface.LMD_LATCH_EN;
      cu_seqitem.JUMP_EN         = cu_dut_iface.JUMP_EN;
      cu_seqitem.PC_LATCH_EN     = cu_dut_iface.PC_LATCH_EN;
      // Stage 5
      cu_seqitem.WB_MUX_SEL      = cu_dut_iface.WB_MUX_SEL;
      cu_seqitem.RF_WE           = cu_dut_iface.RF_WE;


      // Broadcast data object to subscribers (Scoreboard and CoverageTracker)
      analysis_port.write(cu_seqitem);
    end

  endtask : run_phase

endclass
