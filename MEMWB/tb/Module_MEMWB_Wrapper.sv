// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

// Wrapper for plug-and-play DUT instantiation
module Module_MEMWB_Wrapper 
#(
    parameter IR_SIZE         = 32, 
    parameter OPERAND_SIZE    = 5,  
    parameter I_TYPE_IMM_SIZE = 16, 
    parameter J_TYPE_IMM_SIZE = 26, 
    parameter RF_regBits      = 32, 
    parameter RF_numRegs      = 32  
) (
    Iface_MEMWB.DUT memwb_iface  // pass modport DUT as argument
);

  // Instantiate DUT and connect each of its pins to an interface's signals
    /*
       input clk, rst_n, DRAM_OUT, S1_ADD_OUT, S3_REG_NPC_OUT,
            S3_FF_JAL_EN_OUT, S3_REG_ADD_WR_OUT, S3_FF_COND_OUT,
            S3_REG_ALU_OUT, S3_REG_DATA_OUT, DRAM_WE, LMD_LATCH_EN, JUMP_EN,
            PC_LATCH_EN, WB_MUX_SEL, RF_WE;

        output DP_TO_DLX_PC, S4_REG_ADD_WR_OUT, S5_MUX_DATAIN_OUT;
    */
    DP_MEMWB 
	/*#(
        .IR_SIZE        (IR_SIZE),
        .OPERAND_SIZE   (OPERAND_SIZE),
        .I_TYPE_IMM_SIZE(I_TYPE_IMM_SIZE),
        .J_TYPE_IMM_SIZE(J_TYPE_IMM_SIZE),
        .RF_regBits     (RF_regBits),
        .RF_numRegs     (RF_numRegs)
    ) */
	DUT (
        /* INPUTS */
        .CLK(memwb_iface.clk),
        .nRST(memwb_iface.rst_n),

        .DRAM_OUT(memwb_iface.DRAM_OUT),
        .S1_ADD_OUT(memwb_iface.S1_ADD_OUT),
        .S3_REG_NPC_OUT(memwb_iface.S3_REG_NPC_OUT),
        .S3_FF_JAL_EN_OUT(memwb_iface.S3_FF_JAL_EN_OUT),
        .S3_REG_ADD_WR_OUT(memwb_iface.S3_REG_ADD_WR_OUT),
        .S3_FF_COND_OUT(memwb_iface.S3_FF_COND_OUT),
        .S3_REG_ALU_OUT(memwb_iface.S3_REG_ALU_OUT),
        .S3_REG_DATA_OUT(memwb_iface.S3_REG_DATA_OUT),
                            
        .DRAM_WE(memwb_iface.DRAM_WE),
        .LMD_LATCH_EN(memwb_iface.LMD_LATCH_EN),
        .JUMP_EN(memwb_iface.JUMP_EN),
        .PC_LATCH_EN(memwb_iface.PC_LATCH_EN),
                            
        .WB_MUX_SEL(memwb_iface.WB_MUX_SEL),
        .RF_WE(memwb_iface.RF_WE),

        /* Outputs */
        .DP_to_DLX_PC(memwb_iface.DP_TO_DLX_PC),
        .S4_REG_ADD_WR_OUT(memwb_iface.S4_REG_ADD_WR_OUT),
        .S5_MUX_DATAIN_OUT(memwb_iface.S5_MUX_DATAIN_OUT)
  );

endmodule

