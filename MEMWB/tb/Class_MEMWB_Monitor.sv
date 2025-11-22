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

  // Virtual interface handle (later connected through ::get())
  virtual Iface_MEMWB #(IR_SIZE) memwb_dut_iface;

  // Analysis Port for broadcasting transaction object to subscriber
  // components
  uvm_analysis_port #(Class_MEMWB_SequenceItem) analysis_port;

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

  // Create instance of declared analysis port
  analysis_port = new("analysis_port", this);

  // Get DUT virtual interface handle from configuration DB
  if (!uvm_config_db#(virtual Iface_MEMWB #(IR_SIZE))::get(
    this, "", "memwb_dut_iface", memwb_dut_iface
  )) begin
    `uvm_error("[MONITOR]", "Could not get handle to DUT interface!")
  end
  endfunction : build_phase


  /*
  * RUN PHASE:
    * Monitor the interface (forever) to catch transactions
    * Write the result into Analysis Port (broadcast to Scoreboard) when
    * complete
  * */
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
      // Create TLO to store transaction whole transaction after
      // DUT has calculated outputs and they're available to get from the interface
      Class_MEMWB_SequenceItem memwb_seqitem = Class_MEMWBt_SequenceItem::type_id::create(
          "MEMWB_seqitem", this
      );

      /* Save DUT (interface) signals into Sequence Item */
      memwb_seitem.DP_TO_DLX_PC      = memwb_dut_iface.DP_TO_DLX_PC;
      memwb_seitem.S4_REG_ADD_WR_OUT = memwb_dut_iface.S4_REG_ADD_WR_OUT;
      memwb_seitem.S5_MUX_DATAIN_OUT = memwb_dut_iface.S4_REG_ADD_WR_OUT;
    
      // Wait DUT clock posedge
      //@(posedge memwb_dut_iface.clk);
      @(memwb_dut_iface.ClockingBlock_ControlUnit);
      
      // Broadcast data object to subscribers (Scoreboard and CoverageTracker)
      analysis_port.write(memwb_seqitem);
    end

  endtask : run_phase

endclass
