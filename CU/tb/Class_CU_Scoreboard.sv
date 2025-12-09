// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

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
    

    /*************************************************
    * Calculate expected results (Golden Model) *
    **************************************************/

    /******** Variables ********/


    /******** Mimicking logic ********/



    /*************************************************
    * Compare Expected vs DUT (compare NBITS fields) *
    **************************************************/
    // Print current item
    cu_seqitem.print();

    // S1_REG_NPC_OUT Comparison
    assert (Expected_S1_REG_NPC_OUT == cu_seqitem.S1_REG_NPC_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "PC OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "PC mismatch: expected 0x%0h, got 0x%0h",
                Expected_S1_REG_NPC_OUT,
                cu_seqitem.S1_REG_NPC_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

    // S2_REG_NPC_OUT Comparison
    assert (Expected_S2_REG_NPC_OUT == cu_seqitem.S2_REG_NPC_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "IR OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "IR mismatch: expected 0x%0h, got 0x%0h",
                Expected_S2_REG_NPC_OUT,
                cu_seqitem.S2_REG_NPC_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

    // S2_FF_JAL_EN_OUT Comparison
    assert (Expected_S2_FF_JAL_EN_OUT == cu_seqitem.S2_FF_JAL_EN_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "PC OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "S2_FF_JAL_EN_OUT mismatch: expected %b, got %b",
                Expected_S2_FF_JAL_EN_OUT,
                cu_seqitem.S2_FF_JAL_EN_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

    // S2_REG_ADD_WR_OUT Comparison
    assert (Expected_S2_REG_ADD_WR_OUT == cu_seqitem.S2_REG_ADD_WR_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "S2_REG_ADD_WR_OUT OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "S2_REG_ADD_WR_OUT mismatch: expected 0x%0h, got 0x%0h",
                Expected_S2_REG_ADD_WR_OUT,
                cu_seqitem.S2_REG_ADD_WR_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

    // S2_RFILE_A_OUT Comparison
    assert (Expected_S2_RFILE_A_OUT == cu_seqitem.S2_RFILE_A_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "S2_RFILE_A_OUT OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "S2_RFILE_A_OUT mismatch: expected 0x%0h, got 0x%0h",
                Expected_S2_RFILE_A_OUT,
                cu_seqitem.S2_RFILE_A_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

    // S2_RFILE_B_OUT Comparison
    assert (Expected_S2_RFILE_B_OUT == cu_seqitem.S2_RFILE_B_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "S2_RFILE_B_OUT OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "S2_RFILE_B_OUT mismatch: expected 0x%0h, got 0x%0h",
                Expected_S2_RFILE_B_OUT,
                cu_seqitem.S2_RFILE_B_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

    // S2_REG_SE_IMM_OUT Comparison
    assert (Expected_S2_REG_SE_IMM_OUT == cu_seqitem.S2_REG_SE_IMM_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "S2_REG_SE_IMM_OUT OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "S2_REG_SE_IMM_OUT mismatch: expected 0x%0h, got 0x%0h",
                Expected_S2_REG_SE_IMM_OUT,
                cu_seqitem.S2_REG_SE_IMM_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

    // S2_REG_UE_IMM_OUT Comparison
    assert (Expected_S2_REG_UE_IMM_OUT == cu_seqitem.S2_REG_UE_IMM_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "S2_REG_UE_IMM_OUT OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "S2_REG_UE_IMM_OUT mismatch: expected 0x%0h, got 0x%0h",
                Expected_S2_REG_UE_IMM_OUT,
                cu_seqitem.S2_REG_UE_IMM_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

    // S1_ADD_OUT Comparison
    assert (Expected_S1_ADD_OUT == cu_seqitem.S1_ADD_OUT) begin
      // coverage off b
      `uvm_info("GREEN", "S1_ADD_OUT OK!", UVM_MEDIUM);
      // coverage on b
    end else begin
      // coverage off b
      `uvm_info("RED", $sformatf(
                "S1_ADD_OUT mismatch: expected 0x%0h, got 0x%0h",
                Expected_S1_ADD_OUT,
                cu_seqitem.S1_ADD_OUT
                ), UVM_MEDIUM);
      // coverage on b
    end

  endfunction : write

endclass



