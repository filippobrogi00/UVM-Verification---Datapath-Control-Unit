// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

import pkg_const::*;

/*
* SCOREBOARD :
  * Checks functionality of DUT
  * Receives Transaction-Level Objects via Analysis Port
  * Also implements Assertions so that it can compare the received
  * data items from the Monitor with the "golden model".
* */

class Class_CU_Scoreboard extends uvm_scoreboard;

  // Register to Factory
  // coverage off bcs
  `uvm_component_utils(Class_CU_Scoreboard)
  // coverage on bcs

  // Constructor
  function new(string name = "Class_CU_Scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Analysis Port to receive data objects from other TB components
  uvm_analysis_imp #(Class_CU_SequenceItem, Class_CU_Scoreboard) analysis_port_imp;

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
  virtual function void write(Class_CU_SequenceItem cu_seqitem);

    /****************************************
    * Expected Result variables declaration *
    *****************************************/
    // Current and expected CWs corresponding to the current instruction
    cw_t  currentCW;
    cw_t  expectedCW;
    // Current and expected ALU OPCODE corresponding to the current instruction
    aluOp currentAluOpcode;
    aluOp expectedAluOpcode;

    /**********************
    * Current item fields *
    ***********************/
    currentCW =
      cu_seqitem.IR_LATCH_EN & cu_seqitem.NPC_LATCH_EN &
      cu_seqitem.RegA_LATCH_EN & cu_seqitem.SIGN_UNSIGN_EN & cu_seqitem.RegIMM_LATCH_EN & cu_seqitem.JAL_EN &
      cu_seqitem.MUXA_SEL & cu_seqitem.MUXB_SEL & cu_seqitem.ALU_OUTREG_EN & cu_seqitem.EQ_COND & cu_seqitem.JMP & cu_seqitem.EQZ_NEQZ & cu_seqitem.ALU_OPCODE &
      cu_seqitem.DRAM_WE & cu_seqitem.LMD_LATCH_EN & cu_seqitem.JUMP_EN & cu_seqitem.PC_LATCH_EN &
      cu_seqitem.WB_MUX_SEL & cu_seqitem.RF_WE;

    currentAluOpcode = cu_seqitem.ALU_OPCODE;

    /*************************************************
    * Calculate expected results (Golden Model) *
    **************************************************/
    expectedCW = cw_t'(get_cw(cu_seqitem.IR_IN));
    expectedAluOpcode = aluOp'(get_aluop(cu_seqitem.IR_IN));

    /**************************
    * Compare Expected vs DUT *
    ***************************/
    // Print current item
    cu_seqitem.print();

    /* Compare Expected CW with DUT-generated CW */
    assert (expectedCW == currentCW) begin
      // coverage off b
      `uvm_info("GREEN", "Control Word OK!", UVM_MEDIUM)
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "Control Word mismatch:\nExpected %0h, got %0h", expectedCW, currentCW), UVM_MEDIUM)
      // coverage on b
    end

    /* Compare Expected ALU OPCODE with DUT-generated ALU OPCODE */
    assert (expectedCW == currentCW) begin
      // coverage off b
      `uvm_info("GREEN", "Control Word OK!", UVM_MEDIUM)
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "Alu Opcode mismatch:\nExpected %0h, got %0h", expectedAluOpcode, currentAluOpcode),
                UVM_MEDIUM)
      // coverage on b
    end

  endfunction : write

endclass



