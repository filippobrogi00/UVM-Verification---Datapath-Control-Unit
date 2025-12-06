`include "pkg_constants.sv"
import pkg_const::*;

module MemWBStage (
  input  [IR_SIZE : 0]            s3_reg_npc_out,
  input                           s3_ff_jal_en_out,
  input  [4 : 0]                  s3_reg_add_wr_out,
  input                           s3_reg_cond_out,
  input                           jump_en,
  input  [IR_SIZE : 0]            s1_add_out, //??
  input  [IR_SIZE : 0]            s3_reg_alu_out,
  input  [IR_SIZE : 0]            dram_out,
  input                           lmd_latch_en,
  input                           wb_mux_sel,
  output [4 : 0]                  s4_reg_add_wr_out,
  output [IR_SIZE : 0]            dp_to_dlx_pc,
  output [IR_SIZE : 0]            s5_mux_datain_out
);
  (* integer foreign = "SystemC" *);
endmodule
