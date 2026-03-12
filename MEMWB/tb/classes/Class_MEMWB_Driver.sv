// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* DRIVER:
  * Transaction-Level Objects are received from Sequencer
  * Driver drives them to the design via the interface signals
* */

class Class_MEMWB_Driver extends uvm_driver #(Class_MEMWB_SequenceItem);
  `uvm_component_utils(Class_MEMWB_Driver);

  function new(string name = "Class_MEMWB_Driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual Iface_MEMWB #(IR_SIZE) memwb_dut_iface;

  // NOTE:
  // Function because doesn't consume simulation time
  // Virtual because subclasses may overload it again
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual Iface_MEMWB #(IR_SIZE))::get(
            this, "", "memwb_dut_iface", memwb_dut_iface
        )) begin
      `uvm_fatal("[DRIVER]", "Could not get handle to DUT interface!")
    end

  endfunction : build_phase

  // NOTE:
  // Task because consumes simulation time!
  // Virtual because subclasses may overload it again
  virtual task run_phase(uvm_phase phase);
    Class_MEMWB_SequenceItem memwb_seqitem;
    int fault_detected = 0;

    super.run_phase(phase);

    //Wait for reset
    @(posedge memwb_dut_iface.rst_n);

    forever begin
      memwb_seqitem = Class_MEMWB_SequenceItem::type_id::create("memwb_seqitem", this);

      seq_item_port.get_next_item(memwb_seqitem);

      // Drive DUT interface input signals at clock posedge
      drive_item(memwb_seqitem);

      @(memwb_dut_iface.ClockingBlock_MEMWB);
      //@(posedge memwb_dut_iface.clk);
      seq_item_port.item_done();
    end
  endtask : run_phase

  virtual task drive_item(Class_MEMWB_SequenceItem item);
    memwb_dut_iface.DRAM_OUT          = item.DRAM_OUT;
    memwb_dut_iface.S1_ADD_OUT        = item.S1_ADD_OUT;
    memwb_dut_iface.S3_REG_NPC_OUT    = item.S3_REG_NPC_OUT;
    memwb_dut_iface.S3_REG_ALU_OUT    = item.S3_REG_ALU_OUT;
    memwb_dut_iface.S3_REG_DATA_OUT   = item.S3_REG_DATA_OUT;

    memwb_dut_iface.S3_FF_JAL_EN_OUT  = item.S3_FF_JAL_EN_OUT;
    memwb_dut_iface.S3_FF_COND_OUT    = item.S3_FF_COND_OUT;
    memwb_dut_iface.DRAM_WE           = item.DRAM_WE;
    memwb_dut_iface.LMD_LATCH_EN      = item.LMD_LATCH_EN;
    memwb_dut_iface.JUMP_EN           = item.JUMP_EN;
    memwb_dut_iface.PC_LATCH_EN       = item.PC_LATCH_EN;
    memwb_dut_iface.WB_MUX_SEL        = item.WB_MUX_SEL;
    memwb_dut_iface.RF_WE             = item.RF_WE;

    memwb_dut_iface.S3_REG_ADD_WR_OUT = item.S3_REG_ADD_WR_OUT;
  endtask
endclass
