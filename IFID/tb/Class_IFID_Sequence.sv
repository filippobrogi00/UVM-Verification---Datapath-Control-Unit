// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

// Import bins constants
import pkg_const::*;


/*****************************************
 ************* SEQUENCE ITEM *************
 *****************************************/


/*
* SEQUENCE ITEM: Data item to which can be grouped into a Sequence
* and then sent to the Driver.
* */
class Class_IFID_SequenceItem extends uvm_sequence_item;
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off bcs
  `uvm_object_utils(Class_IFID_SequenceItem)
  // coverage on bcs

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

  // SequenceItem fields
  // NOTE: Inputs declared as rand even though they are actually
  // randomized depending on the Sequence which instantiates the seqitem.

  /***********
  *  INPUTS  *
  ************/
  /* General inputs */
  randc logic [IR_SIZE-1:0] DLX_PC_to_DP;
  randc logic [IR_SIZE-1:0] DLX_IR_to_DP;

  // IR instruction, with fields depending on its type
  // NOTE: Not a real input/signal, just an alias used for CRG.
  InstrType instr;

  /* STAGE 1 Inputs */
  randc logic IR_LATCH_EN;
  randc logic NPC_LATCH_EN;

  /* STAGE 2 Inputs */
  randc logic RegA_LATCH_EN;
  randc logic SIGN_UNSIGN_EN;
  randc logic RegIMM_LATCH_EN;
  randc logic JAL_EN;

  /* Additional inputs from MEMWB Block */
  randc logic RF_WE;
  randc logic [$clog2(RF_NUMREGS)-1:0] S4_REG_ADD_WR_OUT;
  randc logic [RF_REGBITS-1:0] S5_MUX_DATAIN_OUT;

  /***********
  *  OUTPUTS *
  ************/
  /* EX Block Outputs */
  logic [IR_SIZE-1:0] S1_REG_NPC_OUT;
  logic [IR_SIZE-1:0] S2_REG_NPC_OUT;
  logic S2_FF_JAL_EN_OUT;
  logic [$clog2(RF_NUMREGS)-1:0] S2_REG_ADD_WR_OUT;
  logic [IR_SIZE-1:0] S2_RFILE_A_OUT;
  logic [IR_SIZE-1:0] S2_RFILE_B_OUT;
  logic [IR_SIZE-1:0] S2_REG_SE_IMM_OUT;
  logic [IR_SIZE-1:0] S2_REG_UE_IMM_OUT;

  /* Outputs to MEMWB Block */
  logic [IR_SIZE-1:0] S1_ADD_OUT;


  /*
  * NSEQUENCE ITEM METHODS
  * */

  // Converts just the input fields into strings
  virtual function void print();
    // coverage off
    `uvm_info("BLUE", $sformatf(
              {
                "-------- ITEM INFO --------\n",
                "/***** INPUTS   *****/",
                " PC = %x\n",
                " IR = %x\n",
                " CW Slice = %b%b%b%b%b%b\n",
                " RF_WE = %b, S4_REG_ADD_WR_OUT = %b, S5_MUX_DATAIN_OUT = %b\n",
                "/***** OUTPUTS   *****/",
                " S1_ADD_OUT = %x\n",
                " S1_REG_NPC_OUT = %x\n",
                " S2_REG_NPC_OUT = %x\n",
                " S2_FF_JAL_EN_OUT = %b\n",
                " S2_REG_ADD_WR_OUT = %x\n",
                " S2_RFILE_A_OUT = %x, S2_REG_NPC_OUT = %x\n",
                " S2_REG_SE_IMM_OUT = %x, S2_REG_UE_IMM_OUT = %x\n",
                "---------------------------\n"
              },
              // Inputs
              DLX_PC_to_DP,
              DLX_IR_to_DP,
              IR_LATCH_EN,
              NPC_LATCH_EN,
              RegA_LATCH_EN,
              SIGN_UNSIGN_EN,
              RegIMM_LATCH_EN,
              JAL_EN,
              RF_WE,
              S4_REG_ADD_WR_OUT,
              S5_MUX_DATAIN_OUT,
              // Outputs
              S1_ADD_OUT,
              S1_REG_NPC_OUT,
              S2_REG_NPC_OUT,
              S2_FF_JAL_EN_OUT,
              S2_REG_ADD_WR_OUT,
              S2_RFILE_A_OUT,
              S2_RFILE_B_OUT,
              S2_REG_SE_IMM_OUT,
              S2_REG_UE_IMM_OUT
              ), UVM_MEDIUM);
    // coverage on
  endfunction

  // Copies "src" seqitem fields into "dest" seqitem
  virtual function void copy(Class_IFID_SequenceItem src, Class_IFID_SequenceItem dest);
    // coverage off

    /* INPUTS */
    // General inputs
    dest.DLX_PC_to_DP      = src.DLX_PC_to_DP;
    dest.DLX_IR_to_DP      = src.DLX_IR_to_DP;
    // Stage 1 inputs
    dest.IR_LATCH_EN       = src.IR_LATCH_EN;
    dest.NPC_LATCH_EN      = src.NPC_LATCH_EN;
    // Stage 2 inputs
    dest.RegA_LATCH_EN     = src.RegA_LATCH_EN;
    dest.SIGN_UNSIGN_EN    = src.SIGN_UNSIGN_EN;
    dest.RegIMM_LATCH_EN   = src.RegIMM_LATCH_EN;
    dest.JAL_EN            = src.JAL_EN;
    // Additional inputs
    dest.RF_WE             = src.RF_WE;
    dest.S4_REG_ADD_WR_OUT = src.S4_REG_ADD_WR_OUT;
    dest.S5_MUX_DATAIN_OUT = src.S5_MUX_DATAIN_OUT;
    /* OUTPUTS */
    // EX Block outputs
    dest.S1_REG_NPC_OUT    = src.S1_REG_NPC_OUT;
    dest.S2_REG_NPC_OUT    = src.S2_REG_NPC_OUT;
    dest.S2_FF_JAL_EN_OUT  = src.S2_FF_JAL_EN_OUT;
    dest.S2_REG_ADD_WR_OUT = src.S2_REG_ADD_WR_OUT;
    dest.S2_RFILE_A_OUT    = src.S2_RFILE_A_OUT;
    dest.S2_RFILE_B_OUT    = src.S2_RFILE_B_OUT;
    dest.S2_REG_SE_IMM_OUT = src.S2_REG_SE_IMM_OUT;
    dest.S2_REG_UE_IMM_OUT = src.S2_REG_UE_IMM_OUT;
    // To MEMWB Block
    dest.S1_ADD_OUT        = src.S1_ADD_OUT;

    // coverage on

  endfunction


