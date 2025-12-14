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
  rand InstrType instr;

  /***********
  *  OUTPUTS *
  ************/
  /* Stage 1 Control Signals */
  logic IR_LATCH_EN;  // Instruction Register Latch Enable
  logic NPC_LATCH_EN;  // NextProgramCounter Register Latch Enable

  /* Stage 2 Control Signals */
  logic RegA_LATCH_EN;  // Register A Latch Enable
  logic SIGN_UNSIGN_EN;  // Signed vs Unsigned operand Enable
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
    `uvm_info("BLUE", $sformatf(
              {
                "-------- ITEM INFO --------\n",
                "/***** INPUTS   *****/\n",
                " IR = %x\n",
                "/***** OUTPUTS (as Control Word)  *****/\n",
                " Control Word Out: (S1\tS2\tS3 (AluOpcode)\tS4\tS5):\n",
                " %b%b\t%b%b%b%b\t%b%b%b%b%b%b (%d)\t%b%b%b%b\t%b%b\n",
                "/***** OUTPUTS (as bits)  *****/\n",
                "/** STAGE 1: **/\n",
                "IR_LATCH_EN = %b\n",
                "NPC_LATCH_EN = %b\n",
                "/** STAGE 2: **/\n",
                "RegA_LATCH_EN = %b\n",
                "SIGN_UNSIGN_EN = %b\n",
                "RegIMM_LATCH_EN = %b\n",
                "JAL_EN = %b\n",
                "/** STAGE 3: **/\n",
                "MUXA_SEL = %b\n",
                "MUXB_SEL = %b\n",
                "ALU_OUTREG_EN = %b\n",
                "EQ_COND = %b\n",
                "JMP = %b\n",
                "EQZ_NEQZ = %b\n",
                "ALU_OPCODE = %d\n",
                "/** STAGE 4: **/\n",
                "DRAM_WE = %b\n",
                "LMD_LATCH_EN = %b\n",
                "JUMP_EN = %b\n",
                "PC_LATCH_EN = %b\n",
                "/** STAGE 5: **/\n",
                "WB_MUX_SEL = %b\n",
                "RF_WE = %b\n",
                "---------------------------\n"
              },
              /***** INPUTS   *****/
              this.IR_IN,
              /***** OUTPUTS (as Control Word)  *****/
              this.IR_LATCH_EN,
              this.NPC_LATCH_EN,
              this.RegA_LATCH_EN,
              this.SIGN_UNSIGN_EN,
              this.RegIMM_LATCH_EN,
              this.JAL_EN,
              this.MUXA_SEL,
              this.MUXB_SEL,
              this.ALU_OUTREG_EN,
              this.EQ_COND,
              this.JMP,
              this.EQZ_NEQZ,
              this.ALU_OPCODE,
              this.DRAM_WE,
              this.LMD_LATCH_EN,
              this.JUMP_EN,
              this.PC_LATCH_EN,
              this.WB_MUX_SEL,
              this.RF_WE,
              /***** OUTPUTS (as bits)  *****/
              /** STAGE 1 **/
              this.IR_LATCH_EN,
              this.NPC_LATCH_EN,
              /** STAGE 2 **/
              this.RegA_LATCH_EN,
              this.SIGN_UNSIGN_EN,
              this.RegIMM_LATCH_EN,
              this.JAL_EN,
              /** STAGE 3 **/
              this.MUXA_SEL,
              this.MUXB_SEL,
              this.ALU_OUTREG_EN,
              this.EQ_COND,
              this.JMP,
              this.EQZ_NEQZ,
              this.ALU_OPCODE,
              /** STAGE 4 **/
              this.DRAM_WE,
              this.LMD_LATCH_EN,
              this.JUMP_EN,
              this.PC_LATCH_EN,
              /** STAGE 5 **/
              this.WB_MUX_SEL,
              this.RF_WE
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
    dest.SIGN_UNSIGN_EN  = src.SIGN_UNSIGN_EN;
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

/************************ I-TYPE SEQUENCE ***************
 * Generates I-TYPE instructions constrained to legal values. *
 **************************************************************/
class Class_CU_ITYPE_Sequence extends uvm_sequence #(Class_CU_SequenceItem);
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off bcs
  `uvm_object_utils(Class_CU_ITYPE_Sequence)
  // coverage on bcs

  /*
  * SEQUENCE CLASS MEMBERS
  * */
  int unsigned numSequenceItems = 10;

  // Constructor
  function new(string name = "Class_CU_ITYPE_Sequence");
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

        /***********************
         * I-TYPE instruction  *
         ***********************/
      
        /* I-TYPE - OPCODE Constraints */
        IR_IN[31:26] inside {
          // --- DLX Basic Version ---
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

        /* I-TYPE - fields constraints */
        IR_IN[25:21] inside {[0 : DLX_CPU_NUMREGS - 1]};
        IR_IN[20:16] inside {[0 : DLX_CPU_NUMREGS - 1]};

        /* I-TYPE - Constrain IMM field based on Signed/Unsigned instruction. */
        // Check if opcode denotes signed operation
        // if (check_instr_sign(IR_IN) == SIGN_TYPE) {
        //   // Constrain as signed
        //   IR_IN[15:0] inside {[-(2 ** (I_TYPE_IMM_SIZE - 1)) : +((2 ** (I_TYPE_IMM_SIZE - 1)) - 1)]};
        // } else {
        //   // Constrain as unsigned
        //   IR_IN[15:0] inside {[0 : (2 ** I_TYPE_IMM_SIZE) - 1]};
        // }

        if (IR_IN[31:26] inside {
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
            ITYPE_OPCODE_SGTI   // sgti
          }) {
            // Constrain as signed
            IR_IN[15:0] inside {[-(2 ** (I_TYPE_IMM_SIZE - 1)) : +((2 ** (I_TYPE_IMM_SIZE - 1)) - 1)]};
          } else {
            // Constrain as unsigned
            IR_IN[15:0] inside {[0 : (2 ** I_TYPE_IMM_SIZE) - 1]};
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


/************************ J-TYPE SEQUENCE *********************
 * Generates J-TYPE instructions constrained to legal values. *
 **************************************************************/
 class Class_CU_JTYPE_Sequence extends uvm_sequence #(Class_CU_SequenceItem);
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off bcs
  `uvm_object_utils(Class_CU_JTYPE_Sequence)
  // coverage on bcs

  /*
  * SEQUENCE CLASS MEMBERS
  * */
  int unsigned numSequenceItems = 10;

  // Constructor
  function new(string name = "Class_CU_JTYPE_Sequence");
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

        /***********************
         * J-TYPE instruction  *
         ***********************/
      
        /* J-TYPE OPCODE Constraint */
        IR_IN[31:26] inside {
          JTYPE_OPCODE_J,  // j
          JTYPE_OPCODE_JAL,  // jal
          JTYPE_OPCODE_BEQZ,  // beqz
          JTYPE_OPCODE_BNEZ  // bnez
        };

        /* J-TYPE Immediate field constraint */
        IR_IN[25:0] inside {[0 : (2 ** J_TYPE_IMM_SIZE) - 1]};
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


/************************ R-TYPE SEQUENCE *********************
 * Generates R-TYPE instructions constrained to legal values. *
 **************************************************************/
 class Class_CU_RTYPE_Sequence extends uvm_sequence #(Class_CU_SequenceItem);
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off bcs
  `uvm_object_utils(Class_CU_RTYPE_Sequence)
  // coverage on bcs

  /*
  * SEQUENCE CLASS MEMBERS
  * */
  int unsigned numSequenceItems = 10;

  // Constructor
  function new(string name = "Class_CU_RTYPE_Sequence");
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

        /***********************
         * R-TYPE instruction  *
         ***********************/
    
        /* R-TYPE OPCODE constraints */
        IR_IN[31:26] inside {RTYPE_OPCODE};

        /* R-TYPE field constraints */
        IR_IN[25:21] inside {[0 : DLX_CPU_NUMREGS - 1]};
        IR_IN[20:16] inside {[0 : DLX_CPU_NUMREGS - 1]};
        IR_IN[15:11] inside {[0 : DLX_CPU_NUMREGS - 1]};

        /* R-TYPE FUNC field constraint: every possible type of R_TYPE operation */
        IR_IN[10:0] inside {
        
          // --- DLX Basic Version ---
          RTYPE_FUNC_SLL,  // sll
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
      assert (cu_sequenceItem.randomize() with {

        // Randomly constrain raw instruction bits
        IR_IN inside {[0 : (2 ** (IR_SIZE)) - 1]};

        // Safety constraint check not to access invalid memory locations (overflow)
        IR_IN[31:26] inside {[0 : MICROCODE_MEM_SIZE-1]};

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



        
 






















 /************************ TEST SEQUENCE ************************
  * Generates a SRL operation (OPCODE 0, FUNC = SRL_op) *
  *******************************************************************/
// class Class_CU_TestSequence extends uvm_sequence #(Class_CU_SequenceItem);

//   // coverage off bcs
//   `uvm_object_utils(Class_CU_TestSequence)
//   // coverage on bcs

//   int unsigned numSequenceItems = 10;

//   function new(string name = "Class_CU_TestSequence");
//     super.new(name);
//   endfunction

//   virtual task body();

//     // coverage off b
//     `uvm_info("SEQUENCE", $sformatf("body(): Generating %0d Sequence Items", numSequenceItems),
//               UVM_MEDIUM);
//     // coverage on b

//     repeat (numSequenceItems) begin
//       // Create instance of a new sequence item
//       // NOTE: Do not specify "this" as parent because 2nd argument must
//       // be of type uvm_component, while SequenceItem is uvm_sequence!
//       Class_CU_SequenceItem cu_sequenceItem = Class_CU_SequenceItem::type_id::create(
//           "cu_sequenceItem"
//       );

//       // Reserve Sequencer slot for current item
//       start_item(cu_sequenceItem);

//       // Randomization
//       assert (randomize() with {

//           // Set OPCODE to R-TYPE
//           IR_IN[31:26] inside {RTYPE_OPCODE};

//           // Set RS1, RS2, RD to any valid register
//           IR_IN[25:21] inside {[0 : DLX_CPU_NUMREGS - 1]};  // RS1
//           IR_IN[20:16] inside {[0 : DLX_CPU_NUMREGS - 1]};  // RS2
//           IR_IN[15:11] inside {[0 : DLX_CPU_NUMREGS - 1]};  // RD

//           // Set FUNC to SRL
//           IR_IN[10:0] inside {RTYPE_FUNC_SRL};

//       });

//       // Signal the Sequencer that the initialization is done,
//       // now Driver can pick up item using .get_next_item()
//       finish_item(cu_sequenceItem);
//     end

//     // coverage off b
//     `uvm_info("SEQUENCE", $sformatf(
//               "body(): Done generating %0d Sequence Items...", numSequenceItems), UVM_MEDIUM);
//     // coverage on b
//   endtask : body

// endclass

// class Class_CU_TestSequence extends uvm_sequence #(Class_CU_SequenceItem);

//   `uvm_object_utils(Class_CU_TestSequence)

//   int unsigned numSequenceItems = 1;

//   virtual task body();
//     repeat (numSequenceItems) begin
//       Class_CU_SequenceItem cu_sequenceItem = Class_CU_SequenceItem::type_id::create("cu_sequenceItem");

//       start_item(cu_sequenceItem);

//       // Hardcode the instruction
//       // cu_sequenceItem.IR_IN = 32'b000000_00001_00010_00011_00000000110;  // Example: R-Type, FUNC = SRL (6)
//       assert (cu_sequenceItem.randomize() with {
//         cu_sequenceItem.IR_IN[31:26] inside {RTYPE_OPCODE};   // OPCODE for R-TYPE
//         cu_sequenceItem.IR_IN[10:0] inside {RTYPE_FUNC_ADD};  // FUNC for SRL
//       });

//       `uvm_info("DEBUG", $sformatf("Hardcoded IR_IN: %b (OPCODE: %0d, FUNC: %0d)", 
//                                    cu_sequenceItem.IR_IN, cu_sequenceItem.IR_IN[31:26], cu_sequenceItem.IR_IN[10:0]), UVM_MEDIUM);

//       finish_item(cu_sequenceItem);
//     end
//   endtask

// endclass