// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.


/*
* DRIVER:
  * Transaction-Level Objects are received from Sequencer
  * Driver drives them to the design via the interface signals
* */

class Class_EXE_Driver extends uvm_driver #(Class_EXE_SequenceItem);

  // Make driver re-usable
  `uvm_component_utils(Class_EXE_Driver);

  // Constructor
  function new(string name = "Class_EXE_Driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // DUT Virtual interface handle
  virtual Iface_EXE #(NBITS) exe_dut_iface;

  /*
  * BUILD PHASE : Check exe_dut_iface DB variable exists
  * */
  // NOTE:
  // Function because doesn't consume simulation time
  // Virtual because subclasses may overload it again
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // coverage off b

    // Get virtual DUT interface handle from DB
    if (!uvm_config_db#(virtual Iface_EXE #(NBITS))::get(
            this, "", "exe_dut_iface", exe_dut_iface
        )) begin
      `uvm_fatal("[DRIVER]", "Could not get handle to DUT interface!")
    end

    // coverage on b

  endfunction : build_phase

  /*
  * RUN PHASE : Drive DUT interface signals according to the current
  * Transaction-Level Object sent by Sequencer
  * */
  // NOTE:
  // Task because consumes simulation time!
  // Virtual because subclasses may overload it again
  virtual task run_phase(uvm_phase phase);
    // Transaction Object used to store (current) data sent from Sequencer
    Class_EXE_SequenceItem exe_seqitem;

    // Just like in C, in SV, statements must follow variable declarations!
    super.run_phase(phase);

    forever begin
      // `uvm_info("[DRIVER]", $sformatf("Waiting for data item from sequencer"), UVM_MEDIUM);

      // Create new Sequence Item to hold current data item
      exe_seqitem = Class_EXE_SequenceItem::type_id::create("exe_seqitem", this);

      // Get next data item
      seq_item_port.get_next_item(exe_seqitem);

      // Drive signals on DUT interface at posedge
      @(posedge exe_dut_iface.ClockingBlock_EXE);
      // Save DUT (interface) signals into Sequence Item
	  exe_dut_iface.S1_REG_NPC_OUT		= exe_seqitem.S1_REG_NPC_OUT;
	  exe_dut_iface.S2_FF_JAL_EN_OUT	= exe_seqitem.S2_FF_JAL_EN_OUT;
	  exe_dut_iface.S2_REG_NPC_OUT		= exe_seqitem.S2_REG_NPC_OUT;
	  exe_dut_iface.S2_REG_ADD_WR_OUT	= exe_seqitem.S2_REG_ADD_WR_OUT;
	  exe_dut_iface.S2_RFILE_A_OUT		= exe_seqitem.S2_RFILE_A_OUT;
	  exe_dut_iface.S2_RFILE_B_OUT		= exe_seqitem.S2_RFILE_B_OUT;
	  exe_dut_iface.S2_REG_SE_IMM_OUT	= exe_seqitem.S2_REG_SE_IMM_OUT;
	  exe_dut_iface.S2_REG_UE_IMM_OUT	= exe_seqitem.S2_REG_UE_IMM_OUT;
	  exe_dut_iface.MUX_A_SEL			= exe_seqitem.MUX_A_SEL;
	  exe_dut_iface.MUX_B_SEL			= exe_seqitem.MUX_B_SEL;
	  exe_dut_iface.ALU_OUTREG_EN		= exe_seqitem.ALU_OUTREG_EN;
	  exe_dut_iface.EQ_COND				= exe_seqitem.EQ_COND;
	  exe_dut_iface.JMP					= exe_seqitem.JMP;
	  exe_dut_iface.EQZ_NEQZ			= exe_seqitem.EQZ_NEQZ;
	  exe_dut_iface.DP_ALU_OPCODE		= exe_seqitem.DP_ALU_OPCODE;

      // Tell sequence that driver has finished current item
      seq_item_port.item_done();
    end
  endtask : run_phase
endclass



