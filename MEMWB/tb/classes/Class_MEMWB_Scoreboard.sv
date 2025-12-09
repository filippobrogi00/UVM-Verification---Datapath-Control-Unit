// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* SCOREBOARD :
  * Checks functionality of DUT
  * Receives Transaction-Level Objects via Analysis Port
  * Also implements Assertions so that it can compare the received
  * data items from the Monitor with the "golden model".
* */

class Class_MEMWB_Scoreboard extends uvm_scoreboard;
  `uvm_component_utils(Class_MEMWB_Scoreboard)

  function new(string name = "Class_MEMWB_Scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  uvm_analysis_imp #(Class_MEMWB_SequenceItem, Class_MEMWB_Scoreboard) analysis_port_imp;

  virtual Iface_MEMWB #(IR_SIZE) memwb_dut_iface;
  virtual Iface_GoldenModel #(IR_SIZE) gm_iface;
  //Variables to store the outputs of the golden model
  logic [IR_SIZE - 1 : 0] dp_to_dlx_pc;
  logic [4 : 0]           s4_reg_add_wr_out;
  logic [IR_SIZE - 1 : 0] s5_mux_datain_out;
  integer count = 0;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 
    if (!uvm_config_db#(virtual Iface_MEMWB #(IR_SIZE))::get(
            this, "", "memwb_dut_iface", memwb_dut_iface
        )) begin
      `uvm_error("[MONITOR]", "Could not get handle to DUT interface!")
    end

    if (!uvm_config_db#(virtual Iface_GoldenModel #(IR_SIZE))::get(
            this, "", "gm_iface", gm_iface
        )) begin
      `uvm_error("[MONITOR]", "Could not get handle to golden model interface!")
    end

    analysis_port_imp = new("analysis_port_imp", this);


  endfunction : build_phase

  /*
   * WRITE FUNCTION :
   * Monitor sends via Analysis Port a complete transaction to the Scoreboard
   * Here we re-compute the Expected Result and check it against DUTs'
   */

  virtual function void write(Class_MEMWB_SequenceItem memwb_seqitem);
    //send items to golden model
    gm_iface.DRAM_OUT          = memwb_seqitem.DRAM_OUT;
    gm_iface.S1_ADD_OUT        = memwb_seqitem.S1_ADD_OUT;
    gm_iface.S3_REG_NPC_OUT    = memwb_seqitem.S3_REG_NPC_OUT;
    gm_iface.S3_REG_ALU_OUT    = memwb_seqitem.S3_REG_ALU_OUT;
    gm_iface.S3_REG_DATA_OUT   = memwb_seqitem.S3_REG_DATA_OUT;

    gm_iface.S3_FF_JAL_EN_OUT  = memwb_seqitem.S3_FF_JAL_EN_OUT;
    gm_iface.S3_FF_COND_OUT    = memwb_seqitem.S3_FF_COND_OUT;
    gm_iface.DRAM_WE           = memwb_seqitem.DRAM_WE;
    gm_iface.LMD_LATCH_EN      = memwb_seqitem.LMD_LATCH_EN;
    gm_iface.JUMP_EN           = memwb_seqitem.JUMP_EN;
    gm_iface.PC_LATCH_EN       = memwb_seqitem.PC_LATCH_EN;
    gm_iface.WB_MUX_SEL        = memwb_seqitem.WB_MUX_SEL;
    gm_iface.RF_WE             = memwb_seqitem.RF_WE;
    
    //get golden model results
    dp_to_dlx_pc               = gm_iface.DP_TO_DLX_PC;
    s4_reg_add_wr_out          = gm_iface.S4_REG_ADD_WR_OUT;
    s5_mux_datain_out          = gm_iface.S5_MUX_DATAIN_OUT;

    //Display payload received
    //`uvm_info(get_type_name(), $sformatf("Packet received:\n %s", memwb_seqitem.convert2str()), UVM_LOW)

    //Check results
    if (dp_to_dlx_pc != memwb_seqitem.DP_TO_DLX_PC) begin
      `uvm_error(get_type_name(), $sformatf("DP_TO_DLX_PC: expected %h, got %h",
        dp_to_dlx_pc, memwb_seqitem.DP_TO_DLX_PC))
    end
    if (s4_reg_add_wr_out != memwb_seqitem.S4_REG_ADD_WR_OUT) begin
      `uvm_error(get_type_name(), $sformatf("S4_REG_ADD_WR_OUT: expected %h, got %h",
           s4_reg_add_wr_out, memwb_seqitem.S4_REG_ADD_WR_OUT))
    end
    if (s5_mux_datain_out != memwb_seqitem.S5_MUX_DATAIN_OUT) begin
      `uvm_error(get_type_name(), $sformatf("S5_MUX_DATAIN_OUT: expected %h, got %h",
        s5_mux_datain_out, memwb_seqitem.S5_MUX_DATAIN_OUT))
    end
    //count++;
    //$display("Packets received: %0d", count);
  endfunction : write
endclass



