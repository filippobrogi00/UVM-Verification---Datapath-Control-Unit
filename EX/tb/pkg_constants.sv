// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

`include "uvm_macros.svh"
import uvm_pkg::*;

package pkg_const;

  /*
  * GLOBAL CLOCK SIGNALS CONSTANTS
  * */
  localparam time CLKPERIOD = 2ns;

  /*
  * GENERAL INSTRUCTION CONSTANTS
  * */
  // Number of bits
  localparam int NBITS = 32;
  localparam int CW_SIZE = 13;  // Control Word size (= number of outputs of CU)
  localparam int OPCODE_SIZE = 6;  // OPCODE field size
  localparam int FUNC_SIZE = 11;  // FUNC field size

  /*
  * INSTRUCTION ENCODINGS
  * */
  // Custom types
  typedef logic [OPCODE_SIZE-1:0] opcode_field_t;
  typedef logic [FUNC_SIZE-1:0] func_field_t;
  typedef logic [CW_SIZE-1:0] cw_t;
  typedef logic [OPCODE_SIZE+FUNC_SIZE-1:0] opcode_func_concat_t;

  /* R-TYPE Instruction Constants */
  // OPCODE field for R-TYPE instruction
  localparam opcode_field_t RTYPE = '0;  // ADD, SUB, AND, OR reg-to-reg
  // Possible FUNC field values for R-TYPE instruction
  localparam func_field_t RTYPE_ADD = 'd0;  // ADD RS1,RS2,RD
  localparam func_field_t RTYPE_SUB = 'd1;  // SUB RS1,RS2,RD
  localparam func_field_t RTYPE_AND = 'd2;  // AND RS1,RS2,RD
  localparam func_field_t RTYPE_OR = 'd3;  // OR RS1,RS2,RD

  // NO-OP instruction
  localparam func_field_t RTYPE_NOP = '1;  // NO OPERATION
  // localparam func_field_t NOP = 12'b111111111111;   // (example wider NOP)

  /* I-TYPE Instruction Constants (only OPCODE; FUNC field not defined for I-TYPE) */
  localparam opcode_field_t ITYPE_ADDI1 = 'd1;  // ADDI1 RS1,RD,INP1
  localparam opcode_field_t ITYPE_SUBI1 = 'd2;  // SUBI1 RB, RA, INP1
  localparam opcode_field_t ITYPE_ANDI1 = 'd3;  // ANDI1 RB, RA, INP1
  localparam opcode_field_t ITYPE_ORI1 = 'd4;  // ORI1 RB, RA, INP1
  localparam opcode_field_t ITYPE_ADDI2 = 'd5;  // ADDI2 RA, RB, INP2
  localparam opcode_field_t ITYPE_SUBI2 = 'd6;  // SUBI2 RA, RB, INP2
  localparam opcode_field_t ITYPE_ANDI2 = 'd7;  // ANDI2 RA, RB, INP2
  localparam opcode_field_t ITYPE_ORI2 = 'd8;  // ORI2 RA, RB, INP2
  localparam opcode_field_t ITYPE_MOV = 'd9;  // MOV RA, RB
  localparam opcode_field_t ITYPE_SREG1 = 'd10;  // S_REG1 RB, INP1
  localparam opcode_field_t ITYPE_SREG2 = 'd11;  // S_REG2 RB, INP2
  localparam opcode_field_t ITYPE_SMEM = 'd12;  // S_MEM RA, RB, INP2
  localparam opcode_field_t ITYPE_LMEM1 = 'd13;  // L_MEM1 RB, RA, INP1
  localparam opcode_field_t ITYPE_LMEM2 = 'd14;  // L_MEM2 RA, RB, INP2

  /*
  * Control Words associated to each instruction
  * */
  // verilog_format: off
  localparam cw_t CW_NOP    = 'b0000000000000;  // Reset / NOP
  localparam cw_t CW_ADD    = 'b1111000100111;  // ADD RA, RB, RC
  localparam cw_t CW_SUB    = 'b1111001100111;  // SUB RA, RB, RC                                                    endpackage
  localparam cw_t CW_AND    = 'b1111010100111;  // AND RA, RB, RC
  localparam cw_t CW_OR     = 'b1111011100111;  // OR RA, RB, RC
  localparam cw_t CW_ADDI1  = 'b0110000100111;  // ADDI1 RA, RB, INP1
  localparam cw_t CW_SUBI1  = 'b0110001100111;  // SUBI1 RA, RB, INP1
  localparam cw_t CW_ANDI1  = 'b0110010100111;  // ADDI1 RA, RB, INP1
  localparam cw_t CW_ORI1   = 'b0110011100111;  // ORI1 RA, RB, INP1
  localparam cw_t CW_ADDI2  = 'b1011100100111;  // ADDI2 RA, RB, INP2
  localparam cw_t CW_SUBI2  = 'b1011101100111;  // SUBI2 RA, RB, INP2
  localparam cw_t CW_ANDI2  = 'b1011110100111;  // ANDI2 RA, RB, INP2
  localparam cw_t CW_ORI2   = 'b1011111100111;  // ORI2 RA, RB, INP2
  localparam cw_t CW_MOV    = 'b1011100100111;  // MOV RA, RB
  localparam cw_t CW_SREG1  = 'b0010100100111;  // S_REG1 RB, INP1 Expect INP2 = 0 here.
  localparam cw_t CW_SREG2  = 'b0010100100111;  // S_REG2 RB, INP2 (Note: LUT_OUT is same as S_REG1. It's ok. Expect INP1 = 0 here.)
  localparam cw_t CW_SMEM   = 'b1011100101100;  // S_MEM RA, RB, INP2
  localparam cw_t CW_LMEM1  = 'b0110000110101;  // L_MEM1 RB, RA, INP1
  localparam cw_t CW_LMEM2  = 'b1011100110101;  // L_MEM2 RB, RA, INP2
  // verilog_format: on

  // Outputs a string corresponding to the CW passed as argument
  // (mainly used for timing debug)
  function string cw_to_string(cw_t value);
    case (value)
      CW_NOP:   return "NOP";
      CW_ADD:   return "ADD";
      CW_SUB:   return "SUB";
      CW_AND:   return "AND";
      CW_OR:    return "OR";
      CW_ADDI1: return "ADDI1";
      CW_SUBI1: return "SUBI1";
      CW_ANDI1: return "ANDI1";
      CW_ORI1:  return "ORI1";
      CW_ADDI2: return "ADDI2";
      CW_SUBI2: return "SUBI2";
      CW_ANDI2: return "ANDI2";
      CW_ORI2:  return "ORI2";
      CW_MOV:   return "MOV";
      CW_SREG1: return "SREG1";
      CW_SREG2: return "SREG2";
      CW_SMEM:  return "SMEM";
      CW_LMEM1: return "LMEM1";
      CW_LMEM2: return "LMEM2";
      default:  return "UNKNOWN";
    endcase
  endfunction


  // Associative array to keep track of (OPCODE|FUNC) <=> CW association
  cw_t CW_ARRAY[opcode_func_concat_t] = '{
      // verilog_format: off
    // OPCODE | FUNC
    {RTYPE,       RTYPE_NOP}          : CW_NOP,
    {RTYPE,       RTYPE_ADD}          : CW_ADD,
    {RTYPE,       RTYPE_SUB}          : CW_SUB,
    {RTYPE,       RTYPE_AND}          : CW_AND,
    {RTYPE,       RTYPE_OR}           : CW_OR,
    {ITYPE_ADDI1, func_field_t'(0)}   : CW_ADDI1,
    {ITYPE_SUBI1, func_field_t'(0)}   : CW_SUBI1,
    {ITYPE_ANDI1, func_field_t'(0)}   : CW_ANDI1,
    {ITYPE_ORI1,  func_field_t'(0)}   : CW_ORI1,
    {ITYPE_ADDI2, func_field_t'(0)}   : CW_ADDI2,
    {ITYPE_SUBI2, func_field_t'(0)}   : CW_SUBI2,
    {ITYPE_ANDI2, func_field_t'(0)}   : CW_ANDI2,
    {ITYPE_ORI2,  func_field_t'(0)}   : CW_ORI2,
    {ITYPE_MOV,   func_field_t'(0)}   : CW_MOV,
    {ITYPE_SREG1, func_field_t'(0)}   : CW_SREG1,
    {ITYPE_SREG2, func_field_t'(0)}   : CW_SREG2,
    {ITYPE_SMEM,  func_field_t'(0)}   : CW_SMEM,
    {ITYPE_LMEM1, func_field_t'(0)}   : CW_LMEM1,
    {ITYPE_LMEM2, func_field_t'(0)}   : CW_LMEM2
    // verilog_format: on
  };

  // Used in Scoreboard for initializing Sequence Items history
  localparam opcode_field_t INITIAL_OPCODE = RTYPE;
  localparam func_field_t INITIAL_FUNC = RTYPE_NOP;

endpackage
