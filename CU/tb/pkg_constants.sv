// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

`include "uvm_macros.svh"
import uvm_pkg::*;

package pkg_const;
  /* Simulation constants */
  localparam time CLKPERIOD = 2ns;

  /* General constants */
  localparam int NBITS = 32;  // DLX CPU Bit width
  localparam int DLX_CPU_NUMREGS = 32;  // Number of regs in the CPU
  localparam int IRAM_DEPTH = 48;  // Number of IRAM words
  localparam int NUM_ALU_OPCODES = 5;
  /* Register File constants */
  localparam int RF_NUMREGS = 32;  // Number of regs inside RF
  localparam int RF_REGBITS = 32;  // Number of bits of RF registers

  /* Instruction-specific constants */
  localparam int IR_SIZE = 32;  // Size of instruction (#bits)
  localparam int OPERAND_SIZE = 5;  // Size of operand (rs1, rs2, rd) fields in I/J_TYPE instructions
  localparam int OPCODE_SIZE = 6;  // Size of OPCODE field
  localparam int FUNC_SIZE = 11;  // Size of FUNC field (only for R_TYPE)
  localparam int I_TYPE_IMM_SIZE = 16;  // Size of IMMediate field in I_TYPE instructions
  localparam int J_TYPE_IMM_SIZE = 26;  // Size of FUNC field in J_TYPE instructions

  /* Microcode memory-specific constants */
  localparam int CW_SIZE = 18;  // Control Word Size
  localparam int MICROCODE_MEM_SIZE = 62;  // Number of uCode memory words

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

  /* Instruction field aliases */
  // NOTE: Immediate fields are signed because of constraint-compliance when
  // constraining them to signed values.

  // I_TYPE
  typedef struct packed {
    logic [OPCODE_SIZE-1:0] opcode;
    logic [OPERAND_SIZE-1:0] rs1;
    logic [OPERAND_SIZE-1:0] rd;
    logic signed [I_TYPE_IMM_SIZE-1:0] imm;
  } Instr_I_TYPE;

  // R_TYPE
  typedef struct packed {
    logic [OPCODE_SIZE-1:0] opcode;
    logic [OPERAND_SIZE-1:0] rs1;
    logic [OPERAND_SIZE-1:0] rs2;
    logic [OPERAND_SIZE-1:0] rd;
    logic [FUNC_SIZE-1:0] func;
  } Instr_R_TYPE;

  // J_TYPE
  typedef struct packed {
    logic [OPCODE_SIZE-1:0] opcode;
    logic signed [J_TYPE_IMM_SIZE-1:0] imm;
  } Instr_J_TYPE;

  // General instruction type (could be each one of the types)
  typedef union packed {
    logic [NBITS-1:0] bits;  // Raw instruction bits
    Instr_I_TYPE itype;  // Remaining fields interpreted as I_TYPE
    Instr_R_TYPE rtype;  // Remaining fields interpreted as R_TYPE
    Instr_J_TYPE jtype;  // Remaining fields interpreted as J_TYPE
  } InstrType;

  // Supported instructions
  // NOTE: enumerated to match source file's encoding order
  typedef enum {
    NOP_op = 0,

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

  /*************************************************
  ******* CW AND ALU OPCODE FROM INSTRUCTION *******
  **************************************************/

  /***********************
   * INSTRUCTION OPCODES * 
   ***********************/

  /* R-Type instructions OPCODE */
  int unsigned RTYPE_OPCODE = 0;

  /* I-Type instructions OPCODEs */
  // typedef enum int unsigned {
    // --- DLX Basic Version ---
    parameter int unsigned ITYPE_OPCODE_ADDI = 8; // addi
    parameter int unsigned ITYPE_OPCODE_SUBI = 10; // subi
    parameter int unsigned ITYPE_OPCODE_ANDI = 12; // andi
    parameter int unsigned ITYPE_OPCODE_ORI  = 13; // ori
    parameter int unsigned ITYPE_OPCODE_XORI = 14; // xori

    parameter int unsigned ITYPE_OPCODE_SLLI = 20; // slli
    parameter int unsigned ITYPE_OPCODE_NOP  = 21; // nop
    parameter int unsigned ITYPE_OPCODE_SRLI = 22; // srli

    parameter int unsigned ITYPE_OPCODE_SNEI = 25; // snei
    parameter int unsigned ITYPE_OPCODE_SLEI = 28; // slei
    parameter int unsigned ITYPE_OPCODE_SGEI = 29; // sgei

    parameter int unsigned ITYPE_OPCODE_LW = 35; // lw
    parameter int unsigned ITYPE_OPCODE_SW = 43; // sw

    // --- DLX Pro Version ---
    parameter int unsigned ITYPE_OPCODE_ADDUI = 9; // addui
    parameter int unsigned ITYPE_OPCODE_SUBUI = 11; // subui
    parameter int unsigned ITYPE_OPCODE_SRAI  = 23; // srai
    parameter int unsigned ITYPE_OPCODE_SEQI  = 24; // seqi
    parameter int unsigned ITYPE_OPCODE_SLTI  = 26; // slti
    parameter int unsigned ITYPE_OPCODE_SGTI  = 27; // sgti
    parameter int unsigned ITYPE_OPCODE_SLTUI = 58; // sltui
    parameter int unsigned ITYPE_OPCODE_SGTUI = 59; // sgtui
    parameter int unsigned ITYPE_OPCODE_SLEUI = 60; // sleui
    parameter int unsigned ITYPE_OPCODE_SGEUI = 61; // sgeui

  // } ITYPE_OPCODE_Type;

  /* J-Type instructions OPCODEs */
  // typedef enum int unsigned {
  parameter int unsigned JTYPE_OPCODE_J    = 2;  // j
  parameter int unsigned JTYPE_OPCODE_JAL  = 3;  // jal
  parameter int unsigned JTYPE_OPCODE_BEQZ = 4;  // beqz
  parameter int unsigned JTYPE_OPCODE_BNEZ = 5;  // bnez
  // } JTYPE_OPCODE_Type;

  /******************************
   * R-TYPE INSTRUCTION FUNCS   * 
   ******************************/
  // typedef enum int unsigned {
    // DLX Basic version
parameter int unsigned RTYPE_FUNC_SLL = 4;   // sll
parameter int unsigned RTYPE_FUNC_SRL = 6;   // srl
parameter int unsigned RTYPE_FUNC_ADD = 32;  // add
parameter int unsigned RTYPE_FUNC_SUB = 34;  // sub
parameter int unsigned RTYPE_FUNC_AND = 36;  // and
parameter int unsigned RTYPE_FUNC_OR  = 37;  // or
parameter int unsigned RTYPE_FUNC_XOR = 38;  // xor
parameter int unsigned RTYPE_FUNC_SNE = 41;  // sne
parameter int unsigned RTYPE_FUNC_SLE = 44;  // sle
parameter int unsigned RTYPE_FUNC_SGE = 45;  // sge

    // DLX Pro version
parameter int unsigned RTYPE_FUNC_SRA  = 7;   // sra
parameter int unsigned RTYPE_FUNC_ADDU = 33;  // addu
parameter int unsigned RTYPE_FUNC_SUBU = 35;  // subu
parameter int unsigned RTYPE_FUNC_SEQ  = 40;  // seq
parameter int unsigned RTYPE_FUNC_SLT  = 42;  // slt
parameter int unsigned RTYPE_FUNC_SGT  = 43;  // sgt
parameter int unsigned RTYPE_FUNC_SLTU = 58;  // sltu
parameter int unsigned RTYPE_FUNC_SGTU = 59;  // sgtu
parameter int unsigned RTYPE_FUNC_SLEU = 60;  // sleu
parameter int unsigned RTYPE_FUNC_SGEU = 61;   // sgeu
  // } RTYPE_FUNC_Type;

  /* Control Word Microcode Memory */
  typedef logic [CW_SIZE-1:0] cw_t;
  cw_t cw_mem[MICROCODE_MEM_SIZE] = '{  // 0 : MICROCODE_MEM_SIZE-1
      // NOTE: *** Basic DLX instruction; @@@ PRO DLX instruction
      "101000101000000111",  // 0x00 R-type (look at FUNC field)  ***
      "000000000000000000",  // 0x01 ???
      "110010011110001100",  // 0x02 J     ***
      "110011011110001101",  // 0x03 JAL   ***
      "111110011101001100",  // 0x04 BEQZ  ***
      "111110011100001100",  // 0x05 BNEZ  ***
      "000000000000000000",  // 0x06 BFPT
      "000000000000000000",  // 0x07 BFPF

      "101110111000000111",  // 0x08 ADDI  ***
      "101010111000000111",  // 0x09 ADDUI @@@
      "101110111000000111",  // 0x0A SUBI  ***
      "101010111000000111",  // 0x0B SUBUI @@@
      "101110111000000111",  // 0x0C ANDI  ***
      "101110111000000111",  // 0x0D ORI   ***
      "101110111000000111",  // 0x0E XORI  ***
      "000000000000000000",  // 0x0F LHI

      "000000000000000000",  // 0x10 RFE
      "000000000000000000",  // 0x11 TRAP
      "000000000000000000",  // 0x12 JR
      "000000000000000000",  // 0x13 JALR

      "101110111000000111",  // 0x14 SLLI  ***
      "100000000000000100",  // 0x15 NOP   ***
      "101110111000000111",  // 0x16 SRLI  ***
      "101110111000000111",  // 0x17 SRAI  @@@
      "101110111000000111",  // 0x18 SEQI  @@@
      "101110111000000111",  // 0x19 SNEI  ***
      "101110111000000111",  // 0x1A SLTI  @@@
      "101110111000000111",  // 0x1B SGTI  @@@
      "101110111000000111",  // 0x1C SLEI  ***
      "101110111000000111",  // 0x1D SGEI  ***
      "000000000000000000",  // 0x1E ???
      "000000000000000000",  // 0x1F ???

      "000000000000000000",  // 0x20 LB
      "000000000000000000",  // 0x21 LH
      "000000000000000000",  // 0x22 ???
      "101110111000010101",  // 0x23 LW    ***
      "000000000000000000",  // 0x24 LBU
      "000000000000000000",  // 0x25 LHU
      "000000000000000000",  // 0x26 LF
      "000000000000000000",  // 0x27 LD

      "000000000000000000",  // 0x28 SB
      "000000000000000000",  // 0x29 SH
      "000000000000000000",  // 0x2A ???
      "101110111000100100",  // 0x2B SW    ***
      "000000000000000000",  // 0x2C ???
      "000000000000000000",  // 0x2D ???
      "000000000000000000",  // 0x2E SF
      "000000000000000000",  // 0x2F SD

      "000000000000000000",  // 0x30 ???
      "000000000000000000",  // 0x31 ???
      "000000000000000000",  // 0x32 ???
      "000000000000000000",  // 0x33 ???
      "000000000000000000",  // 0x34 ???
      "000000000000000000",  // 0x35 ???
      "000000000000000000",  // 0x36 ???
      "000000000000000000",  // 0x37 ???

      "000000000000000000",  // 0x38 ITLB
      "000000000000000000",  // 0x39 ???
      "101010111000000111",  // 0x3A SLTUI @@@
      "101010111000000111",  // 0x3B SGTUI @@@
      "101010111000000111",  // 0x3C SLEUI @@@
      "101010111000000111"  // 0x3D SGEUI @@@
  };

  /************
  * FUNCTIONS *
  ************/

  // NOTE: Disable coverage for these functions because they are
  // only used for CRG, and not in "runtime" code.
  // TODO: Maybe add simple unit test in top module?
  // coverage off

  // @brief Helper function to check type of instruction.
  // @return One of I_TYPE, R_TYPE, J_TYPE constants.
  function check_instr_type(logic [IR_SIZE-1:0] instruction);
    // Outer Case: Based on the Instruction Opcode (R-type is 0x0)
    logic [OPCODE_SIZE-1:0] op;
    assign op = instruction[31:26];

    case (op)

      /* ALU Opcode for R-Type Instructions */
      RTYPE_OPCODE: return R_TYPE;

      /* ALU Opcode for J-Type Instructions */
      JTYPE_OPCODE_J,     // j
      JTYPE_OPCODE_JAL,   // jal
      JTYPE_OPCODE_BEQZ,  // beqz
      JTYPE_OPCODE_BNEZ:  // bnez
        return J_TYPE;  

      /* ALU Opcode for I-Type Instructions */
      default: return I_TYPE;
    endcase
  endfunction

  // @brief Helper function which checks if instruction
  //        operates on signed or unsigned immediates.
  // @params:
  //    instruction: IR content to be processed
  // @return One of SIGN_TYPE or UNSIGN_TYPE.
  function check_instr_sign(logic [IR_SIZE-1:0] instruction);

    logic [OPCODE_SIZE-1:0] op;
    assign op = instruction[31:26];

    if (check_instr_type(instruction) == I_TYPE) begin
      // Only check I_TYPE instructions
      case (op)

        ITYPE_OPCODE_ADDI,  // addi
        ITYPE_OPCODE_SUBI,  // subi
        ITYPE_OPCODE_SNEI,  // snei
        ITYPE_OPCODE_SLEI,  // slei
        ITYPE_OPCODE_SGEI,  // sgei
        ITYPE_OPCODE_LW,    // lw
        ITYPE_OPCODE_SW,    // sw
        ITYPE_OPCODE_SRAI,  // srai
        ITYPE_OPCODE_SEQI,  // seqi
        ITYPE_OPCODE_SLTI,  // slti
        ITYPE_OPCODE_SGTI:  // sgti
          return SIGN_TYPE;

        default: return UNSIGN_TYPE;
      endcase
    end
  endfunction

  // @brief:  Assigns field values to an "instruction type" variable.
  // @params
  //    instruction: IR content to be processed
  // @return: Corresponding bit array which has the instruction's fields
  // defined.
  function get_instr_type(logic [IR_SIZE-1:0] instruction);
    if (check_instr_type(instruction) == I_TYPE) begin
      // Assign I_TYPE fields to the bit array
      Instr_I_TYPE itype_alias;
      itype_alias.opcode = instruction[31:26];
      itype_alias.rs1    = instruction[25:21];
      itype_alias.rd     = instruction[20:16];
      itype_alias.imm    = instruction[15:0];
      return itype_alias;
    end else if (check_instr_type(instruction) == R_TYPE) begin
      // Assign R_TYPE fields to the bit array
      Instr_R_TYPE rtype_alias;
      rtype_alias.opcode = instruction[31:26];
      rtype_alias.rs1    = instruction[25:21];
      rtype_alias.rs2    = instruction[20:16];
      rtype_alias.rd     = instruction[15:11];
      rtype_alias.func   = instruction[10:0];
      return rtype_alias;
    end else begin
      // Assign J_TYPE fields to the bit array
      Instr_J_TYPE jtype_alias;
      jtype_alias.opcode = instruction[31:26];
      jtype_alias.imm    = instruction[25:0];
      return jtype_alias;
    end
  endfunction


  // @brief:  Translates an instruction (IR contents) into
  //          its corresponding CW the CU needs to generate.
  // @params:
  //    instruction: IR content to be processed
  // @return: CW Memory index associated to the instruction
  function get_cw(logic [IR_SIZE-1:0] instruction);
    if (check_instr_type(instruction) == R_TYPE) begin

      /* R-Type instruction, return first CW Memory location
      * storing generic R-Type CW */
      return cw_mem[0];

    end else begin

      /* I/J-Type instruction, return corresponding
      * CW in memory */
      // Use OPCODE field to index memory and return CW 
      if (unsigned'(instruction[31:26]) < 62 ) begin
        return cw_mem[instruction[31:26]];
      end else begin 
        // Return NOP
        return cw_mem[1];  // Zero => NOP CW
      end 

    end
  endfunction

  // @brief:  Given an instruction, returns the corresponding
  //          ALU opcode.
  // @params:
  //    instruction: IR content to be processed
  // @return: Returns ALU OPCODE for the given instruction.
  function get_aluop(logic [IR_SIZE-1:0] instruction);

    if (check_instr_type(instruction) != R_TYPE) begin
      /* I/J-Type instructions: Look at OPCODE field */
      case (instruction[31:26])
        // -- DLX Basic version
        JTYPE_OPCODE_J,
        JTYPE_OPCODE_JAL,
        JTYPE_OPCODE_BEQZ,
        JTYPE_OPCODE_BNEZ,
        ITYPE_OPCODE_ADDI,
        ITYPE_OPCODE_LW,
        ITYPE_OPCODE_SW:
          return ADD_op;

        ITYPE_OPCODE_SUBI: return SUB_op;
        ITYPE_OPCODE_ANDI: return AND_op;
        ITYPE_OPCODE_ORI:  return OR_op;
        ITYPE_OPCODE_XORI: return XOR_op;
        ITYPE_OPCODE_SLLI: return SLL_op;
        ITYPE_OPCODE_NOP:  return NOP_op;
        ITYPE_OPCODE_SRLI: return SRL_op;
        ITYPE_OPCODE_SNEI: return SNE_op;
        ITYPE_OPCODE_SLEI: return SLE_op;
        ITYPE_OPCODE_SGEI: return SGE_op;

        // -- DLX PRO version
        ITYPE_OPCODE_ADDUI: return ADDU_op;
        ITYPE_OPCODE_SUBUI: return SUBU_op;
        ITYPE_OPCODE_SRAI:  return SRA_op;
        ITYPE_OPCODE_SEQI:  return SEQ_op;
        ITYPE_OPCODE_SLTI:  return SLT_op;
        ITYPE_OPCODE_SGTI:  return SGT_op;
        ITYPE_OPCODE_SLTUI: return SLTU_op;
        ITYPE_OPCODE_SGTUI: return SGTU_op;
        ITYPE_OPCODE_SLEUI: return SLEU_op;
        ITYPE_OPCODE_SGEUI: return SGEU_op;

        default: return NOP_op;
      endcase

    end else begin

      /* R-Type Instruction: look at FUNC field */
      case (instruction[10:0])
        // -- DLX Basic version
        RTYPE_FUNC_SLL: return SLL_op;
        RTYPE_FUNC_SRL: return SRL_op;
        RTYPE_FUNC_ADD: return ADD_op;
        RTYPE_FUNC_SUB: return SUB_op;
        RTYPE_FUNC_OR:  return OR_op;
        RTYPE_FUNC_XOR: return XOR_op;
        RTYPE_FUNC_SNE: return SNE_op;
        RTYPE_FUNC_SLE: return SLE_op;
        RTYPE_FUNC_SGE: return SGE_op;

        // -- DLX PRO version
        RTYPE_FUNC_SRA:  return SRA_op;
        RTYPE_FUNC_ADDU: return ADDU_op;
        RTYPE_FUNC_SUBU: return SUBU_op;
        RTYPE_FUNC_SEQ:  return SEQ_op;
        RTYPE_FUNC_SLT:  return SLT_op;
        RTYPE_FUNC_SGT:  return SGT_op;
        RTYPE_FUNC_SLTU: return SLTU_op;
        RTYPE_FUNC_SGTU: return SGTU_op;
        RTYPE_FUNC_SLEU: return SLEU_op;
        RTYPE_FUNC_SGEU: return SGEU_op;

        default: return NOP_op;
      endcase
    end
  endfunction

  // coverage on

endpackage
