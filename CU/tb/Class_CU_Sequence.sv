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
class Class_CU_SequenceItem extends uvm_sequence_item;
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off bcs
  `uvm_object_utils(Class_CU_SequenceItem)
  // coverage on bcs

  // Constructor
  function new(string name = "Class_CU_SequenceItem");
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
  randc logic [IR_SIZE-1:0] IR_IN;

  // IR instruction, with fields depending on its type
  // NOTE: Not a real input/signal, just an alias used for CRG.
  InstrType instr;

  /***********
  *  OUTPUTS *
  ************/
  /* Stage 1 Control Signals */
  logic IR_LATCH_EN;  // Instruction Register Latch Enable
  logic NPC_LATCH_EN;  // NextProgramCounter Register Latch Enable

  /* Stage 2 Control Signals */
  logic RegA_LATCH_EN;  // Register A Latch Enable
  logic RegB_LATCH_EN;  // Register B Latch Enable
  logic RegIMM_LATCH_EN;  // Immediate Register Latch Enable
  logic JAL_EN;  // Control Signal for Jump and Link Instruction

  /* Stage 3 Control Signals */
  logic MUXA_SEL;  //MUX-A Sel
  logic MUXB_SEL;  //MUX-B Sel
  logic ALU_OUTREG_EN;  //ALU Output Register Enable
  logic EQ_COND;  //Branch if (not) Equal to Zero
  logic JMP;  //Control Signal for unconditional Jump Instructions.
  logic EQZ_NEQZ;  //Control Signal for bnez Instruction ('0') and beqz Instruction ('1').
  aluOp ALU_OPCODE; // choose between implicit or exlicit coding, like std_logic_vector(ALU_OPC_SIZE -1 downto 0);

  /* Stage 4 Control Signals */
  logic DRAM_WE;  // Data RAM Write Enable
  logic LMD_LATCH_EN;  // LMD Register Latch Enable
  logic JUMP_EN;  // JUMP Enable Signal for PC input MUX
  logic PC_LATCH_EN;  // Program Counte Latch Enable

  /* Stage 5 Control Signals */
  logic WB_MUX_SEL;  // Write Back MUX Sel
  logic RF_WE;  // Register File Write Enable


  /*
  * SEQUENCE ITEM METHODS
  * */

  // Converts just the input fields into strings
  virtual function void print();
    // coverage off
    `uvm_info("BLUE",
              $sformatf(
              {
                "-------- ITEM INFO --------\n",
                "/***** INPUTS   *****/",
                " IR = %x\n",
                "/***** OUTPUTS   *****/",
                " Control Word Out: (S1\tS2\tS3\tS4\tS5):\n"
                " %b%b\t%b%b%b%b\t%b%b%b%b%b%b%b\t%b%b%b%b\t%b%b\n"
                "/** STAGE 1: **/\n"
                "IR_LATCH_EN = %b\n"
                "NPC_LATCH_EN = %b\n"
                "/** STAGE 2: **/\n"
                "RegA_LATCH_EN = %b\n"
                "RegB_LATCH_EN = %b\n"
                "RegIMM_LATCH_EN = %b\n"
                "JAL_EN = %b\n"
                "/** STAGE 3: **/\n"
                "MUXA_SEL = %b\n"
                "MUXB_SEL = %b\n"
                "ALU_OUTREG_EN = %b\n"
                "EQ_COND = %b\n"
                "JMP = %b\n"
                "EQZ_NEQZ = %b\n"
                "ALU_OPCODE = %b\n"
                "EQ_COND = %b\n"
                "EQ_COND = %b\n"
                "/** STAGE 4: **/\n"
                "DRAM_WE = %b\n"
                "LMD_LATCH_EN = %b\n"
                "JUMP_EN = %b\n"
                "PC_LATCH_EN = %b\n"
                "/** STAGE 5: **/\n"
                "WB_MUX_SEL = %b\n"
                "RF_WE = %b\n"
                "---------------------------\n"
              },
              // Inputs
              DLX_IR_to_DP,
              // S1
              IR_LATCH_EN,
              NPC_LATCH_EN,
              // S2
              RegA_LATCH_EN,
              RegB_LATCH_EN,
              RegIMM_LATCH_EN,
              JAL_EN,
              // S3
              MUXA_SEL,
              MUXB_SEL,
              ALU_OUTREG_EN,
              EQ_COND,
              JMP,
              EQZ_NEQZ,
              ALU_OPCODE,
              // S4
              DRAM_WE,
              LMD_LATCH_EN,
              JUMP_EN,
              PC_LATCH_EN,
              // S5
              WB_MUX_SEL
              RF_WE,
              ), UVM_MEDIUM);
    // coverage on
  endfunction

  // Copies "src" seqitem fields into "dest" seqitem
  virtual function void copy(Class_CU_SequenceItem src, Class_CU_SequenceItem dest);
    // coverage off

    /* INPUTS */
    dest.IR_IN           = src.IR_IN;

    /* OUTPUTS */
    // Stage 1
    dest.IR_LATCH_EN     = src.IR_LATCH_EN;
    dest.NPC_LATCH_EN    = src.NPC_LATCH_EN;
    // Stage 2
    dest.RegA_LATCH_EN   = src.RegA_LATCH_EN;
    dest.RegB_LATCH_EN   = src.RegB_LATCH_EN;
    dest.RegIMM_LATCH_EN = src.RegIMM_LATCH_EN;
    dest.JAL_EN          = src.JAL_EN;
    // Stage 3
    dest.MUXA_SEL        = src.MUXA_SEL;
    dest.MUXB_SEL        = src.MUXB_SEL;
    dest.ALU_OUTREG_EN   = src.ALU_OUTREG_EN;
    dest.EQ_COND         = src.EQ_COND;
    dest.JMP             = src.JMP;
    dest.EQZ_NEQZ        = src.EQZ_NEQZ;
    dest.ALU_OPCODE      = src.ALU_OPCODE;
    // Stage 4
    dest.DRAM_WE         = src.DRAM_WE;
    dest.LMD_LATCH_EN    = src.LMD_LATCH_EN;
    dest.JUMP_EN         = src.JUMP_EN;
    dest.PC_LATCH_EN     = src.PC_LATCH_EN;
    // Stage 5
    dest.WB_MUX_SEL      = src.WB_MUX_SEL;
    dest.RF_WE           = src.RF_WE;

    // coverage on

  endfunction


