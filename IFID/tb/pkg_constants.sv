// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

`include "uvm_macros.svh"
import uvm_pkg::*;

package pkg_const;

  localparam int NBITS = 32;

  /* General constants */
  localparam int DLX_CPU_NUMREGS = 32;
  localparam int IRAM_DEPTH = 48;

  localparam int ERROR = 99;

  /* ALU Operations */

  // Instruction types
  typedef enum {
    I_TYPE,
    J_TYPE,
    R_TYPE
  } INSTR_TYPE;

  // Instruction operates on signed or unsigned immediate
  typedef enum {
    SIGN_TYPE,
    UNSIGN_TYPE
  } INSTR_SIGN;

  // Supported instructions
  // NOTE: enumerated to match source file's encoding order
  typedef enum {
    NOP = 0,

    /* Arithmetical Operations */
    ADD_op  = 1,   // Signed Addition
    SUB_op  = 10,  // Signed Subtraction
    ADDU_op = 13,  // Unsigned Addition
    SUBU_op = 14,  // Unsigned Subtraction

    /* Bitwise Operations */
    AND_op = 3,  // Bitwise
    OR_op  = 4,  // Bitwise
    XOR_op = 11, // Bitwise

    /* "Set if" */
    SLT_op  = 16,  // Set if Less Than
    SLE_op  = 6,   // Set Less than or Equal to
    SGT_op  = 17,  // Set Greater Than
    SGE_op  = 5,   // Set Greater than or Equal to
    SEQ_op  = 15,  // Set if Equal
    SNE_op  = 8,   // Set Not Equal to
    SLTU_op = 18,  // Set if Less Than (Unsigned)
    SLEU_op = 20,  // Set if Less Than or Equal (Unsigned)
    SGTU_op = 19,  // Set Greater Than (Unsigned)
    SGEU_op = 21,  // Set Greater Than or Equal (Unsigned)

    /* Shift */
    SLL_op = 7,  // Unsigned Logical Shift Left
    SRL_op = 9,  // Unsigned Arithmetic Shift Right
    SRA_op = 12  // Shift Right Arithmetic
  } aluOp;

  // NOTE: For base-2 logarithm use SV's $clog2() builtin function


  /************
  * FUNCTIONS *
  ************/

  // @brief Helper function to check type of instruction.
  // @return One of I_TYPE, R_TYPE, J_TYPE constants.
  function check_instr_type(logic [OPCODE_SIZE-1:0] op, logic [FUNC_SIZE-1:0] func);
    // Outer Case: Based on the Instruction Opcode (R-type is 0x0)
    case (op)

      // ALU Opcode for R-Type Instructions when Instruction Opcode is 0x0. Analyze FUNC Bit Field.
      'h0: begin
        // Inner Case: Analyze FUNC Bit Field
        return R_TYPE;
      end  // end OPCODE_SIZE'h0 case

      // ALU Opcode for I-Type & J-Type Instructions when Instruction Opcode != 0x0.

      'd2: return J_TYPE;  // j
      'd3: return J_TYPE;  // jal
      'd4: return J_TYPE;  // beqz
      'd5: return J_TYPE;  // bnez

      default: return I_TYPE;
    endcase
  endfunction

  // @brief Helper function which checks if instruction
  // operates on signed or unsigned immediates.
  // @return One of SIGN_TYPE or UNSIGN_TYPE.
  function check_instr_sign(logic [OPCODE_SIZE-1:0] op, logic [FUNC_SIZE-1:0] func);

    if (check_instr_type(op, func) == I_TYPE) begin
      // Only check I_TYPE instructions
      case (op)

        'd8:  return SIGN_TYPE;  // addi
        'd10: return SIGN_TYPE;  // subi
        'd25: return SIGN_TYPE;  // snei
        'd28: return SIGN_TYPE;  // slei
        'd29: return SIGN_TYPE;  // sgei
        'd35: return SIGN_TYPE;  // lw
        'd43: return SIGN_TYPE;  // sw
        'd23: return SIGN_TYPE;  // srai
        'd24: return SIGN_TYPE;  // seqi
        'd26: return SIGN_TYPE;  // slti
        'd27: return SIGN_TYPE;  // sgti

        default: return UNSIGN_TYPE;
      endcase
    end
  endfunction

endpackage
