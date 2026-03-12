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

class Class_MEMWB_Monitor extends uvm_monitor;
  // Register to Factory
  `uvm_component_utils(Class_MEMWB_Monitor);

  virtual Iface_MEMWB #(IR_SIZE) memwb_dut_iface;

  // Analysis Port for broadcasting transaction object to subscriber
  // components
  uvm_analysis_port #(Class_MEMWB_SequenceItem) analysis_port;

  integer wait_cycles = 0;

  // Constructor
  function new(string name = "Class_MEMWB_Monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  /*
  * BUILD PHASE: Create covergroup, analysis port, and get virtual interface
  * handle from DB
  * */
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  analysis_port = new("analysis_port", this);

  if (!uvm_config_db#(virtual Iface_MEMWB #(IR_SIZE))::get(
    this, "", "memwb_dut_iface", memwb_dut_iface
  )) begin
    `uvm_error("[MONITOR]", "Could not get handle to DUT interface!")
  end
  endfunction : build_phase


  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    // Wait for reset signal
    //@(posedge memwb_dut_iface.rst_n);

    //Wait for the delay specified delay
    repeat (wait_cycles) @(memwb_dut_iface.ClockingBlock_MEMWB);
    //repeat (wait_cycles) @(posedge memwb_dut_iface.clk);
    forever begin
      // Create TLO to store transaction whole transaction after
      // DUT has calculated outputs and they're available to get from the interface
      Class_MEMWB_SequenceItem memwb_seqitem = Class_MEMWB_SequenceItem::type_id::create(
          "MEMWB_seqitem", this
      );

      // Sample inputs

      @(memwb_dut_iface.ClockingBlock_MEMWB);
      //@(posedge memwb_dut_iface.clk);
      memwb_seqitem.DRAM_OUT          = memwb_dut_iface.DRAM_OUT;
      memwb_seqitem.S1_ADD_OUT        = memwb_dut_iface.S1_ADD_OUT;
      memwb_seqitem.S3_REG_NPC_OUT    = memwb_dut_iface.S3_REG_NPC_OUT;
      memwb_seqitem.S3_REG_ALU_OUT    = memwb_dut_iface.S3_REG_ALU_OUT;
      memwb_seqitem.S3_REG_DATA_OUT   = memwb_dut_iface.S3_REG_DATA_OUT;

      memwb_seqitem.RST_N             = memwb_dut_iface.rst_n;
      memwb_seqitem.S3_FF_JAL_EN_OUT  = memwb_dut_iface.S3_FF_JAL_EN_OUT;
      memwb_seqitem.S3_FF_COND_OUT    = memwb_dut_iface.S3_FF_COND_OUT;
      memwb_seqitem.DRAM_WE           = memwb_dut_iface.DRAM_WE;
      memwb_seqitem.LMD_LATCH_EN      = memwb_dut_iface.LMD_LATCH_EN;
      memwb_seqitem.JUMP_EN           = memwb_dut_iface.JUMP_EN;
      memwb_seqitem.PC_LATCH_EN       = memwb_dut_iface.PC_LATCH_EN;
      memwb_seqitem.RF_WE             = memwb_dut_iface.RF_WE;

      memwb_seqitem.S3_REG_ADD_WR_OUT = memwb_dut_iface.S3_REG_ADD_WR_OUT;


      //Sample unpipelined inputs
      memwb_seqitem.WB_MUX_SEL        = memwb_dut_iface.WB_MUX_SEL;

      // Sample outputs
      memwb_seqitem.DP_TO_DLX_PC      = memwb_dut_iface.DP_TO_DLX_PC;
      memwb_seqitem.S4_REG_ADD_WR_OUT = memwb_dut_iface.S4_REG_ADD_WR_OUT;
      memwb_seqitem.S5_MUX_DATAIN_OUT = memwb_dut_iface.S5_MUX_DATAIN_OUT;

      // Broadcast data object to subscribers (Scoreboard and CoverageTracker)
      analysis_port.write(memwb_seqitem);
    end
  endtask : run_phase
endclass
