// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

/*
* SEQUENCE ITEM: Data item to which can be grouped into a Sequence
* and then sent to the Driver.
  * Also implements Constraints on data so that the Sequencer generates
  * random constrained sequences to send to the Driver.
* */

// Import bins constants
import pkg_const::*;

class Class_IFID_SequenceItem extends uvm_sequence_item;
  // coverage off b
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  `uvm_object_utils(Class_IFID_SequenceItem);
  // coverage on b

  // Constructor
  function new(string name = "Class_IFID_SequenceItem");
    super.new(name);
  endfunction

  /*
  * SEQUENCE ITEM MEMBERS (items a transaction is composed of)
  * */

  // Fields to represent a "complete transaction", which will:
  //  0)  be partially (DUT inputs) populated randomly by Sequencer
  //  1)  be driven by Driver to the DUT iface
  //  2)  be "populated" by DUT
  //  3)  seen by Monitor and sent to Scoreboard for comparison against expected
  //      outputs!

  // Width is fixed to maximum and then masked if needing less bits in the
  // current test!

  // SequenceItem fields

  /***********
  *  INPUTS  *
  ************/
  /* General inputs */
  rand logic [IR_SIZE-1:0] DLX_PC_to_DP;
  rand logic [IR_SIZE-1:0] DLX_IR_to_DP;

  /* Aliases for cleaner code */
  logic [OPCODE_SIZE-1:0] opcode;
  assign opcode = DLX_IR_to_DP[31:26]; // TODO: using constants

  // I-TYPE
  logic [OPERAND_SIZE-1:0] itype_rs1;    assign itype_rs1 = DLX_IR_to_DP[25:21];
  logic [OPERAND_SIZE-1:0] itype_rs2;    assign itype_rs2 = DLX_IR_to_DP[20:16];
  logic [I_TYPE_IMM_SIZE-1:0] itype_imm; assign itype_imm = DLX_IR_to_DP[15:0];

  // R-TYPE
  logic [OPERAND_SIZE-1:0] rtype_rs1;     assign rtype_rs1 = DLX_IR_to_DP[25:21];
  logic [OPERAND_SIZE-1:0] rtype_rs2;     assign rtype_rs2 = DLX_IR_to_DP[20:16];
  logic [OPERAND_SIZE-1:0] rtype_rd;      assign rtype_rd  = DLX_IR_to_DP[15:10];
  logic [R_TYPE_IMM_SIZE-1:0] rtype_func;  assign rtype_func = DLX_IR_to_DP[10:0];

  // J-TYPE
  logic [J_TYPE_IMM_SIZE-1:0] jtype_imm; assign jtype_imm = DLX_IR_to_DP[25:0];


  /* STAGE 1 Inputs */
  rand logic IR_LATCH_EN;
  rand logic NPC_LATCH_EN;

  /* STAGE 2 Inputs */
  rand logic RegA_LATCH_EN;
  rand logic SIGN_UNSIGN_EN;
  rand logic RegIMM_LATCH_EN;
  rand logic JAL_EN;

  /* Additional inputs from MEMWB Block */
  rand logic RF_WE;
  rand logic [$clog2(RF_NUMREGS)-1:0] S4_REG_ADD_WR_OUT;
  rand logic [RF_REGBITS-1:0] S5_MUX_DATAIN_OUT;

  /***********
  *  OUTPUTS *
  ************/
  /* EX Block Outputs */
  logic [OPERAND_SIZE-1:0] S2_REG_ADD_WR_OUT;
  logic [IR_SIZE-1:0] S2_RFILE_A_OUT;
  logic [IR_SIZE-1:0] S2_RFILE_B_OUT;
  logic [IR_SIZE-1:0] S2_REG_SE_IMM_OUT;
  logic [IR_SIZE-1:0] S2_REG_UE_IMM_OUT;

  /* Outputs to MEMWB Block */
  logic [IR_SIZE-1:0] S1_ADD_OUT;


  /*
  * SEQUENCE ITEM METHODS
  * */

  // Converts just the input fields into strings
  virtual function void print();
    `uvm_info("ITEM", $sformatf(
              "-------- INFO --------\n" \
              " PC = %x\n" \
              " IR = %x\n" \
              " CW Slice = %b%b%b%b%b%b\n" \
              " RF_WE = %b, S4_REG_ADD_WR_OUT = %b, S5_MUX_DATAIN_OUT = %b\n",
              DLX_PC_to_DP, DLX_IR_to_DP, IR_LATCH_EN, NPC_LATCH_EN, RegA_LATCH_EN, SIGN_UNSIGN_EN, RegIMM_LATCH_EN, JAL_EN,
              RF_WE, S4_REG_ADD_WR_OUT, S5_MUX_DATAIN_OUT,
              UVM_MEDIUM);
  endfunction

  /*
  * CONSTRAINED RANDOM GENERATION
  * */

  /* IR Constraints */
  constraint Constraint_OPCODE_Valid {
    opcode inside {
      NOP,
      ADD_op,  // Signed Addition
      AND_op,  // Bitwise
      OR_op,   // Bitwise
      SGE_op,  // Set Greater than or Equal to
      SLE_op,  // Set Less than or Equal to
      SLL_op,  // Unsigned Logical Shift Left
      SNE_op,  // Set Not Equal to
      SRL_op,  // Unsigned Arithmetic Shift Right
      SUB_op,  // Signed Subtraction
      XOR_op,  // Bitwise

      // DLX Pro Version ALU Opcodes
      SRA_op,   // Shift Right Arithmetic
      ADDU_op,  // Unsigned Addition
      SUBU_op,  // Unsigned Subtraction
      SEQ_op,   // Set if Equal
      SLT_op,   // Set if Less Than
      SGT_op,   // Set Greater Than
      SLTU_op,  // Set if Less Than (Unsigned)
      SGTU_op,  // Set Greater Than (Unsigned)
      SLEU_op,  // Set if Less Than or Equal (Unsigned)
      SGEU_op   // Set Greater Than or Equal (Unsigned)
    };
  }

  // Constrain instruction's fields depending on the type (I, R, J)
  constraint Valid_InstructionType_Fields {

    if (check_instr_type(opcode, rtype_func) == I_TYPE) {

      /* I-TYPE instruction [OPCODE, RS1, RD, IMM] */
      itype_rs1 inside {[0:DLX_CPU_NUMREGS-1]};
      itype_rs2 inside {[0:DLX_CPU_NUMREGS-1]};

      // Check if opcode denotes signed operation
      if (check_instr_sign(opcode, func) == SIGN_TYPE)
      {
        itype_imm inside {[-(2**(NBITS-1)) : +((2**(NBITS-1))-1)]};
      } else {
        // Unsigned
        itype_imm inside {[0 : 2**(NBITS-1)]};
      }

    } else if(check_instr_type(opcode, func) == R_TYPE) {

      /* R_TYPE instruction */
      rtype_rs1 inside {[0:DLX_CPU_NUMREGS-1]};
      rtype_rs2 inside {[0:DLX_CPU_NUMREGS-1]};
      rtype_rd  inside {[0:DLX_CPU_NUMREGS-1]};

      // FUNC field, every possible type of R_TYPE operation
      // func inside {SLL_op, SRL_op, ADD_op, SUB_op, AND_op, OR_op, XOR_op, SNE_op, SLE_op, SGE_op, SRA_op, ADDU_op, SUBU_op, SEQ_op, SLT_op, SGT_op, SLTU_op, SGTU_op, SLEU_op, SGEU_op};
      // TODO: Spaghetti, needs fixing later on!
      func inside {4, 6, 32, 34, 36, 37, 38, 41, 44, 45, 7, 33, 35, 40, 42, 43, 58, 59, 60, 61};

    } else {

      /* J_TYPE instruction */
      if (opcode == ADD_op and
          (JAL_EN == 'b1 or JMP == 'b1))
      {
        jtype_imm inside {[0:IRAM_DEPTH]};
      }
    }

  }

endclass


/*
* SEQUENCE: Collection of many data items which can be combined to
* create various test scenarios.
* */
class Class_IFID_Sequence extends uvm_sequence #(Class_IFID_SequenceItem);
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  `uvm_object_utils(Class_IFID_Sequence)

  /*
  * SEQUENCE CLASS MEMBERS
  * */
  int unsigned numSequenceItems = 10;

  // Constructor
  function new(string name = "Class_IFID_Sequence");
    super.new(name);
    // coverage off b
    // Get numSequenceItems from config DB (default or overwritten by user)
    if (!uvm_config_db#(int)::get(null, "", "numSeqItems", numSequenceItems)) begin
      `uvm_error("SEQITEM", "Failed to get numSequenceItems from DB")
    end
    // coverage on b
  endfunction

  /*
  * BODY :
    * Creates the transactions to send to the Driver via the Sequencer
    * Sends them via start_item() and end_item() function calls
    * (Automatically called when sequence is started on a sequencer)
  * */
  virtual task body();
    `uvm_info("SEQUENCE", $sformatf(
              "body(): Generating %0d Sequence Items",
              numSequenceItems,
              NBITS,
              NBITS
              ), UVM_MEDIUM);

    repeat (numSequenceItems) begin
      // Create instance of a new sequence item
      // NOTE: Do not specify "this" as parent because 2nd argument must
      // be of type uvm_component, while SequenceItem is uvm_sequence!
      Class_IFID_SequenceItem ifid_sequenceItem = Class_IFID_SequenceItem::type_id::create(
          "ifid_sequenceItem"
      );

      // Reserve Sequencer slot for current item
      start_item(ifid_sequenceItem);

      // Randomize the item to let the Sequencer "execute"
      assert (ifid_sequenceItem.randomize());

      // Signal the Sequencer that the initialization is done,
      // now Driver can pick up item using .get_next_item()
      finish_item(ifid_sequenceItem);
    end

    `uvm_info("SEQUENCE", $sformatf(
              "body(): Done generating %0d Sequence Items...", numSequenceItems), UVM_MEDIUM);
  endtask : body

endclass

