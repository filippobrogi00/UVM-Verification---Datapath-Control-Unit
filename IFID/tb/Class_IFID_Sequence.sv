// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

// Import bins constants
import pkg_const::*;


/*****************************************
 ************* SEQUENCE ITEM *************
 *****************************************/


/*
* SEQUENCE ITEM: Data item to which can be grouped into a Sequence
* and then sent to the Driver.
  * TODO: Update
  * Also implements Constraints on data so that the Sequencer generates
  * random constrained sequences to send to the Driver.
* */
class Class_IFID_SequenceItem extends uvm_sequence_item;
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off b
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

  // SequenceItem fields
  // NOTE: Inputs delcared as rand even though they are actually
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
  * SEQUENCE ITEM METHODS
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

  endfunction


endclass




/********************************************
 ************* SEQUENCE CLASSES *************
 ********************************************/


/*
* BASE SEQUENCE: Virtual class which serves as a blueprint for derived classes
  * which will specify how to randomize sequence items of the sequence.
* */
// class Class_IFID_BaseSequence extends uvm_sequence #(Class_IFID_SequenceItem);
//   // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
//   `uvm_object_utils(Class_IFID_BaseSequence)
//
//   /*
//   * SEQUENCE CLASS MEMBERS
//   * */
//   Class_IFID_SequenceItem curr_ifid_seqitem = Class_IFID_SequenceItem::type_id::create(
//       "curr_ifid_seqitem"
//   );
//
//   int unsigned numSequenceItems = 10;
//
//   // Constructor
//   function new(string name = "Class_IFID_BaseSequence");
//     super.new(name);
//     // coverage off b
//     // Get numSequenceItems from config DB (default or overwritten by user)
//     if (!uvm_config_db#(int)::get(null, "", "numSeqItems", numSequenceItems)) begin
//       `uvm_error("SEQITEM", "Failed to get numSequenceItems from DB")
//     end
//     // coverage on b
//   endfunction
//
//   /*
//   * BODY :
//     * Creates the transactions to send to the Driver via the Sequencer
//     * Sends them via start_item() and end_item() function calls
//     * (Automatically called when sequence is started on a sequencer)
//   * */
//   virtual task body();
//     // coverage off b
//     `uvm_info("SEQUENCE", $sformatf("body(): Generating %0d Sequence Items", numSequenceItems),
//               UVM_MEDIUM);
//    // coverage on b
//
//     repeat (numSequenceItems) begin
//       // Create instance of a new sequence item
//       // NOTE: Do not specify "this" as parent because 2nd argument must
//       // be of type uvm_component, while SequenceItem is uvm_sequence!
//       Class_IFID_SequenceItem ifid_sequenceItem = Class_IFID_SequenceItem::type_id::create(
//           "ifid_sequenceItem"
//       );
//
//       // Reserve Sequencer slot for current item
//       start_item(ifid_sequenceItem);
//
//       // Randomize the item to let the Sequencer "execute"
//       // NOTE: Even though BaseSequence does not have any constraints for CRG,
//       // and sequence items do not either, this body() method will be used
//       // by derived classes!
//       assert (ifid_sequenceItem.randomize());
//
//       // Signal the Sequencer that the initialization is done,
//       // now Driver can pick up item using .get_next_item()
//       finish_item(ifid_sequenceItem);
//     end
//
//     // coverage off b
//     `uvm_info("SEQUENCE", $sformatf(
//               "body(): Done generating %0d Sequence Items...", numSequenceItems), UVM_MEDIUM);
//    // coverage on b
//   endtask : body
//
// endclass



