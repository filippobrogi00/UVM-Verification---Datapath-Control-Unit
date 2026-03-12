// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.


package pkg_const;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
  // NOTE: Must be imported inside package, otherwise "scope error" arises.
	import "DPI-C" function string getenv(input string name); 
  /************************
  ******* CONSTANTS *******
  *************************/

  /* PROCESSOR-SPECIFIC CONSTANTS */

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

  /* CONSTRAINED RANDOM GENERATION CONSTANTS */
  // Max and min values
  localparam int MIN_VALUE_NBITS_SIGNED = -(2 ** (NBITS - 1));
  localparam int MAX_VALUE_NBITS_SIGNED = (2 ** (NBITS - 1)) - 1;
  localparam int MIN_VALUE_NBITS_UNSIGNED = 0;
  localparam int MAX_VALUE_NBITS_UNSIGNED = (2 ** NBITS) - 1;
  // Generation probabilities
  localparam int PROB_HIGH = 10;
  localparam int PROB_MED = 5;
  localparam int PROB_LOW = 1;



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
  parameter int unsigned NUM_ALU_OPCODES = $clog2(21);
  typedef logic [NUM_ALU_OPCODES-1:0] aluOpBits_t;
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
  parameter int unsigned ITYPE_OPCODE_ADDI = 8;  // addi
  parameter int unsigned ITYPE_OPCODE_SUBI = 10;  // subi
  parameter int unsigned ITYPE_OPCODE_ANDI = 12;  // andi
  parameter int unsigned ITYPE_OPCODE_ORI = 13;  // ori
  parameter int unsigned ITYPE_OPCODE_XORI = 14;  // xori

  parameter int unsigned ITYPE_OPCODE_SLLI = 20;  // slli
  parameter int unsigned ITYPE_OPCODE_NOP = 21;  // nop
  parameter int unsigned ITYPE_OPCODE_SRLI = 22;  // srli

  parameter int unsigned ITYPE_OPCODE_SNEI = 25;  // snei
  parameter int unsigned ITYPE_OPCODE_SLEI = 28;  // slei
  parameter int unsigned ITYPE_OPCODE_SGEI = 29;  // sgei

  parameter int unsigned ITYPE_OPCODE_LW = 35;  // lw
  parameter int unsigned ITYPE_OPCODE_SW = 43;  // sw

  // --- DLX Pro Version ---
  parameter int unsigned ITYPE_OPCODE_ADDUI = 9;  // addui
  parameter int unsigned ITYPE_OPCODE_SUBUI = 11;  // subui
  parameter int unsigned ITYPE_OPCODE_SRAI = 23;  // srai
  parameter int unsigned ITYPE_OPCODE_SEQI = 24;  // seqi
  parameter int unsigned ITYPE_OPCODE_SLTI = 26;  // slti
  parameter int unsigned ITYPE_OPCODE_SGTI = 27;  // sgti
  parameter int unsigned ITYPE_OPCODE_SLTUI = 58;  // sltui
  parameter int unsigned ITYPE_OPCODE_SGTUI = 59;  // sgtui
  parameter int unsigned ITYPE_OPCODE_SLEUI = 60;  // sleui
  parameter int unsigned ITYPE_OPCODE_SGEUI = 61;  // sgeui

  // } ITYPE_OPCODE_Type;

  /* J-Type instructions OPCODEs */
  // typedef enum int unsigned {
  parameter int unsigned JTYPE_OPCODE_J = 2;  // j
  parameter int unsigned JTYPE_OPCODE_JAL = 3;  // jal
  parameter int unsigned JTYPE_OPCODE_BEQZ = 4;  // beqz
  parameter int unsigned JTYPE_OPCODE_BNEZ = 5;  // bnez
  // } JTYPE_OPCODE_Type;

  /******************************
   * R-TYPE INSTRUCTION FUNCS   *
   ******************************/
  // typedef enum int unsigned {
  // DLX Basic version
  parameter int unsigned RTYPE_FUNC_SLL = 4;  // sll
  parameter int unsigned RTYPE_FUNC_SRL = 6;  // srl
  parameter int unsigned RTYPE_FUNC_ADD = 32;  // add
  parameter int unsigned RTYPE_FUNC_SUB = 34;  // sub
  parameter int unsigned RTYPE_FUNC_AND = 36;  // and
  parameter int unsigned RTYPE_FUNC_OR = 37;  // or
  parameter int unsigned RTYPE_FUNC_XOR = 38;  // xor
  parameter int unsigned RTYPE_FUNC_SNE = 41;  // sne
  parameter int unsigned RTYPE_FUNC_SLE = 44;  // sle
  parameter int unsigned RTYPE_FUNC_SGE = 45;  // sge

  // DLX Pro version
  parameter int unsigned RTYPE_FUNC_SRA = 7;  // sra
  parameter int unsigned RTYPE_FUNC_ADDU = 33;  // addu
  parameter int unsigned RTYPE_FUNC_SUBU = 35;  // subu
  parameter int unsigned RTYPE_FUNC_SEQ = 40;  // seq
  parameter int unsigned RTYPE_FUNC_SLT = 42;  // slt
  parameter int unsigned RTYPE_FUNC_SGT = 43;  // sgt
  parameter int unsigned RTYPE_FUNC_SLTU = 58;  // sltu
  parameter int unsigned RTYPE_FUNC_SGTU = 59;  // sgtu
  parameter int unsigned RTYPE_FUNC_SLEU = 60;  // sleu
  parameter int unsigned RTYPE_FUNC_SGEU = 61;  // sgeu
  // } RTYPE_FUNC_Type;

  /************
  * FUNCTIONS *
  ************/

  // NOTE: Disable coverage for these functions because they are
  // only used for CRG, and not in "runtime" code.
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
      JTYPE_OPCODE_J,  // j
      JTYPE_OPCODE_JAL,  // jal
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
        ITYPE_OPCODE_LW,  // lw
        ITYPE_OPCODE_SW,  // sw
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

  /******************************************
   *** FAULT INJECTION CAMPAIGN FUNCTIONS ***
   ******************************************/

  // @brief Save current detected faults count into file
  // @params:
  //    fault    : injected fault name (hierarchy)
  //    value    : injected Stuck-at value (0/1)
  //    detected : 1 if detected, 0 otherwise
  // NOTE: Can't use uvm_config_db::get/set
  function void save_current_fault_to_file(string fault, int value, int detected);
    // Save into file (name passed via Bash environment variable)
    int det_fd;
    automatic string detected_faults_file = getenv("CLASSIFIED_FAULTS_FILE");
    automatic string detected_string = (detected == 1) ? "DETECTED" : "UNDETECTED";
    det_fd = $fopen(detected_faults_file, "a");
    if (!(det_fd)) begin
      `uvm_fatal("FAULT_CAMPAIGN", $sformatf("Could not open output file %s", detected_faults_file));
      $finish;
    end
    $fwrite(det_fd, $sformatf("%s\tSA-%0d\t%s\n", fault, value, detected_string));
    $fclose(det_fd);
  endfunction

  // coverage on

endpackage
