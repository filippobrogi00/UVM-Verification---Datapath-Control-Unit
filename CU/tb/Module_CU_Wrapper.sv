// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

import pkg_const::*;

// Wrapper for plug-and-play DUT instantiation
module Module_CU_Wrapper #(
    parameter MICROCODE_MEM_SIZE = 44, // Microcode Memory Size. Included all Instructions DLX will be able to execute and not.
    parameter FUNC_SIZE = 11,  // Func Field Size for R-Type Ops
    parameter OP_CODE_SIZE = 6,  // Op Code Size
    parameter IR_SIZE = 32,  // Instruction Register Size
    parameter CW_SIZE = 18  // Control Word Size. Added new Control Signals.
) (
    Iface_CU.DUT cu_iface  // pass modport DUT as argument
);

  // Instantiate DUT (cu_sv SV wrapper inside design.sv) and connect each of its pins
  // to an interface's signals
  dlx_cu 
  `ifndef POSTSYN_SIMULATION   		
	  `ifndef FAULT_INJECTION_CAMPAIGN		
      #(
        .MICROCODE_MEM_SIZE(MICROCODE_MEM_SIZE),
        .FUNC_SIZE         (FUNC_SIZE),
        .OP_CODE_SIZE      (OP_CODE_SIZE),
        .IR_SIZE           (IR_SIZE),
        .CW_SIZE           (CW_SIZE)
      ) 
    `endif // FAULT_INJECTION_CAMPAIGN
  `endif // POSTSYN_SIMULATION
  DP_CU_inst ( // WARN: PARSER COMMENT, DO NOT CHANGE/REMOVE
      /* Inputs */
      .Clk            (cu_iface.Clk),
      .nRst           (cu_iface.nRst),
      .IR_IN          (cu_iface.IR_IN),
      /* Outputs */
      // Stage 1
      .IR_LATCH_EN    (cu_iface.IR_LATCH_EN),
      .NPC_LATCH_EN   (cu_iface.NPC_LATCH_EN),
      // Stage 2
      .RegA_LATCH_EN  (cu_iface.RegA_LATCH_EN),
      .SIGN_UNSIGN_EN (cu_iface.SIGN_UNSIGN_EN),
      .RegIMM_LATCH_EN(cu_iface.RegIMM_LATCH_EN),
      .JAL_EN         (cu_iface.JAL_EN),
      // Stage 3
      .MUXA_SEL       (cu_iface.MUXA_SEL),
      .MUXB_SEL       (cu_iface.MUXB_SEL),
      .ALU_OUTREG_EN  (cu_iface.ALU_OUTREG_EN),
      .EQ_COND        (cu_iface.EQ_COND),
      .JMP            (cu_iface.JMP),
      .EQZ_NEQZ       (cu_iface.EQZ_NEQZ),
      .ALU_OPCODE     (cu_iface.ALU_OPCODE),
      // Stage 4
      .DRAM_WE        (cu_iface.DRAM_WE),
      .LMD_LATCH_EN   (cu_iface.LMD_LATCH_EN),
      .JUMP_EN        (cu_iface.JUMP_EN),
      .PC_LATCH_EN    (cu_iface.PC_LATCH_EN),
      // Stage 5
      .WB_MUX_SEL     (cu_iface.WB_MUX_SEL),
      .RF_WE          (cu_iface.RF_WE)
  );

endmodule

