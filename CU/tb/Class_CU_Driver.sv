// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.


/*
* DRIVER:
  * Transaction-Level Objects are received from Sequencer
  * Driver drives them to the design via the interface signals
* */

class Class_CU_Driver extends uvm_driver #(Class_CU_SequenceItem);

  // Make driver re-usable
  // coverage off bcs
  `uvm_component_utils(Class_CU_Driver)
  // coverage on bcs

  // Constructor
  function new(string name = "Class_CU_Driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // DUT Virtual interface handle
  virtual Iface_CU #(NBITS) cu_dut_iface;

  /*
  * BUILD PHASE : Check cu_dut_iface DB variable exists
  * */
  // NOTE:
  // Function because doesn't consume simulation time
  // Virtual because subclasses may overload it again
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // coverage off b

    // Get virtual DUT interface handle from DB
    if (!uvm_config_db#(virtual Iface_CU #(NBITS))::get(
            this, "", "cu_dut_iface", cu_dut_iface
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
    Class_CU_SequenceItem cu_seqitem;

    // Just like in C, in SV, statements must follow variable declarations!
    super.run_phase(phase);

    forever begin
      // `uvm_info("[DRIVER]", $sformatf("Waiting for data item from sequencer"), UVM_MEDIUM);

      // Create new Sequence Item to hold current data item
      cu_seqitem = Class_CU_SequenceItem::type_id::create("cu_seqitem", this);

      // Get next data item
      seq_item_port.get_next_item(cu_seqitem);

      // Pass next instruction (IR) to CU each CC
      @(posedge cu_dut_iface.ClockingBlock_CU);
      /* INPUTS */
      cu_dut_iface.IR_IN           = cu_seqitem.IR_IN;

      /* OUTPUTS */
      // Stage 1
      cu_dut_iface.IR_LATCH_EN     = cu_seqitem.IR_LATCH_EN;
      cu_dut_iface.NPC_LATCH_EN    = cu_seqitem.NPC_LATCH_EN;
      // Stage 2
      cu_dut_iface.RegA_LATCH_EN   = cu_seqitem.RegA_LATCH_EN;
      cu_dut_iface.RegB_LATCH_EN   = cu_seqitem.RegB_LATCH_EN;
      cu_dut_iface.RegIMM_LATCH_EN = cu_seqitem.RegIMM_LATCH_EN;
      cu_dut_iface.JAL_EN          = cu_seqitem.JAL_EN;
      // Stage 3
      cu_dut_iface.MUXA_SEL        = cu_seqitem.MUXA_SEL;
      cu_dut_iface.MUXB_SEL        = cu_seqitem.MUXB_SEL;
      cu_dut_iface.ALU_OUTREG_EN   = cu_seqitem.ALU_OUTREG_EN;
      cu_dut_iface.EQ_COND         = cu_seqitem.EQ_COND;
      cu_dut_iface.JMP             = cu_seqitem.JMP;
      cu_dut_iface.EQZ_NEQZ        = cu_seqitem.EQZ_NEQZ;
      cu_dut_iface.ALU_OPCODE      = cu_seqitem.ALU_OPCODE;
      // Stage 4
      cu_dut_iface.DRAM_WE         = cu_seqitem.DRAM_WE;
      cu_dut_iface.LMD_LATCH_EN    = cu_seqitem.LMD_LATCH_EN;
      cu_dut_iface.JUMP_EN         = cu_seqitem.JUMP_EN;
      cu_dut_iface.PC_LATCH_EN     = cu_seqitem.PC_LATCH_EN;
      // Stage 5
      cu_dut_iface.WB_MUX_SEL      = cu_seqitem.WB_MUX_SEL;
      cu_dut_iface.RF_WE           = cu_seqitem.RF_WE;

      // Tell sequence that driver has finished current item
      seq_item_port.item_done();
    end
  endtask : run_phase
endclass