endclass




/********************************************
 ************* SEQUENCE CLASSES *************
 ********************************************/

/************************ BASE SEQUENCE ***************************
 * Abstract class which just serves as base class for every       *
 * speciic Sequence Item subclass, specializing in a certain kind *
 * of CRG.                                                        *
 ******************************************************************/
// virtual class Class_IFID_BaseSequence #(
//     type SequenceItemType = Class_IFID_SequenceItem
// )
// extends uvm_sequence #(Class_IFID_SequenceItem);
//
//   `uvm_object_utils(Class_IFID_BaseSequence)
//
//   int unsigned numSequenceItems = 10;
//
//   function new(string name = "Class_IFID_BaseSequence");
//     super.new();
//     if (!uvm_config_db#(int)::get(null, "", "numSeqItems", numSequenceItems)) begin
//       `uvm_error("SEQITEM", "Failed to get numSequenceItems from DB")
//     end
//   endfunction
//
//   // Defined by child classes
//   pure virtual task body();
//
// endclass : Class_IFID_BaseSequence


/************************ LEGAL SEQUENCE **************************
 * Inputs are constrained picking only legal values (allowed      *
 * by the DUT logic).                                             *
 ******************************************************************/
class Class_IFID_LegalSequence extends uvm_sequence #(Class_IFID_SequenceItem);
  // class Class_IFID_LegalSequence extends Class_IFID_BaseSequence;
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off bcs
  `uvm_object_utils(Class_IFID_LegalSequence)
  // coverage on bcs

  /*
  * SEQUENCE CLASS MEMBERS
  * */
  int unsigned numSequenceItems = 10;

  // Constructor
  function new(string name = "Class_IFID_LegalSequence");
    super.new(name);
    // coverage off b
    // Get numSequenceItems from config DB (default or overwritten by user)
    if (!uvm_config_db#(int)::get(null, "", "numSeqItems", numSequenceItems)) begin
      `uvm_error("SEQITEM", "Failed to get numSequenceItems from DB")
    end
    // coverage on b
  endfunction

  /*
  * BODY
  * */
  virtual task body();
    // coverage off b
    `uvm_info("SEQUENCE", $sformatf("body(): Generating %0d Sequence Items", numSequenceItems),
              UVM_MEDIUM);
    // coverage on b

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
      // NOTE: Even though BaseSequence does not have any constraints for CRG,
      // and sequence items do not either, this body() method will be used
      // by derived classes!
      assert (ifid_sequenceItem.randomize() with {
        /* VALID OPCODE CONSTRAINT */
        instr.bits[31:26] inside {RTYPE_OPCODE,  // R-type (uses FUNC field)
        // --- DLX Basic Version ---
        JTYPE_OPCODE_J,  // j
        JTYPE_OPCODE_JAL,  // jal
        JTYPE_OPCODE_BEQZ,  // beqz
        JTYPE_OPCODE_BNEZ,  // bnez
        ITYPE_OPCODE_ADDI,  // addi
        ITYPE_OPCODE_SUBI,  // subi
        ITYPE_OPCODE_ANDI,  // andi
        ITYPE_OPCODE_ORI,  // ori
        ITYPE_OPCODE_XORI,  // xori
        ITYPE_OPCODE_SLLI,  // slli
        ITYPE_OPCODE_NOP,  // nop
        ITYPE_OPCODE_SRLI,  // srli
        ITYPE_OPCODE_SNEI,  // snei
        ITYPE_OPCODE_SLEI,  // slei
        ITYPE_OPCODE_SGEI,  // sgei
        ITYPE_OPCODE_LW,  // lw
        ITYPE_OPCODE_SW,  // sw
        // --- DLX Pro Version ---
        ITYPE_OPCODE_ADDUI,  // addui
        ITYPE_OPCODE_SUBUI,  // subui
        ITYPE_OPCODE_SRAI,  // srai
        ITYPE_OPCODE_SEQI,  // seqi
        ITYPE_OPCODE_SLTI,  // slti
        ITYPE_OPCODE_SGTI,  // sgti
        ITYPE_OPCODE_SLTUI,  // sltui
        ITYPE_OPCODE_SGTUI,  // sgtui
        ITYPE_OPCODE_SLEUI,  // sleui
        ITYPE_OPCODE_SGEUI  // sgeui
        };


        /* VALID OPCODE CONSTRAINTS */

        // verilog_format: off
        if (check_instr_type(instr) == I_TYPE) {
        // verilog_format: on

          /* I-TYPE instruction [OPCODE, RS1, RD, IMM] */
          instr.itype.rs1 inside {[0 : DLX_CPU_NUMREGS - 1]};
          instr.itype.rd inside {[0 : DLX_CPU_NUMREGS - 1]};

          // Check if opcode denotes signed operation
          // verilog_format: off
          if (check_instr_sign(instr) == SIGN_TYPE) {
          // verilog_format: on
            // Constrain as signed
            instr.itype.imm inside {[-(2 ** (NBITS - 1)) : +((2 ** (NBITS - 1)) - 1)]};
          } else {
            // Constrain as unsigned
            instr.itype.imm inside {[0 : (2 ** NBITS) - 1]};
          }

          // verilog_format: off
        } else if (check_instr_type(instr) == R_TYPE) {
          // verilog_format: on

          /* R_TYPE instruction */
          instr.rtype.rs1 inside {[0 : DLX_CPU_NUMREGS - 1]};
          instr.rtype.rs2 inside {[0 : DLX_CPU_NUMREGS - 1]};
          instr.rtype.rd inside {[0 : DLX_CPU_NUMREGS - 1]};

          // FUNC field, every possible type of R_TYPE operation
          instr.rtype.func inside {RTYPE_FUNC_SLL,  // sll
          RTYPE_FUNC_SRL,  // srl
          RTYPE_FUNC_ADD,  // add
          RTYPE_FUNC_SUB,  // sub
          RTYPE_FUNC_AND,  // and
          RTYPE_FUNC_OR,  // or
          RTYPE_FUNC_XOR,  // xor
          RTYPE_FUNC_SNE,  // sne
          RTYPE_FUNC_SLE,  // sle
          RTYPE_FUNC_SGE,  // sge
          // --- DLX Pro Version ---
          RTYPE_FUNC_SRA,  // sra
          RTYPE_FUNC_ADDU,  // addu
          RTYPE_FUNC_SUBU,  // subu
          RTYPE_FUNC_SEQ,  // seq
          RTYPE_FUNC_SLT,  // slt
          RTYPE_FUNC_SGT,  // sgt
          RTYPE_FUNC_SLTU,  // sltu
          RTYPE_FUNC_SGTU,  // sgtu
          RTYPE_FUNC_SLEU,  // sleu
          RTYPE_FUNC_SGEU  // sgeu
          };

        } else {

          /* J_TYPE instruction */

          /*
           * NOTE 1:
           * Only for instructions J(mp), JAL, BEQ, BNEZ (which are our only
           * jump instructions) the bit JUMP_EN will be 1, which will overwrite
           * the next PC value with S3_REG_ALU content
           * NOTE 2:
           * Only for J and JAL (unconditional jump instructions), JMP flag
           * will be 1.
           *
           * NOTE 3: Opcode for J, JAL, BEQZ, BNEZ is always ADD_op.
           *
           * Recap:
           * -) JUMP_EN enabled for every possible jump instruction (opcode ADD_op)
           * -) For conditional jumps, EQZ_NEQZ flag will direct the jump
           * -) For unconditional jumps, JMP flag will direct the jump
           * */

          // verilog_format: off
          if
            (
              // OPCODE is that of a jump instruction, and so JUMP_EN = 1
              // instr.bits[31:26] == JTYPE_OPCODE_ADDU &&
              (check_instr_type(instr) == J_TYPE) &&
              // and either:
              (
                // JMP flag is set (CW bit #7) (unconditional jump)
                DLX_IR_to_DP[7] == 1'b1 ||
                // or target register is zero and "BEQZ" flag is set (CW bit #6)
                (S2_RFILE_A_OUT == '0 && DLX_IR_to_DP[6] == 1'b1) ||
                // or target register is NOT zero and "BNEZ" flag is set
                (S2_RFILE_A_OUT != '0 && DLX_IR_to_DP[6] == 1'b0)
              )
            )
            {
              instr.jtype.imm inside {[0 : IRAM_DEPTH]};
            }

          // verilog_format: on

        }

      });

      // Signal the Sequencer that the initialization is done,
      // now Driver can pick up item using .get_next_item()
      finish_item(ifid_sequenceItem);
    end

    // coverage off b
    `uvm_info("SEQUENCE", $sformatf(
              "body(): Done generating %0d Sequence Items...", numSequenceItems), UVM_MEDIUM);
    // coverage on b
  endtask : body

