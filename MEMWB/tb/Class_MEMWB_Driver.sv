// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.


/*
* DRIVER:
  * Transaction-Level Objects are received from Sequencer
  * Driver drives them to the design via the interface signals
* */

class Class_MEMWB_Driver extends uvm_driver #(Class_MEMWB_SequenceItem);

  // Make driver re-usable
  `uvm_component_utils(Class_MEMWB_Driver);

  // Constructor
  function new(string name = "Class_MEMWB_Driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // DUT Virtual interface handle
  virtual Iface_MEMWB #(IR_SIZE) memwb_dut_iface;

  /*
  * BUILD PHASE : Check memwb_dut_iface DB variable exists
  * */
  // NOTE:
  // Function because doesn't consume simulation time
  // Virtual because subclasses may overload it again
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // coverage off b
    // Get virtual DUT interface handle from DB
    if (!uvm_config_db#(virtual Iface_MEMWB #(IR_SIZE))::get(
            this, "", "memwb_dut_iface", memwb_dut_iface
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
    Class_MEMWB_SequenceItem memwb_seqitem;

    // Just like in C, in SV, statements must follow variable declarations!
    super.run_phase(phase);

    forever begin
      // Create new Sequence Item to hold current data item
      memwb_seqitem = Class_MEMWB_SequenceItem::type_id::create("memwb_seqitem", this);

      // Get next data item
      seq_item_port.get_next_item(memwb_seqitem);

      // Drive DUT interface input signals at clock posedge
      @(memwb_dut_iface.ClockingBlock_MEMWB);
      memwb_dut_iface.DRAM_OUT          = memwb_seqitem.DRAM_OUT;
      memwb_dut_iface.S1_ADD_OUT        = memwb_seqitem.S1_ADD_OUT;
      memwb_dut_iface.S3_REG_NPC_OUT    = memwb_seqitem.S3_REG_NPC_OUT;
      memwb_dut_iface.S3_REG_ALU_OUT    = memwb_seqitem.S3_REG_ALU_OUT;
      memwb_dut_iface.S3_REG_DATA_OUT   = memwb_seqitem.S3_REG_DATA_OUT;

      memwb_dut_iface.S3_JAL_EN_OUT     = memwb_seqitem.S3_JAL_EN_OUT;
      memwb_dut_iface.S3_FF_COND_OUT    = memwb_seqitem.S3_FF_COND_OUT;
      memwb_dut_iface.DRAM_WE           = memwb_seqitem.DRAM_WE;
      memwb_dut_iface.LMD_LATCH_EN      = memwb_seqitem.LMD_LATCH_EN;
      memwb_dut_iface.JUMB_EN           = memwb_seqitem.JUMB_EN;
      memwb_dut_iface.PC_LATCH_EN       = memwb_seqitem.PC_LATCH_EN;
      memwb_dut_iface.WB_MUX_SEL        = memwb_seqitem.WB_MUX_SEL;
      memwb_dut_iface.RF_WE             = memwb_seqitem.RF_WE;

      memwb_dut_iface.S3_REG_ADD_WR_OUT = memwb_seqitem.S3_REG_ADD_WR_OUT;

      // Tell sequence that driver has finished current item
      seq_item_port.item_done();
    end
  endtask : run_phase
endclass
