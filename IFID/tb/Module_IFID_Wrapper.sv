// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

// Wrapper for plug-and-play DUT instantiation
module Module_IFID_Wrapper #(
    parameter IR_SIZE         = 32,  // Instruction size.
    parameter OPERAND_SIZE    = 5,   // Source / Destination Operand Size
    parameter I_TYPE_IMM_SIZE = 16,  // Immediate Bit Field Size for I-Type Instruction
    parameter J_TYPE_IMM_SIZE = 26,  // Immediate Bit Field Size for J-Type Instruction
    parameter RF_REGBITS      = 32,  // Bitwidth of RF words
    parameter RF_NUMREGS      = 32   // Number of RF registers
) (
    Iface_IFID.DUT ifid_iface  // pass modport DUT as argument
);

  // Instantiate DUT (ifid_sv SV wrapper inside design.sv) and connect each of its pins
  // to an interface's signals

  DP_IFID #(
/*      .IR_SIZE        (IR_SIZE),
      .OPERAND_SIZE   (OPERAND_SIZE),
      .I_TYPE_IMM_SIZE(I_TYPE_IMM_SIZE),
      .J_TYPE_IMM_SIZE(J_TYPE_IMM_SIZE),
      .RF_REGBITS     (RF_REGBITS),
      .RF_NUMREGS     (RF_NUMREGS)
  */) DP_IFID_inst (
      // Inputs
      .CLK              (ifid_iface.CLK),
      .nRST             (ifid_iface.nRST),
      .DLX_PC_to_DP     (ifid_iface.DLX_PC_to_DP),
      .DLX_IR_to_DP     (ifid_iface.DLX_IR_to_DP),
      .IR_LATCH_EN      (ifid_iface.IR_LATCH_EN),
      .NPC_LATCH_EN     (ifid_iface.NPC_LATCH_EN),
      .RegA_LATCH_EN    (ifid_iface.RegA_LATCH_EN),
      .SIGN_UNSIGN_EN   (ifid_iface.SIGN_UNSIGN_EN),
      .RegIMM_LATCH_EN  (ifid_iface.RegIMM_LATCH_EN),
      .JAL_EN           (ifid_iface.JAL_EN),
      .RF_WE            (ifid_iface.RF_WE),
      .S4_REG_ADD_WR_OUT(ifid_iface.S4_REG_ADD_WR_OUT),
      .S5_MUX_DATAIN_OUT(ifid_iface.S5_MUX_DATAIN_OUT),
      // Outputs
      .S1_REG_NPC_OUT   (ifid_iface.S1_REG_NPC_OUT),
      .S2_REG_NPC_OUT   (ifid_iface.S2_REG_NPC_OUT),
      .S2_FF_JAL_EN_OUT (ifid_iface.S2_FF_JAL_EN_OUT),
      .S2_REG_ADD_WR_OUT(ifid_iface.S2_REG_ADD_WR_OUT),
      .S2_RFILE_A_OUT   (ifid_iface.S2_RFILE_A_OUT),
      .S2_RFILE_B_OUT   (ifid_iface.S2_RFILE_B_OUT),
      .S2_REG_SE_IMM_OUT(ifid_iface.S2_REG_SE_IMM_OUT),
      .S2_REG_UE_IMM_OUT(ifid_iface.S2_REG_UE_IMM_OUT),
      .S1_ADD_OUT       (ifid_iface.S1_ADD_OUT)
  );

endmodule

