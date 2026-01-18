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

class Class_EXE_Monitor extends uvm_monitor;
  // Register to Factory
  // coverage off
  `uvm_component_utils(Class_EXE_Monitor);
  // coverage on

  // Virtual interface handle (later connected through ::get())
  virtual Iface_EXE #(.NBITS(NBITS))          exe_dut_iface;

  // Analysis Port for broadcasting transaction object to subscriber
  // components
  uvm_analysis_port #(Class_EXE_SequenceItem) analysis_port;

  // Constructor
  function new(string name = "Class_EXE_Monitor", uvm_component parent = null);
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

    // coverage off

    // Get DUT virtual interface handle from configuration DB
    if (!uvm_config_db#(virtual Iface_EXE #(NBITS))::get(
            this, "", "exe_dut_iface", exe_dut_iface
        )) begin
      `uvm_fatal("[MONITOR]", "Could not get handle to DUT interface!")
    end

    // coverage on

  endfunction : build_phase


  /*
  * RUN PHASE:
    * Monitor the interface ( forever ) to catch transactions
    * Write the result into Analysis Port (broadcast to Scoreboard) when
    * complete
  * */
	virtual task run_phase(uvm_phase phase);
		int i = 0;
		super.run_phase(phase);
		forever begin
			// Create TLO to store transaction whole transaction after
			// DUT has calculated outputs and they're available to get from the interface
			Class_EXE_SequenceItem exe_seqitem = Class_EXE_SequenceItem::type_id::create("exe_seqitem", this);

			// Wait clock rising edge
			@(posedge exe_dut_iface.ClockingBlock_EXE);
			// Inputs
			exe_seqitem.nRST				= exe_dut_iface.nRST;
			exe_seqitem.S1_REG_NPC_OUT		= exe_dut_iface.S1_REG_NPC_OUT;
			exe_seqitem.S2_FF_JAL_EN_OUT	= exe_dut_iface.S2_FF_JAL_EN_OUT;
			exe_seqitem.S2_REG_NPC_OUT		= exe_dut_iface.S2_REG_NPC_OUT;
			exe_seqitem.S2_REG_ADD_WR_OUT	= exe_dut_iface.S2_REG_ADD_WR_OUT;
			exe_seqitem.S2_RFILE_A_OUT		= exe_dut_iface.S2_RFILE_A_OUT;
			exe_seqitem.S2_RFILE_B_OUT		= exe_dut_iface.S2_RFILE_B_OUT;
			exe_seqitem.S2_REG_SE_IMM_OUT	= exe_dut_iface.S2_REG_SE_IMM_OUT;
			exe_seqitem.S2_REG_UE_IMM_OUT	= exe_dut_iface.S2_REG_UE_IMM_OUT;

			// Controls
			exe_seqitem.MUX_A_SEL			= exe_dut_iface.MUX_A_SEL;
			exe_seqitem.MUX_B_SEL			= exe_dut_iface.MUX_B_SEL;
			exe_seqitem.ALU_OUTREG_EN		= exe_dut_iface.ALU_OUTREG_EN;
			exe_seqitem.EQ_COND				= exe_dut_iface.EQ_COND;
			exe_seqitem.JMP					= exe_dut_iface.JMP;
			exe_seqitem.EQZ_NEQZ			= exe_dut_iface.EQZ_NEQZ;
			exe_seqitem.DP_ALU_OPCODE		= exe_dut_iface.DP_ALU_OPCODE;

			// Outputs
			exe_seqitem.S3_FF_JAL_EN_OUT	= exe_dut_iface.S3_FF_JAL_EN_OUT;
			exe_seqitem.S3_REG_ADD_WR_OUT	= exe_dut_iface.S3_REG_ADD_WR_OUT;
			exe_seqitem.S3_FF_COND_OUT		= exe_dut_iface.S3_FF_COND_OUT;
			exe_seqitem.S3_REG_ALU_OUT		= exe_dut_iface.S3_REG_ALU_OUT;
			exe_seqitem.S3_REG_DATA_OUT		= exe_dut_iface.S3_REG_DATA_OUT;
			exe_seqitem.S3_REG_NPC_OUT		= exe_dut_iface.S3_REG_NPC_OUT;
	
			/*
			// Injection
			exe_dut_iface.MUX_A_SEL = 1'b0;
		    `uvm_info("BLUE", $sformatf("MUX_A_SEL Injection [Stuck-at-0]: i = %4d", i), UVM_MEDIUM);
			i++;
			*/
			// Broadcast data object to subscribers (Scoreboard and CoverageTracker)
			analysis_port.write(exe_seqitem);
		end

	endtask : run_phase

endclass
