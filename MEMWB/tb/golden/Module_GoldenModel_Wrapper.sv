// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

// Wrapper for plug-and-play DUT instantiation
module Module_GoldenModel_Wrapper #(
    parameter IR_SIZE         = 32, 
    parameter OPERAND_SIZE    = 5,  
    parameter I_TYPE_IMM_SIZE = 16, 
    parameter J_TYPE_IMM_SIZE = 26, 
    parameter RF_regBits      = 32, 
    parameter RF_numRegs      = 32  
) (
    Iface_GoldenModel.DUT gm_iface  // pass modport DUT as argument
);

  // Instantiate DUT and connect each of its pins to an interface's signals
    /*
       input clk, rst_n, DRAM_OUT, S1_ADD_OUT, S3_REG_NPC_OUT,
            S3_FF_JAL_EN_OUT, S3_REG_ADD_WR_OUT, S3_FF_COND_OUT,
            S3_REG_ALU_OUT, S3_REG_DATA_OUT, DRAM_WE, LMD_LATCH_EN, JUMP_EN,
            PC_LATCH_EN, WB_MUX_SEL, RF_WE;

        output DP_TO_DLX_PC, S4_REG_ADD_WR_OUT, S5_MUX_DATAIN_OUT;
    */
    MemWBStage GoldenModel (
        /* INPUTS */
        .dram_out(gm_iface.DRAM_OUT),
        .s1_add_out(gm_iface.S1_ADD_OUT),
        .s3_reg_npc_out(gm_iface.S3_REG_NPC_OUT),
        .s3_ff_jal_en_out(gm_iface.S3_FF_JAL_EN_OUT),
        .s3_reg_add_wr_out(gm_iface.S3_REG_ADD_WR_OUT),
        .s3_reg_cond_out(gm_iface.S3_FF_COND_OUT),
        .s3_reg_alu_out(gm_iface.S3_REG_ALU_OUT),
        //.s3_reg_data_out(gm_iface.S3_REG_DATA_OUT),
                            
        //.DRAM_WE(gm_iface.DRAM_WE),
        .lmd_latch_en(gm_iface.LMD_LATCH_EN),
        .jump_en(gm_iface.JUMP_EN),
        //.PC_LATCH_EN(gm_iface.PC_LATCH_EN),
                            
        .wb_mux_sel(gm_iface.WB_MUX_SEL),
        //.RF_WE(gm_iface.RF_WE),
        /* Outputs */
        .dp_to_dlx_pc(gm_iface.DP_TO_DLX_PC),
        .s4_reg_add_wr_out(gm_iface.S4_REG_ADD_WR_OUT),
        .s5_mux_datain_out(gm_iface.S5_MUX_DATAIN_OUT)
  );

endmodule