/*
* LEGAL SEQUENCE: Inputs are constrained picking only legal values
* (allowed by the DUT logic)
* */
class Class_IFID_LegalSequence extends uvm_sequence #(Class_IFID_SequenceItem);
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off b
  `uvm_object_utils(Class_IFID_LegalSequence)
  // coverage on b

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
        /* VALID OPCODE CONSTRAINT */
        instr.bits[31:26] inside {
        // verilog_format: off
          NOP,
          ADD_op,  // Signed Addition
          AND_op,  // Bitwise
          OR_op,  // Bitwise
          SGE_op,  // Set Greater than or Equal to
          SLE_op,  // Set Less than or Equal to
          SLL_op,  // Unsigned Logical Shift Left
          SNE_op,  // Set Not Equal to
          SRL_op,  // Unsigned Arithmetic Shift Right
          SUB_op,  // Signed Subtraction
          XOR_op,  // Bitwise

          // DLX Pro Version ALU Opcodes
          SRA_op,  // Shift Right Arithmetic
          ADDU_op,  // Unsigned Addition
          SUBU_op,  // Unsigned Subtraction
          SEQ_op,  // Set if Equal
          SLT_op,  // Set if Less Than
          SGT_op,  // Set Greater Than
          SLTU_op,  // Set if Less Than (Unsigned)
          SGTU_op,  // Set Greater Than (Unsigned)
          SLEU_op,  // Set if Less Than or Equal (Unsigned)
          SGEU_op  // Set Greater Than or Equal (Unsigned)
        // verilog_format: on
        };


        /* VALID OPCODE CONSTRAINTS */

        if (check_instr_type(
            instr
        ) == I_TYPE) {

          /* I-TYPE instruction [OPCODE, RS1, RD, IMM] */
          instr.itype.rs1 inside {[0 : DLX_CPU_NUMREGS - 1]};
          instr.itype.rs2 inside {[0 : DLX_CPU_NUMREGS - 1]};

          // Check if opcode denotes signed operation
          if (check_instr_sign(
              instr
          ) == SIGN_TYPE) {
            // TODO: Fare trick come in Task 2 altrimenti warning [0, 2^NB-1-1]
            instr.itype.imm inside {[-(2 ** (NBITS - 1)) : +((2 ** (NBITS - 1)) - 1)]};
          } else {
            // Unsigned
            instr.itype.imm inside {[0 : 2 ** (NBITS - 1)]};
          }

        } else
        if (check_instr_type(
            instr
        ) == R_TYPE) {

          /* R_TYPE instruction */
          instr.rtype.rs1 inside {[0 : DLX_CPU_NUMREGS - 1]};
          instr.rtype.rs2 inside {[0 : DLX_CPU_NUMREGS - 1]};
          instr.rtype.rd inside {[0 : DLX_CPU_NUMREGS - 1]};

          // FUNC field, every possible type of R_TYPE operation
          // func inside {SLL_op, SRL_op, ADD_op, SUB_op, AND_op, OR_op, XOR_op, SNE_op, SLE_op, SGE_op, SRA_op, ADDU_op, SUBU_op, SEQ_op, SLT_op, SGT_op, SLTU_op, SGTU_op, SLEU_op, SGEU_op};
          // TODOO: Spaghetti, needs fixing later on!
          instr.rtype.func inside {4, 6, 32, 34, 36, 37, 38, 41, 44, 45, 7, 33, 35, 40, 42, 43, 58, 59, 60, 61};

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

          if (
          // OPCODE is that of a jump instruction, and so JUMP_EN = 1
          instr.bits[31:26] == ADD_op &&
          // and either:
          (
          // JMP flag is set (CW bit #7) (unconditional jump)
          DLX_IR_to_DP[7] == 1'b1 ||
          // or target register is zero and "BEQZ" flag is set (CW bit #6)
          (S2_RFILE_A_OUT == '0 && DLX_IR_to_DP[6] == 1'b1) ||
          // or target register is NOT zero and "BNEZ" flag is set
          (S2_RFILE_A_OUT != '0 && DLX_IR_to_DP[6] == 1'b0))) {
            instr.jtype.imm inside {[0 : IRAM_DEPTH]};
          }

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


/*
* RANDOM SEQUENCE: Inputs are constrained randomically, feeding the DUT
* potentially wrong inputs.
* */
class Class_IFID_RandomSequence extends uvm_sequence #(Class_IFID_SequenceItem);
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off b
  `uvm_object_utils(Class_IFID_RandomSequence)
  // coverage on b

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
        DLX_PC_to_DP inside {[0 : (2 ** (IR_SIZE - 1)) - 1]};
        DLX_IR_to_DP inside {[0 : (2 ** (IR_SIZE - 1)) - 1]};

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
        S4_REG_ADD_WR_OUT inside {[0 : (2 ** ($clog2(RF_NUMREGS) - 1)) - 1]};
        S5_MUX_DATAIN_OUT inside {[0 : (2 ** (RF_REGBITS - 1)) - 1]};

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

