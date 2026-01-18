// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

package pkg_const;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  // NOTE: Must be imported inside package, otherwise "scope error" arises.
	import "DPI-C" function string getenv(input string name); 

  /* Simulation constants */
  localparam time CLKPERIOD = 10ns;

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
  // I_TYPE
  typedef struct packed {
    logic [OPCODE_SIZE-1:0] opcode;
    logic [OPERAND_SIZE-1:0] rs1;
    logic [OPERAND_SIZE-1:0] rs2;
    logic [I_TYPE_IMM_SIZE-1:0] imm;
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
    logic [J_TYPE_IMM_SIZE-1:0] imm;
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
    AND_op 	= 3,  // Bitwise
    OR_op  	= 4,  // Bitwise
    SGE_op  = 5,   // Set Greater than or Equal to
    SLE_op  = 6,   // Set Less than or Equal to
    SLL_op 	= 7,  // Unsigned Logical Shift Left
    SNE_op  = 8,   // Set Not Equal to
    SRL_op 	= 9,  // Unsigned Arithmetic Shift Right
    SUB_op  = 10,  // Signed Subtraction
    XOR_op 	= 11, // Bitwise
    SRA_op 	= 12,  // Shift Right Arithmetic
    ADDU_op = 13,  // Unsigned Addition
    SUBU_op = 14,  // Unsigned Subtraction
    SEQ_op  = 15,  // Set if Equal
    SLT_op  = 16,  // Set if Less Than
    SGT_op  = 17,  // Set Greater Than
    SLTU_op = 18,  // Set if Less Than (Unsigned)
    SGTU_op = 19,  // Set Greater Than (Unsigned)
    SLEU_op = 20,  // Set if Less Than or Equal (Unsigned)
    SGEU_op = 21  // Set Greater Than or Equal (Unsigned)
  } aluOp;

  // NOTE: For base-2 logarithm use SV's $clog2() builtin function


  /************
  * FUNCTIONS *
  ************/

  // NOTE: Disable coverage for these 3 functions because they are
  // only used for CRG, and not in "runtime" code.
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
  // operates on signed or unsigned immediates.
  // @return One of SIGN_TYPE or UNSIGN_TYPE.
  function check_instr_sign(logic [IR_SIZE-1:0] instruction);

    logic [OPCODE_SIZE-1:0] op;
    logic [OPCODE_SIZE-1:0] func;

    assign op = instruction[31:26];
    assign op = instruction[10:0];


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

  // @brief Assigns field values to an "instruction type" variable.
  // @return Corresponding bit array which has the instruction's fields
  // defined.
  function get_instr_type(logic [IR_SIZE-1:0] instruction);
    // TODO: use proper constant-based ranges instead of hardcoded
    logic [OPCODE_SIZE-1:0] _opcode;
    logic [  FUNC_SIZE-1:0] _func;

    assign _opcode = instruction[31:26];
    assign _func = instruction[10:0];

    if (check_instr_type(instruction) == I_TYPE) begin
      // Assign I_TYPE fields to the bit array
      Instr_I_TYPE itype_alias;
      itype_alias.opcode = instruction[31:26];
      itype_alias.rs1    = instruction[25:21];
      itype_alias.rs2    = instruction[20:16];
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