endclass

/************************ RANDOM SEQUENCE **************************
 * Inputs are constrained randomically, feeding the DUT with       *
 * potentially wrong inputs.                                       *
 *******************************************************************/
class Class_IFID_RandomSequence extends uvm_sequence #(Class_IFID_SequenceItem);
  // class Class_IFID_RandomSequence extends Class_IFID_BaseSequence;
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off bcs
  `uvm_object_utils(Class_IFID_RandomSequence)
  // coverage on bcs

  /*
  * SEQUENCE CLASS MEMBERS
  * */
  int unsigned numSequenceItems = 10;

  // Constructor
  function new(string name = "Class_IFID_RandomSequence");
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
    // coverage off b
    `uvm_info("SEQUENCE", $sformatf("body(): Generating %0d Sequence Items", numSequenceItems),
              UVM_MEDIUM);
    // coverage on b

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
      // NOTE: Even though BaseSequence does not have any constraints for CRG,
      // and sequence items do not either, this body() method will be used
      // by derived classes!
      assert (ifid_sequenceItem.randomize() with {

        // General inputs
        DLX_PC_to_DP inside {[0 : (2 ** (IR_SIZE)) - 1]};
        DLX_IR_to_DP inside {[0 : (2 ** (IR_SIZE)) - 1]};

        // Stage 1 inputs
        IR_LATCH_EN inside {1'b0, 1'b1};
        NPC_LATCH_EN inside {1'b0, 1'b1};

        // Stage 2 inputs
        RegA_LATCH_EN inside {1'b0, 1'b1};
        SIGN_UNSIGN_EN inside {1'b0, 1'b1};
        RegIMM_LATCH_EN inside {1'b0, 1'b1};
        JAL_EN inside {1'b0, 1'b1};

        // Additional inputs
        RF_WE inside {1'b0, 1'b1};
        S4_REG_ADD_WR_OUT inside {[0 : (2 ** ($clog2(RF_NUMREGS) - 1))]};
        S5_MUX_DATAIN_OUT inside {[0 : (2 ** RF_REGBITS) - 1]};

      });

      // Signal the Sequencer that the initialization is done,
      // now Driver can pick up item using .get_next_item()
      finish_item(ifid_sequenceItem);
    end

    // coverage off b
    `uvm_info("SEQUENCE", $sformatf(
              "body(): Done generating %0d Sequence Items...", numSequenceItems), UVM_MEDIUM);
    // coverage on b
  endtask : body

endclass


/************************ ADDITION SEQUENCE ************************
 * This sequence specializes in performing corner-case addition    *
 * operations (zero, boundary values, overflow and underflow).     *
 *******************************************************************/
class Class_IFID_AdditionSequence extends uvm_sequence #(Class_IFID_SequenceItem);
  // class Class_IFID_AdditionSequence extends Class_IFID_BaseSequence;
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off bcs
  `uvm_object_utils(Class_IFID_AdditionSequence)
  // coverage on bcs

  /*
  * SEQUENCE CLASS MEMBERS
  * */
  int unsigned numSequenceItems = 10;

  // Constructor
  function new(string name = "Class_IFID_AdditionSequence");
    super.new(name);
    // coverage off b
    // Get numSequenceItems from config DB (default or overwritten by user)
    if (!uvm_config_db#(int)::get(null, "", "numSeqItems", numSequenceItems)) begin
      `uvm_error("SEQITEM", "Failed to get numSequenceItems from DB")
    end
    // coverage on b
  endfunction

  /*
  * BODY
  * */
  virtual task body();
    // coverage off b
    `uvm_info("SEQUENCE", $sformatf("body(): Generating %0d Sequence Items", numSequenceItems),
              UVM_MEDIUM);
    // coverage on b

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
      // NOTE: Even though BaseSequence does not have any constraints for CRG,
      // and sequence items do not either, this body() method will be used
      // by derived classes!
      assert (ifid_sequenceItem.randomize() with {
        /* Constrain OPCODE to be an addition */
        instr.bits[31:26] inside {
        // verilog_format: off
          ADD_op,  // Signed Addition
          SUB_op,  // Signed Subtraction

          // DLX Pro Version ALU Opcodes
          ADDU_op,  // Unsigned Addition
          SUBU_op  // Unsigned Subtraction
          // verilog_format: on
        };


        /* ADDITION OPERATION FIELDS */

        // verilog_format: off
        if (check_instr_type(instr) == I_TYPE) {
        // verilog_format: on

          /* I-TYPE instruction [OPCODE, RS1, RD, IMM] */
          instr.itype.rs1 inside {[0 : DLX_CPU_NUMREGS - 1]};
          instr.itype.rd inside {[0 : DLX_CPU_NUMREGS - 1]};

          // Check if opcode denotes signed addition
          // verilog_format: off
          if (check_instr_sign(instr) == SIGN_TYPE) {
          // verilog_format: on

            // Signed, constrain to check both overflow and underflow
            instr.itype.imm dist {
              MIN_VALUE_NBITS_SIGNED                                    := PROB_HIGH,
              [MIN_VALUE_NBITS_SIGNED + 1 : MAX_VALUE_NBITS_SIGNED - 1] := PROB_LOW,
              MAX_VALUE_NBITS_SIGNED                                    := PROB_HIGH
            };

          } else {

            // Unsigned, constrain to check overflow
            instr.itype.imm dist {
              [MIN_VALUE_NBITS_UNSIGNED : MAX_VALUE_NBITS_UNSIGNED - 1] := PROB_LOW,
              MAX_VALUE_NBITS_UNSIGNED                                  := PROB_HIGH
            };

          }

          // verilog_format: off
        } else if (check_instr_type(instr) == R_TYPE) {
          // verilog_format: on

          /* R_TYPE instruction */
          instr.rtype.rs1 inside {[0 : DLX_CPU_NUMREGS - 1]};
          instr.rtype.rs2 inside {[0 : DLX_CPU_NUMREGS - 1]};
          instr.rtype.rd inside {[0 : DLX_CPU_NUMREGS - 1]};
          instr.rtype.func inside {RTYPE_FUNC_ADD, RTYPE_FUNC_SUB, RTYPE_FUNC_ADDU, RTYPE_FUNC_SUBU};
        }

      });

      // Signal the Sequencer that the initialization is done,
      // now Driver can pick up item using .get_next_item()
      finish_item(ifid_sequenceItem);
    end

    // coverage off b
    `uvm_info("SEQUENCE", $sformatf(
              "body(): Done generating %0d Sequence Items...", numSequenceItems), UVM_MEDIUM);
    // coverage on b
  endtask : body

endclass