/***************************************************************************************************************************************
  * ESEMPIO GIUSEPPE TODO ELIMINARE
  * *************************************************************************************************************************************/
// `ifndef FULL_TEST_SVH
// `define FULL_TEST_SVH
//
// class full_test extends base_test;
//   `uvm_component_utils(full_test);
//
//   random_sequence random_seq;
//   zero_sequence zero_seq;
//   allones_sequence allones_seq;
//   coverage_driven_sequence coverage_driven_seq;
//
//   function new(string name, uvm_component parent);
//     super.new(name, parent);
//     test_type = "FULL TEST";
//   endfunction : new
//
//
//   task run_phase(uvm_phase phase);
//     random_seq          = new("random_seq");
//     zero_seq            = new("zero_seq");
//     allones_seq         = new("allones_seq");
//     coverage_driven_seq = new("coverage_driven_seq");
//     phase.raise_objection(this);
//
//     fork
//       random_seq.start(sequencer_h);
//       zero_seq.start(sequencer_h);
//       allones_seq.start(sequencer_h);
//       coverage_driven_seq.start(sequencer_h);
//     join
//
//     phase.drop_objection(this);
//   endtask : run_phase
//
//   function void report();
//     `uvm_info("FINAL REPORT", "===============================================", UVM_LOW)
//     `uvm_info("FINAL REPORT", "                   FULL TEST                   ", UVM_LOW)
//     `uvm_info("FINAL REPORT", "===============================================", UVM_LOW)
//   endfunction
//
//
// endclass : full_test
//
// `endif
//
//
//
// `ifndef ALLONES_SEQUENCE_SVH
// `define ALLONES_SEQUENCE_SVH
//
// import my_pkg::NBIT;
// class allones_sequence extends uvm_sequence #(sequence_item);
//   `uvm_object_utils(allones_sequence)
//
//
//   sequence_item command;
//
//   function new(string name = "allones sequence");
//     super.new(name);
//   endfunction : new
//
//   task body();
//     `uvm_info("ALLONES SEQUENCE", "Beginning allones generation", UVM_HIGH)
//     command = sequence_item::type_id::create("command");
//     repeat (100) begin
//       start_item(command);
//       assert (command.randomize());
//       command.a = {NBIT{1'b1}};  // Imposing allones on a
//       finish_item(command);
//     end
//     repeat (100) begin
//       start_item(command);
//       assert (command.randomize());
//       command.b = {NBIT{1'b1}};  // Imposing allones on b
//       finish_item(command);
//     end
//     repeat (100) begin
//       start_item(command);
//       assert (command.randomize());
//       command.ci = 1;  // Imposing allones on b
//       finish_item(command);
//     end
//
//     start_item(command);
//     command.a  = {NBIT{1'b1}};  // Imposing allones on a
//     command.b  = {NBIT{1'b1}};  // Imposing allones on b
//     command.ci = 1;  // Imposing allones on b
//     finish_item(command);
//
//   endtask : body
//
// endclass : allones_sequence
//
// `endif
//
//
//
//
//
//
//
