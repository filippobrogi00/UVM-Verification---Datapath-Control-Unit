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
  uvm_event signal_fault_detected;


  function new(string name = "Class_MEMWB_Scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  uvm_analysis_imp #(Class_MEMWB_SequenceItem, Class_MEMWB_Scoreboard) analysis_port_imp;

  virtual Iface_MEMWB #(IR_SIZE) memwb_dut_iface;
  //Variables to store the outputs of the golden model
  logic [IR_SIZE - 1 : 0] prev_s4_reg_lmd;
  logic [IR_SIZE - 1 : 0] dp_to_dlx_pc;
  logic [4 : 0]           s4_reg_add_wr_out;
  logic [IR_SIZE - 1 : 0] s5_mux_datain_out;
  Class_MEMWB_SequenceItem predictor_result;
  integer count = 0;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    predictor_result = Class_MEMWB_SequenceItem::type_id::create("predicted_item", this);
 
    if (!uvm_config_db#(virtual Iface_MEMWB #(IR_SIZE))::get(
            this, "", "memwb_dut_iface", memwb_dut_iface
        )) begin
      `uvm_error("[SCOREBOARD]", "Could not get handle to DUT interface!")
    end

    analysis_port_imp = new("analysis_port_imp", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    //Try to get the signal fault detected uvm_event from the uvm_test
    if (!uvm_config_db#(uvm_event)::get(null, "*", "signal_fault_detected", signal_fault_detected)) begin
      `uvm_info("[SCOREBOARD]", "Could not get signal_fault_detected handle", UVM_LOW)
      //If it can't, it's not a problem, it defines a dummy handler
      signal_fault_detected = new();
    end
  endfunction

  /*
   * WRITE FUNCTION :
   * Monitor sends via Analysis Port a complete transaction to the Scoreboard
   * Here we re-compute the Expected Result and check it against DUTs'
   */

  virtual function void write(Class_MEMWB_SequenceItem memwb_seqitem);
    //Display payload received
    `uvm_info(get_type_name(), $sformatf("Packet received:\n %s", memwb_seqitem.convert2str()), UVM_LOW)

    predictor_predict(memwb_seqitem);

    //Check results

    if (predictor_result.DP_TO_DLX_PC != memwb_seqitem.DP_TO_DLX_PC) begin
      // Signal the uvm_test class that a fault has been detected
      signal_fault_detected.trigger();
      `uvm_error(get_type_name(), $sformatf("DP_TO_DLX_PC: expected %h, got %h",
        predictor_result.DP_TO_DLX_PC, memwb_seqitem.DP_TO_DLX_PC))
    end
    if (predictor_result.S4_REG_ADD_WR_OUT != memwb_seqitem.S4_REG_ADD_WR_OUT) begin
      // Signal the uvm_test class that a fault has been detected
      signal_fault_detected.trigger();
      `uvm_error(get_type_name(), $sformatf("S4_REG_ADD_WR_OUT: expected %h, got %h",
           predictor_result.S4_REG_ADD_WR_OUT, memwb_seqitem.S4_REG_ADD_WR_OUT))
    end
    if (predictor_result.S5_MUX_DATAIN_OUT != memwb_seqitem.S5_MUX_DATAIN_OUT) begin
      // Signal the uvm_test class that a fault has been detected
      signal_fault_detected.trigger();
      `uvm_error(get_type_name(), $sformatf("S5_MUX_DATAIN_OUT: expected %h, got %h",
        predictor_result.S5_MUX_DATAIN_OUT, memwb_seqitem.S5_MUX_DATAIN_OUT))
    end
    //count++;
    //$display("Packets received: %0d", count);
  endfunction : write

  virtual function void predictor_predict(Class_MEMWB_SequenceItem item);
    logic [IR_SIZE - 1 : 0] s5_mux_wb_out;
    predictor_result.copy(item);

    if (predictor_result.RST_N == 0) begin
      `uvm_info(get_type_name(), "Reset signal is asserted\n ", UVM_LOW)
      prev_s4_reg_lmd = 0;
      predictor_result.DP_TO_DLX_PC = predictor_result.S1_ADD_OUT;
      s5_mux_wb_out = 0;
      predictor_result.S5_MUX_DATAIN_OUT = 0;
      predictor_result.S4_REG_ADD_WR_OUT = 0;
      return;
    end

    if (predictor_result.LMD_LATCH_EN)
      prev_s4_reg_lmd = predictor_result.DRAM_OUT;

    if (predictor_result.S3_FF_COND_OUT && predictor_result.JUMP_EN)
      predictor_result.DP_TO_DLX_PC = predictor_result.S3_REG_ALU_OUT;
    else
      predictor_result.DP_TO_DLX_PC = predictor_result.S1_ADD_OUT;

    if (predictor_result.WB_MUX_SEL)
      s5_mux_wb_out = predictor_result.S3_REG_ALU_OUT;
    else
      s5_mux_wb_out = prev_s4_reg_lmd;

    if (predictor_result.S3_FF_JAL_EN_OUT)
      predictor_result.S5_MUX_DATAIN_OUT = predictor_result.S3_REG_NPC_OUT;
    else
      predictor_result.S5_MUX_DATAIN_OUT = s5_mux_wb_out;

    predictor_result.S4_REG_ADD_WR_OUT = predictor_result.S3_REG_ADD_WR_OUT;

endfunction
endclass



