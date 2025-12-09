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
    logic [IR_SIZE-1:0] bits;  // Raw bit array
    Instr_I_TYPE itype;  // Interpreted as I_TYPE
    Instr_R_TYPE rtype;  // Interpreted as I_TYPE
    Instr_J_TYPE jtype;  // Interpreted as I_TYPE
  } InstrType;

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


  /*************************************************
  ******* CW AND ALU OPCODE FROM INSTRUCTION *******
  **************************************************/

  int unsigned RTYPE_OPCODE = 0;

  /* R-Type instructions OPCODEs */
  typedef enum int unsigned {
    // --- DLX Basic Version ---
    RTYPE_OPCODE_J    = 2,  // j
    RTYPE_OPCODE_JAL  = 3,  // jal
    RTYPE_OPCODE_BEQZ = 4,  // beqz
    RTYPE_OPCODE_BNEZ = 5,  // bnez

    RTYPE_OPCODE_ADDI = 8,   // addi
    RTYPE_OPCODE_SUBI = 10,  // subi
    RTYPE_OPCODE_ANDI = 12,  // andi
    RTYPE_OPCODE_ORI  = 13,  // ori
    RTYPE_OPCODE_XORI = 14,  // xori

    RTYPE_OPCODE_SLLI = 20,  // slli
    RTYPE_OPCODE_NOP  = 21,  // nop
    RTYPE_OPCODE_SRLI = 22,  // srli

    RTYPE_OPCODE_SNEI = 25,  // snei
    RTYPE_OPCODE_SLEI = 28,  // slei
    RTYPE_OPCODE_SGEI = 29,  // sgei

    RTYPE_OPCODE_LW = 35,  // lw
    RTYPE_OPCODE_SW = 43,  // sw

    // --- DLX Pro Version ---
    RTYPE_OPCODE_ADDUI = 9,   // addui
    RTYPE_OPCODE_SUBUI = 11,  // subui
    RTYPE_OPCODE_SRAI  = 23,  // srai
    RTYPE_OPCODE_SEQI  = 24,  // seqi
    RTYPE_OPCODE_SLTI  = 26,  // slti
    RTYPE_OPCODE_SGTI  = 27,  // sgti
    RTYPE_OPCODE_SLTUI = 58,  // sltui
    RTYPE_OPCODE_SGTUI = 59,  // sgtui
    RTYPE_OPCODE_SLEUI = 60,  // sleui
    RTYPE_OPCODE_SGEUI = 61   // sgeui

  } RType_OPCODE_Type;

  /* J/I-Type CW indexes inside CW Memory (OPCODE = 0)
  * NOTE: Some overlap (by design) with some of the R-type indexes because
  * more than one instruction has the same ALU Opcode. */
  typedef enum {
    // DLX Basic version
    IJTYPE_OPCODE_SLL = 4,   // sll
    IJTYPE_OPCODE_SRL = 6,   // srl
    IJTYPE_OPCODE_ADD = 32,  // add
    IJTYPE_OPCODE_SUB = 34,  // sub
    IJTYPE_OPCODE_AND = 36,  // and
    IJTYPE_OPCODE_OR  = 37,  // or
    IJTYPE_OPCODE_XOR = 38,  // xor
    IJTYPE_OPCODE_SNE = 41,  // sne
    IJTYPE_OPCODE_SLE = 44,  // sle
    IJTYPE_OPCODE_SGE = 45,  // sge

    // DLX Pro version
    IJTYPE_OPCODE_SRA  = 7,   // sra
    IJTYPE_OPCODE_ADDU = 33,  // addu
    IJTYPE_OPCODE_SUBU = 35,  // subu
    IJTYPE_OPCODE_SEQ  = 40,  // seq
    IJTYPE_OPCODE_SLT  = 42,  // slt
    IJTYPE_OPCODE_SGT  = 43,  // sgt
    IJTYPE_OPCODE_SLTU = 58,  // sltu
    IJTYPE_OPCODE_SGTU = 59,  // sgtu
    IJTYPE_OPCODE_SLEU = 60,  // sleu
    IJTYPE_OPCODE_SGEU = 61   // sgeu
  } IJType_OPCODE_Type;

  /* Control Word Microcode Memory */
  typedef logic [CW_SIZE-1:0] cw_t;
  typedef cw_t cw_mem_t[0:MICROCODE_MEM_SIZE-1];
  cw_mem_t cw_mem = '{
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
  //        operates on signed or unsigned immediates.
  // @params:
  //    instruction: IR content to be processed
  // @return One of SIGN_TYPE or UNSIGN_TYPE.
  function check_instr_sign(logic [IR_SIZE-1:0] instruction);

    logic [OPCODE_SIZE-1:0] op;
    // logic [OPCODE_SIZE-1:0] func;

    assign op = instruction[31:26];
    // assign func = instruction[10:0];


    if (check_instr_type(instruction) == I_TYPE) begin
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

  // @brief:  Assigns field values to an "instruction type" variable.
  // @params
  //    instruction: IR content to be processed
  // @return: Corresponding bit array which has the instruction's fields
  // defined.
  function get_instr_type(logic [IR_SIZE-1:0] instruction);
    // TODO: use proper constant-based ranges instead of hardcoded
    // logic [OPCODE_SIZE-1:0] _opcode;
    // logic [  FUNC_SIZE-1:0] _func;
    //
    // assign _opcode = instruction[31:26];
    // assign _func = instruction[10:0];

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
  function get_cw (logic [IR_SIZE-1:0] instruction);
    if (check_instr_type(instruction) == R_TYPE) begin
      return cw_mem(0);
    end else begin
      // J/I Type, use OPCODE field
      case (instruction)
          RTYPE_OPCODE:
            case (instruction[10:0])
                IJTYPE_OPCODE_SLL:
              default :
            endcase
        default :
      endcase

    end
  endfunction

  // @brief: Returns ALU OPCODE for the given instruction.
  function get_aluop (logic[IR_SIZE-1:0] instruction);

    if (check_instr_type(instruction) != R_TYPE) begin
      /* I/J-Type instructions: Look at OPCODE field */
      case (instruction[31:26])
          // -- DLX Basic version
          RTYPE_OPCODE_J,
          RTYPE_OPCODE_JAL,
          RTYPE_OPCODE_BEQZ,
          RTYPE_OPCODE_BNEZ,
          RTYPE_OPCODE_ADDI,
          RTYPE_OPCODE_LW,
          RTYPE_OPCODE_SW:
            return ADD_op;

          RTYPE_OPCODE_SUBI: return SUB_op;
          RTYPE_OPCODE_ANDI: return AND_op;
          RTYPE_OPCODE_ORI:  return OR_op;
          RTYPE_OPCODE_XORI: return XOR_op;
          RTYPE_OPCODE_SLLI: return SLL_op;
          RTYPE_OPCODE_SRLI: return SRL_op;
          RTYPE_OPCODE_SNEI: return SNE_op;
          RTYPE_OPCODE_SLEI: return SLE_op;
          RTYPE_OPCODE_SGEI: return SGE_op;

          // DLX PRO version
          RTYPE_OPCODE_ADDUI: return ADDU_op;
          RTYPE_OPCODE_SUBUI: return SUBU_op;
          RTYPE_OPCODE_SRAI:  return SRA_op;
          RTYPE_OPCODE_SEQI:  return SEQ_op;
          RTYPE_OPCODE_SLTI:  return SLT_op;
          RTYPE_OPCODE_SGTI:  return SGT_op;
          RTYPE_OPCODE_SLTUI: return SLTU_op;
          RTYPE_OPCODE_SGTUI: return SGTU_op;
          RTYPE_OPCODE_SLEUI: return SLEU_op;
          RTYPE_OPCODE_SGEUI: return SGEU_op;

        default : return NOP;
      endcase
    end else begin
      /* R-Type Instruction: look at FUNC field */
      case (instruction[10:0])
        // DLX Basic version
        IJTYPE_OPCODE_SLL: return SLL_op;
        IJTYPE_OPCODE_SRL: return SRL_op;
        IJTYPE_OPCODE_ADD: return ADD_op;
        IJTYPE_OPCODE_SUB: return SUB_op;
        IJTYPE_OPCODE_OR: return OR_op;
        IJTYPE_OPCODE_XOR: return XOR_op;
        IJTYPE_OPCODE_SNE: return SNE_op;
        IJTYPE_OPCODE_SLE: return SLE_op;
        IJTYPE_OPCODE_SGE: return SGE_op;

        // DLX PRO version
        IJTYPE_OPCODE_SRA: return SRA_op;
        IJTYPE_OPCODE_ADDU: return ADDU_op;
        IJTYPE_OPCODE_SUBU: return SUBU_op;
        IJTYPE_OPCODE_SEQ: return SEQ_op;
        IJTYPE_OPCODE_SLT: return SLT_op;
        IJTYPE_OPCODE_SGT: return SGT_op;
        IJTYPE_OPCODE_SLTU: return SLTU_op;
        IJTYPE_OPCODE_SGTU: return SGTU_op;
        IJTYPE_OPCODE_SLEU: return SLEU_op;
        IJTYPE_OPCODE_SGEU: return SGEU_op;

        default : return NOP;
      endcase
    end
  endfunction

  // coverage on

endpackage
