// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

// Wrapper for plug-and-play DUT instantiation
module Module_EXE_Wrapper #(
    parameter IR_SIZE         = 32,  // Instruction size.
    parameter OPERAND_SIZE    = 5,   // Source / Destination Operand Size
    parameter I_TYPE_IMM_SIZE = 16,  // Immediate Bit Field Size for I-Type Instruction
    parameter J_TYPE_IMM_SIZE = 26,  // Immediate Bit Field Size for J-Type Instruction
    parameter RF_REGBITS      = 32,  // Bitwidth of RF words
    parameter RF_NUMREGS      = 32   // Number of RF registers
) (
    Iface_EXE.DUT exe_iface  // pass modport DUT as argument
);

  // Instantiate DUT (exe_sv SV wrapper inside design.sv) and connect each of its pins
  // to an interface's signals

  	DP_EX 
	#(
      	.IR_SIZE        (IR_SIZE),
      	.OPERAND_SIZE   (OPERAND_SIZE),
      	.I_TYPE_IMM_SIZE(I_TYPE_IMM_SIZE),
      	.J_TYPE_IMM_SIZE(J_TYPE_IMM_SIZE),
      	.RF_REGBITS     (RF_REGBITS),
      	.RF_NUMREGS     (RF_NUMREGS)
  	) 
	DP_EXE_inst (
      	// Inputs
      	.CLK              	(exe_iface.CLK),
      	.nRST             	(exe_iface.nRST),
      	.S1_REG_NPC_OUT   	(exe_iface.S1_REG_NPC_OUT),
      	.S2_FF_JAL_EN_OUT	(exe_iface.S2_FF_JAL_EN_OUT),
      	.S2_REG_NPC_OUT		(exe_iface.S2_REG_NPC_OUT),
      	.S2_REG_ADD_WR_OUT	(exe_iface.S2_REG_ADD_WR_OUT),
      	.S2_RFILE_A_OUT		(exe_iface.S2_RFILE_A_OUT),
      	.S2_RFILE_B_OUT		(exe_iface.S2_RFILE_B_OUT),
      	.S2_REG_SE_IMM_OUT	(exe_iface.S2_REG_SE_IMM_OUT),
      	.S2_REG_UE_IMM_OUT	(exe_iface.S2_REG_UE_IMM_OUT),
	  	// Controls
      	.MUX_A_SEL			(exe_iface.MUX_A_SEL),
      	.MUX_B_SEL			(exe_iface.MUX_B_SEL),
      	.ALU_OUTREG_EN		(exe_iface.ALU_OUTREG_EN),
      	.EQ_COND			(exe_iface.EQ_COND),
      	.JMP				(exe_iface.JMP),
      	.EQZ_NEQZ			(exe_iface.EQZ_NEQZ),
      	.DP_ALU_OPCODE		(exe_iface.DP_ALU_OPCODE),
		// Outputs
      	.S3_FF_JAL_EN_OUT	(exe_iface.S3_FF_JAL_EN_OUT),
      	.S3_REG_ADD_WR_OUT	(exe_iface.S3_REG_ADD_WR_OUT),
      	.S3_FF_COND_OUT		(exe_iface.S3_FF_COND_OUT),
      	.S3_REG_ALU_OUT		(exe_iface.S3_REG_ALU_OUT),
      	.S3_REG_DATA_OUT	(exe_iface.S3_REG_DATA_OUT),
      	.S3_REG_NPC_OUT		(exe_iface.S3_REG_NPC_OUT)		
	);

endmodule

