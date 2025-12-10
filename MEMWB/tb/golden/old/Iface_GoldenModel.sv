// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

import pkg_const::CLKPERIOD;

`timescale 1ns / 1ns


// DUT Interface
interface Iface_GoldenModel #(
    parameter IR_SIZE = 32
);
    /* INPUTS */
    logic [IR_SIZE - 1 : 0]     DRAM_OUT;
    logic [IR_SIZE - 1 : 0]     S1_ADD_OUT;
    logic [IR_SIZE - 1 : 0]     S3_REG_NPC_OUT;
    logic                       S3_FF_JAL_EN_OUT;
    logic [4 : 0]               S3_REG_ADD_WR_OUT;
    logic                       S3_FF_COND_OUT;
    logic [IR_SIZE - 1 : 0]     S3_REG_ALU_OUT;
    logic [IR_SIZE - 1 : 0]     S3_REG_DATA_OUT;
    //Memory inputs
    logic                        DRAM_WE;
    logic                        LMD_LATCH_EN;
    logic                        JUMP_EN;
    logic                        PC_LATCH_EN;
    //writeback inputs
    logic                        WB_MUX_SEL;
    logic                        RF_WE;
    /* OUTPUTS */
    logic [IR_SIZE - 1 : 0]      DP_TO_DLX_PC;
    logic [4 : 0]                S4_REG_ADD_WR_OUT;
    logic [IR_SIZE - 1 : 0]      S5_MUX_DATAIN_OUT;

    // Interace as seen by DUT
    modport DUT(
        input DRAM_OUT, S1_ADD_OUT, S3_REG_NPC_OUT,
            S3_FF_JAL_EN_OUT, S3_REG_ADD_WR_OUT, S3_FF_COND_OUT,
            S3_REG_ALU_OUT, S3_REG_DATA_OUT, DRAM_WE, LMD_LATCH_EN, JUMP_EN,
            PC_LATCH_EN, WB_MUX_SEL, RF_WE,

        output DP_TO_DLX_PC, S4_REG_ADD_WR_OUT, S5_MUX_DATAIN_OUT
    );
endinterface
