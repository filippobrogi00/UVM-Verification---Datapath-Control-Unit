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

class Class_ControlUnit_Monitor extends uvm_monitor;
  // Register to Factory
  `uvm_component_utils(Class_ControlUnit_Monitor);

  // Virtual interface handle (later connected through ::get())
  virtual Iface_ControlUnit #(OPCODE_SIZE, FUNC_SIZE) ctrlunit_dut_iface;

  // Analysis Port for broadcasting transaction object to subscriber
  // components
  uvm_analysis_port #(Class_ControlUnit_SequenceItem) analysis_port;

  // Constructor
  function new(string name = "Class_ControlUnit_Monitor", uvm_component parent = null);
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
    if (!uvm_config_db#(virtual Iface_ControlUnit #(OPCODE_SIZE, FUNC_SIZE))::get(
            this, "", "ctrlunit_dut_iface", ctrlunit_dut_iface
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
      Class_ControlUnit_SequenceItem ctrlunit_seqitem = Class_ControlUnit_SequenceItem::type_id::create(
          "ctrlunit_seqitem", this
      );

      /* Save DUT (interface) signals into Sequence Item */

      // Wait DUT clock posedge
      //@(posedge ctrlunit_dut_iface.clk);
      @(ctrlunit_dut_iface.ClockingBlock_ControlUnit);

      // We can save inputs immediately
      ctrlunit_seqitem.opcode = ctrlunit_dut_iface.opcode;
      ctrlunit_seqitem.func   = ctrlunit_dut_iface.func;

      // Wait one CC for sampling first stage signals
      //@(posedge ctrlunit_dut_iface.clk);
      @(ctrlunit_dut_iface.ClockingBlock_ControlUnit);
      ctrlunit_seqitem.rf_rden_port1 = ctrlunit_dut_iface.rf_rden_port1;
      ctrlunit_seqitem.rf_rden_port2 = ctrlunit_dut_iface.rf_rden_port2;
      ctrlunit_seqitem.en_stage1     = ctrlunit_dut_iface.en_stage1;

      // We then wait for a CC to get second stage signals
      //@(posedge ctrlunit_dut_iface.clk);
      @(ctrlunit_dut_iface.ClockingBlock_ControlUnit);
      ctrlunit_seqitem.mux_a_sel  = ctrlunit_dut_iface.mux_a_sel;
      ctrlunit_seqitem.mux_b_sel  = ctrlunit_dut_iface.mux_b_sel;
      ctrlunit_seqitem.alu_op_sel = ctrlunit_dut_iface.alu_op_sel;
      ctrlunit_seqitem.en_stage2  = ctrlunit_dut_iface.en_stage2;

      // Wait a third CC to get third stage signals
      //@(posedge ctrlunit_dut_iface.clk);
      @(ctrlunit_dut_iface.ClockingBlock_ControlUnit);
      ctrlunit_seqitem.mem_rd_en  = ctrlunit_dut_iface.mem_rd_en;
      ctrlunit_seqitem.mem_wr_en  = ctrlunit_dut_iface.mem_wr_en;
      ctrlunit_seqitem.en_stage3  = ctrlunit_dut_iface.en_stage3;
      ctrlunit_seqitem.mux_wb_sel = ctrlunit_dut_iface.mux_wb_sel;
      ctrlunit_seqitem.rf_wren    = ctrlunit_dut_iface.rf_wren;

      // Wait one additional clock
      //@(posedge ctrlunit_dut_iface.clk);
      @(ctrlunit_dut_iface.ClockingBlock_ControlUnit);

      // Broadcast data object to subscribers (Scoreboard and CoverageTracker)
      analysis_port.write(ctrlunit_seqitem);
    end

  endtask : run_phase

endclass
