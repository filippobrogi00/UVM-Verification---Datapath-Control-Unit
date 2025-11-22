// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

import pkg_const::CLKPERIOD;

`timescale 1ns / 1ns


// DUT Interface
interface Iface_MEMWB #(
    parameter IR_SIZE = 32,
) (
    input  logic clk,
    input  logic rst_n,
);
/*
entity DP_MEMWB is
  generic (
    IR_SIZE         : INTEGER := 32; -- Instruction size.
    OPERAND_SIZE    : INTEGER := 5;  -- Source / Destination Operand Size
    I_TYPE_IMM_SIZE : INTEGER := 16; -- Immediate Bit Field Size for I-Type Instruction
    J_TYPE_IMM_SIZE : INTEGER := 26; -- Immediate Bit Field Size for J-Type Instruction
    RF_regBits      : integer := 32; -- Bitwidth of RF words
    RF_numRegs      : integer := 32  -- Number of RF registers
  );
  port (
    -- Inputs
    CLK      : in    std_logic; -- Clock
    nRST     : in    std_logic; -- nRST:Active-Low
    DRAM_OUT : in    std_logic_vector(IR_SIZE - 1 downto 0);

    -- Input signals from IF+ID Block
    S1_ADD_OUT : in    std_logic_vector(IR_SIZE - 1 downto 0); -- Read as "Output of Stage 1 adder."

    -- Input signals from EX Block
    S3_REG_NPC_OUT    : in    std_logic_vector(IR_SIZE - 1 downto 0);
    S3_FF_JAL_EN_OUT  : in    std_logic; -- Part of sequence of Flip-Flops which connect to the select signal of the MUX in Stage 5.
    S3_REG_ADD_WR_OUT : in    std_logic_vector(4 downto 0);
    S3_FF_COND_OUT    : in    std_logic; -- Output of S3_REG_COND register
    S3_REG_ALU_OUT    : in    std_logic_vector(IR_SIZE - 1 downto 0);
    S3_REG_DATA_OUT   : in    std_logic_vector(IR_SIZE - 1 downto 0);

    -- Memory (STAGE 4) input signals
    DRAM_WE      : in    std_logic; -- Data RAM Write Enable
    LMD_LATCH_EN : in    std_logic; -- LMD Register Latch Enable
    JUMP_EN      : in    std_logic; -- JUMP Enable Signal for PC input MUX
    PC_LATCH_EN  : in    std_logic; -- Program Counte Latch Enable

    -- Writeback - STAGE 5
    WB_MUX_SEL : in    std_logic; -- Write Back MUX Sel
    RF_WE      : in    std_logic; -- Register File Write Enable

    -- Outputs
    DP_to_DLX_PC : out   std_logic_vector(IR_SIZE - 1 downto 0); -- Will connect output of S4_MUX_JMP_OUT to PC signal in DLX entity.

    -- Outputs to IF+ID Block
    S4_REG_ADD_WR_OUT : out   std_logic_vector(4 downto 0); -- Part of sequence of registers at Write-Address input of Register File.
    S5_MUX_DATAIN_OUT : out   std_logic_vector(IR_SIZE - 1 downto 0)
  );
end entity DP_MEMWB;
*/
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
        input clk, rst_n, DRAM_OUT, S1_ADD_OUT, S3_REG_NPC_OUT,
            S3_FF_JAL_EN_OUT, S3_REG_ADD_WR_OUT, S3_FF_COND_OUT,
            S3_REG_ALU_OUT, S3_REG_DATA_OUT, DRAM_WE, LMD_LATCH_EN, JUMP_EN,
            PC_LATCH_EN, WB_MUX_SEL, RF_WE;

        output DP_TO_DLX_PC, S4_REG_ADD_WR_OUT, S5_MUX_DATAIN_OUT;
    );

  // Clocking block for timing synchronization
  clocking ClockingBlock_MEMWB @(posedge clk);
    /* (TB) INPUTS: TB <- DUT */
    // NOTE: TB's result (CW) signals are sampled at (posedge clk + CLKPERIOD/4)
    input #(1) clk, rst_n, DRAM_OUT, S1_ADD_OUT, S3_REG_NPC_OUT,
            S3_FF_JAL_EN_OUT, S3_REG_ADD_WR_OUT, S3_FF_COND_OUT,
            S3_REG_ALU_OUT, S3_REG_DATA_OUT, DRAM_WE, LMD_LATCH_EN, JUMP_EN,
            PC_LATCH_EN, WB_MUX_SEL, RF_WE;

    /* (TB) OUTPUTS: TB -> DUT */
    // NOTE: Drive DUT's inputs at (posedge clk - CLKPERIOD/4)
    output #(-1) DP_TO_DLX_PC, S4_REG_ADD_WR_OUT, S5_MUX_DATAIN_OUT;
  endclocking

endinterface
