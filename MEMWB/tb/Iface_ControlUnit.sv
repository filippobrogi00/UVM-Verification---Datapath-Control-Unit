// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

import pkg_const::CLKPERIOD;

`timescale 1ns / 1ns

// DUT Interface
interface Iface_ControlUnit #(
    parameter OPCODE_SIZE = 6,
    parameter FUNC_SIZE   = 11
) (
    input logic clk,
    input logic rst_n
);
  // port (
  //     -- FIRST PIPE STAGE OUTPUTS
  //     rf1 : out   std_logic; -- enables the read port 1 of the register file
  //     rf2 : out   std_logic; -- enables the read port 2 of the register file
  //     en1 : out   std_logic; -- enables the register file and the pipeline registers
  //     -- SECOND PIPE STAGE OUTPUTS
  //     s1   : out   std_logic; -- input selection of the first multiplexer
  //     s2   : out   std_logic; -- input selection of the second multiplexer
  //     alu1 : out   std_logic; -- alu control bit
  //     alu2 : out   std_logic; -- alu control bit
  //     en2  : out   std_logic; -- enables the pipe registers
  //     -- THIRD PIPE STAGE OUTPUTS
  //     rm  : out   std_logic; -- enables the read-out of the memory
  //     wm  : out   std_logic; -- enables the write-in of the memory
  //     en3 : out   std_logic; -- enables the memory and the pipeline registers
  //     s3  : out   std_logic; -- input selection of the multiplexer
  //     wf1 : out   std_logic; -- enables the write port of the register file
  //     -- INPUTS
  //     opcode : in    std_logic_vector(op_code_size - 1 downto 0);
  //     func   : in    std_logic_vector(func_size - 1 downto 0);
  //     clk    : in    std_logic;
  //     rst    : in    std_logic -- active Low
  //   )

  /* INPUTS */
  logic [OPCODE_SIZE-1:0] opcode;
  logic [FUNC_SIZE-1:0] func;

  /* OUTPUTS */
  // First stage
  logic rf_rden_port1;  // RF Port 1 Read Enable
  logic rf_rden_port2;  // RF Port 2 Read Enable
  logic en_stage1;  // (RF + Stage 1 registers) Enable
  // Second stage
  logic mux_a_sel;  // Operand A Mux Enable
  logic mux_b_sel;  // Operand B Mux Enable
  logic [1:0] alu_op_sel;  // Selects which of the four operations the ALU has to perform
  logic en_stage2;  // Enables stage 2 registers
  // Third stage
  logic mem_rd_en;  // Memory Read Enable
  logic mem_wr_en;  // Memory Write Enable
  logic en_stage3;  // Enables stage 3 registers and memory
  logic mux_wb_sel;  // Selection on Write Back Mux
  logic rf_wren;  // RF Write Enable

  // Interace as seen by DUT
  modport DUT(
      input opcode, func, clk, rst_n,

      output
      en_stage1, rf_rden_port1, rf_rden_port2, rf_wren,
      en_stage2, mux_a_sel, mux_b_sel, alu_op_sel,
      en_stage3, mem_rd_en, mem_wr_en, mux_wb_sel
  );

  // Clocking block for timing synchronization
  clocking ClockingBlock_ControlUnit @(posedge clk);
    /* (TB) INPUTS: TB <- DUT */
    // NOTE: TB's result (CW) signals are sampled at (posedge clk + CLKPERIOD/4)
    input #(1) en_stage1, rf_rden_port1, rf_rden_port2, rf_wren,
      en_stage2, mux_a_sel, mux_b_sel, alu_op_sel,
      en_stage3, mem_rd_en, mem_wr_en, mux_wb_sel;

    /* (TB) OUTPUTS: TB -> DUT */
    // NOTE: Drive DUT's inputs at (posedge clk - CLKPERIOD/4)
    output #(-1) opcode, func;
  endclocking

endinterface