endclass




/********************************************
 ************* SEQUENCE CLASSES *************
 ********************************************/

/************************ LEGAL SEQUENCE **************************
 * Inputs are constrained picking only legal values (allowed      *
 * by the DUT logic).                                             *
 ******************************************************************/
class Class_CU_LegalSequence extends uvm_sequence #(Class_CU_SequenceItem);
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off bcs
  `uvm_object_utils(Class_CU_LegalSequence)
  // coverage on bcs

  /*
  * SEQUENCE CLASS MEMBERS
  * */
  int unsigned numSequenceItems = 10;

  // Constructor
  function new(string name = "Class_CU_LegalSequence");
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
      Class_CU_SequenceItem cu_sequenceItem = Class_CU_SequenceItem::type_id::create(
          "cu_sequenceItem"
      );

      // Reserve Sequencer slot for current item
      start_item(cu_sequenceItem);

      // Randomize the item to let the Sequencer "execute"
      assert (cu_sequenceItem.randomize() with {
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

          // verilog_format: off
          if
            (
              // OPCODE is that of a jump instruction, and so JUMP_EN = 1
              instr.bits[31:26] == ADD_op &&
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
      finish_item(cu_sequenceItem);
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
class Class_CU_RandomSequence extends uvm_sequence #(Class_CU_SequenceItem);
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off bcs
  `uvm_object_utils(Class_CU_RandomSequence)
  // coverage on bcs

  /*
  * SEQUENCE CLASS MEMBERS
  * */
  int unsigned numSequenceItems = 10;

  // Constructor
  function new(string name = "Class_CU_RandomSequence");
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
      Class_CU_SequenceItem cu_sequenceItem = Class_CU_SequenceItem::type_id::create(
          "cu_sequenceItem"
      );

      // Reserve Sequencer slot for current item
      start_item(cu_sequenceItem);

      // Randomize the item to let the Sequencer "execute"
      // verilog_format: off
      assert (cu_sequenceItem.randomize() with {

        IR_IN inside {[0 : 2 ** (IR_SIZE) - 1]};

      });
      // verilog_format: on

      // Signal the Sequencer that the initialization is done,
      // now Driver can pick up item using .get_next_item()
      finish_item(cu_sequenceItem);
    end

    // coverage off b
    `uvm_info("SEQUENCE", $sformatf(
              "body(): Done generating %0d Sequence Items...", numSequenceItems), UVM_MEDIUM);
    // coverage on b
  endtask : body

endclass


/************************ ??? SEQUENCE ************************
 *  *
 *  *
 *******************************************************************/














