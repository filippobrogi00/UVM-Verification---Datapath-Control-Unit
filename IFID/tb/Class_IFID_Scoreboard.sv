// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* SCOREBOARD :
  * Checks functionality of DUT
  * Receives Transaction-Level Objects via Analysis Port
  * Also implements Assertions so that it can compare the received
  * data items from the Monitor with the "golden model".
* */

class Class_IFID_Scoreboard extends uvm_scoreboard;

  // Register to Factory
  `uvm_component_utils(Class_IFID_Scoreboard)

  // Constructor
  function new(string name = "Class_IFID_Scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Analysis Port to receive data objects from other TB components
  uvm_analysis_imp #(Class_IFID_SequenceItem, Class_IFID_Scoreboard) analysis_port_imp;

  /*
  * BUILD PHASE: Create instance of Analysis Port
  * */
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Instance the Analysis Port
    analysis_port_imp = new("analysis_port_imp", this);
  endfunction : build_phase


  /*
  * WRITE FUNCTION :
    * Monitor sends via Analysis Port a complete transaction to the Scoreboard
    * Here we re-compute the Expected Result and check it against DUTs'
  * */
  virtual function void write(Class_IFID_SequenceItem ifid_seqitem);

    /****************************************
    * Expected Result variables declaration *
    *****************************************/
    /* EX Block Outputs */
    logic [IR_SIZE-1:0] Expected_S1_REG_NPC_OUT;
    logic [IR_SIZE-1:0] Expected_S2_REG_NPC_OUT;
    logic Expected_S2_FF_JAL_EN_OUT;
    logic [OPERAND_SIZE-1:0] Expected_S2_REG_ADD_WR_OUT;
    logic [IR_SIZE-1:0] Expected_S2_RFILE_A_OUT;
    logic [IR_SIZE-1:0] Expected_S2_RFILE_B_OUT;
    logic [IR_SIZE-1:0] Expected_S2_REG_SE_IMM_OUT;
    logic [IR_SIZE-1:0] Expected_S2_REG_UE_IMM_OUT;
    /* Outputs to MEMWB Block */
    logic [IR_SIZE-1:0] Expected_S1_ADD_OUT;


    /*************************************************
    * Calculate expected results (Golden Model) *
    **************************************************/

    /******** Variables ********/
    // Registers S1/S2_REG_NPC_OUT queue (2 elements)
    static logic [IR_SIZE-1:0] s1_reg_queue[$:2] = '{0, 0};
    // Register S2_FF_JAL_EN
    static logic prev_ff_jal_en = 'b0;
    // Register S2_REG_ADD_WR and logic
    static logic [OPERAND_SIZE-1:0] prev_reg_add_wr = '0;
    logic [OPERAND_SIZE-1:0] mux_ior_result;
    logic [OPERAND_SIZE-1:0] mux_add_wr_result;
    // RF
    static logic [RF_REGBITS-1:0] rf[RF_NUMREGS];
    // Registers S2_REG_SE26_IMM and S2_REG_SE16_IMM
    static logic [IR_SIZE-1:0] prev_se26_imm = '0;
    static logic [IR_SIZE-1:0] prev_se16_imm = '0;


    /******** Mimicking logic ********/
    // NOTE: Disable coverage since it's t
    // Mimick "NPC = NPC + 4" combinational behaviorscore
    Expected_S1_ADD_OUT     = ifid_seqitem.DLX_PC_to_DP + 'd4;

    /* Mimick registers S1/2_REG_NPC_OUT through a queue */
    Expected_S1_REG_NPC_OUT = s1_reg_queue[0];  // Get last CC's NPC value
    Expected_S2_REG_NPC_OUT = s1_reg_queue[1];  // Get NPC of 2 CCs ago
    s1_reg_queue.push_front(Expected_S1_ADD_OUT);  // Push new NPC into first position

    /* Mimick S2_FF_JAL_EN_OUT register behavior */
    Expected_S2_FF_JAL_EN_OUT = prev_ff_jal_en;
    prev_ff_jal_en = ifid_seqitem.JAL_EN;

    /* Mimick register S2_REG_ADD_WR_OUT with its logic */
    // S2_MUX_IorR
    mux_ior_result = (ifid_seqitem.RegIMM_LATCH_EN == 1'b1) ? ifid_seqitem.DLX_IR_to_DP[20:16] : ifid_seqitem.DLX_IR_to_DP[15:11];
    // S2_MUX_ADD_WR
    mux_add_wr_result = (ifid_seqitem.JAL_EN == 1'b1) ? {OPERAND_SIZE{1'b1}} : mux_ior_result;
    // Register S2_REG_ADD_WR_OUT
    Expected_S2_REG_ADD_WR_OUT = prev_reg_add_wr;
    prev_reg_add_wr = mux_add_wr_result;

    /* Mimick S2_REG_SE_IMM register behavior */
    Expected_S2_REG_SE_IMM_OUT = prev_se26_imm;
    prev_se26_imm = {
      {6{ifid_seqitem.DLX_IR_to_DP[25]}}, ifid_seqitem.DLX_IR_to_DP[25:0]
    };  // Arithmetical sign extension (6+26)

    /* Mimick S2_REG_SE_IMM register behavior */
    Expected_S2_REG_SE_IMM_OUT = prev_se16_imm;
    prev_se16_imm = {
      {16{ifid_seqitem.DLX_IR_to_DP[25]}}, ifid_seqitem.DLX_IR_to_DP[15:0]
    };  // Arithmetical sign extension (16+26)

    /* Mimick RF (synchronous R/W) behavior through an array */
    // Write operation
    if (ifid_seqitem.RF_WE) begin
      rf[ifid_seqitem.S4_REG_ADD_WR_OUT] = ifid_seqitem.S5_MUX_DATAIN_OUT;
    end
    // Read operations (always enabled since RD1=1 and RD2=1)
    Expected_S2_RFILE_A_OUT = rf[ifid_seqitem.DLX_IR_to_DP[25:21]];
    Expected_S2_RFILE_B_OUT = rf[ifid_seqitem.DLX_IR_to_DP[20:16]];


    /*************************************************
    * Compare Expected vs DUT (compare NBITS fields) *
    **************************************************/
    // Print current item
    ifid_seqitem.print();

    // S1_REG_NPC_OUT Comparison
    assert (Expected_S1_REG_NPC_OUT == ifid_seqitem.S1_REG_NPC_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "PC OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // cocverage off
      `uvm_info("RED", $sformatf(
                "PC mismatch: expected 0x%0h, got 0x%0h",
                Expected_S1_REG_NPC_OUT,
                ifid_seqitem.S1_REG_NPC_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

    // S2_REG_NPC_OUT Comparison
    assert (Expected_S2_REG_NPC_OUT == ifid_seqitem.S2_REG_NPC_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "IR OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "IR mismatch: expected 0x%0h, got 0x%0h",
                Expected_S2_REG_NPC_OUT,
                ifid_seqitem.S2_REG_NPC_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

    // S2_FF_JAL_EN_OUT Comparison
    assert (Expected_S2_FF_JAL_EN_OUT == ifid_seqitem.S2_FF_JAL_EN_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "PC OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "S2_FF_JAL_EN_OUT mismatch: expected %b, got %b",
                Expected_S2_FF_JAL_EN_OUT,
                ifid_seqitem.S2_FF_JAL_EN_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

    // S2_REG_ADD_WR_OUT Comparison
    assert (Expected_S2_REG_ADD_WR_OUT == ifid_seqitem.S2_REG_ADD_WR_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "S2_REG_ADD_WR_OUT OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "S2_REG_ADD_WR_OUT mismatch: expected 0x%0h, got 0x%0h",
                Expected_S2_REG_ADD_WR_OUT,
                ifid_seqitem.S2_REG_ADD_WR_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

    // S2_RFILE_A_OUT Comparison
    assert (Expected_S2_RFILE_A_OUT == ifid_seqitem.S2_RFILE_A_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "S2_RFILE_A_OUT OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "S2_RFILE_A_OUT mismatch: expected 0x%0h, got 0x%0h",
                Expected_S2_RFILE_A_OUT,
                ifid_seqitem.S2_RFILE_A_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

    // S2_RFILE_B_OUT Comparison
    assert (Expected_S2_RFILE_B_OUT == ifid_seqitem.S2_RFILE_B_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "S2_RFILE_B_OUT OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "S2_RFILE_B_OUT mismatch: expected 0x%0h, got 0x%0h",
                Expected_S2_RFILE_B_OUT,
                ifid_seqitem.S2_RFILE_B_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

    // S2_REG_SE_IMM_OUT Comparison
    assert (Expected_S2_REG_SE_IMM_OUT == ifid_seqitem.S2_REG_SE_IMM_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "S2_REG_SE_IMM_OUT OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "S2_REG_SE_IMM_OUT mismatch: expected 0x%0h, got 0x%0h",
                Expected_S2_REG_SE_IMM_OUT,
                ifid_seqitem.S2_REG_SE_IMM_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

    // S2_REG_UE_IMM_OUT Comparison
    assert (Expected_S2_REG_UE_IMM_OUT == ifid_seqitem.S2_REG_UE_IMM_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "S2_REG_UE_IMM_OUT OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "S2_REG_UE_IMM_OUT mismatch: expected 0x%0h, got 0x%0h",
                Expected_S2_REG_UE_IMM_OUT,
                ifid_seqitem.S2_REG_UE_IMM_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

    // S1_ADD_OUT Comparison
    assert (Expected_S1_ADD_OUT == ifid_seqitem.S1_ADD_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "S1_ADD_OUT OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "S1_ADD_OUT mismatch: expected 0x%0h, got 0x%0h",
                Expected_S1_ADD_OUT,
                ifid_seqitem.S1_ADD_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

  endfunction : write

endclass



