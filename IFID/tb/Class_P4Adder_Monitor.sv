// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

/*
* MONITOR:
  * Captures signal activity from the DUT (interface)
  * Translates it into Transaction-Level Data Objects that can be sent to
  * other components.
  * Broadcasts TLOs to both Scoreboard and CoverageTracker components
* */


// Import bins constants
import pkg_const::*;

class Class_P4Adder_Monitor extends uvm_monitor;
  // Register to Factory
  `uvm_component_utils(Class_P4Adder_Monitor);

  // Virtual interface handle (later connected through ::get())
  virtual Iface_P4Adder #(.NBITS(NBITS))          p4adder_dut_iface;
  virtual Iface_MockClock                         p4adder_clk_iface;

  // Analysis Port for broadcasting transaction object to subscriber
  // components
  uvm_analysis_port #(Class_P4Adder_SequenceItem) analysis_port;

  // Constructor
  function new(string name = "Class_P4Adder_Monitor", uvm_component parent = null);
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
    if (!uvm_config_db#(virtual Iface_P4Adder #(NBITS))::get(
            this, "", "p4adder_dut_iface", p4adder_dut_iface
        )) begin
      `uvm_error("[MONITOR]", "Could not get handle to DUT interface!")
    end

    // Get Mock CLock virtual interface handle from configuration DB
    if (!uvm_config_db#(virtual Iface_MockClock)::get(
            this, "", "p4adder_clk_iface", p4adder_clk_iface
        )) begin
      `uvm_error("[MONITOR]", "Could not get handle to Mock Clock interface!")
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
      Class_P4Adder_SequenceItem p4adder_seqitem = Class_P4Adder_SequenceItem::type_id::create(
          "p4adder_seqitem", this
      );

      // Wait mock clock rising edge
      @(posedge p4adder_clk_iface.mockClock);
      // Save DUT (interface) signals into Sequence Item
      p4adder_seqitem.A = p4adder_dut_iface.A;
      p4adder_seqitem.B = p4adder_dut_iface.B;
      p4adder_seqitem.Cin = p4adder_dut_iface.Cin;
      p4adder_seqitem.Sum = p4adder_dut_iface.Sum;
      p4adder_seqitem.Cout = p4adder_dut_iface.Cout;

      // Broadcast data object to subscribers (Scoreboard and CoverageTracker)
      analysis_port.write(p4adder_seqitem);
    end

  endtask : run_phase

endclass
