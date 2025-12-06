// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* SEQUENCE ITEM: Data item to which can be grouped into a Sequence
* and then sent to the Driver.
  * Also implements Constraints on data so that the Sequencer generates
  * random constrained sequences to send to the Driver.
* */

// Import bins constants
import pkg_const::*;

class Class_MEMWB_SequenceItem extends uvm_sequence_item;
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  `uvm_object_utils(Class_MEMWB_SequenceItem);

  // Constructor
  function new(string name = "Class_MEMWB_SequenceItem");
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

  // IR_SIZE vector inputs
  rand logic [IR_SIZE - 1 : 0] DRAM_OUT;
  rand logic [IR_SIZE - 1 : 0] S1_ADD_OUT;
  rand logic [IR_SIZE - 1 : 0] S3_REG_NPC_OUT;
  rand logic [IR_SIZE - 1 : 0] S3_REG_ALU_OUT;
  rand logic [IR_SIZE - 1 : 0] S3_REG_DATA_OUT;

  //Control signal inputs
  rand logic                   S3_FF_JAL_EN_OUT;
  rand logic                   S3_FF_COND_OUT;
  rand logic                   DRAM_WE;
  rand logic                   LMD_LATCH_EN;
  rand logic                   JUMP_EN;
  rand logic                   PC_LATCH_EN;
  rand logic                   WB_MUX_SEL;
  rand logic                   RF_WE;

  //IR_SIZE vector outputs
  logic [IR_SIZE - 1 : 0]      DP_TO_DLX_PC;
  logic [IR_SIZE - 1 : 0]      S5_MUX_DATAIN_OUT;

  //Forwarded signals
  rand logic [4 : 0]           S3_REG_ADD_WR_OUT; // input
  logic [4 : 0]                S4_REG_ADD_WR_OUT; // output


  /*
  * SEQUENCE ITEM METHODS
  * */

  // Converts just the input fields into strings
  virtual function void print();
  endfunction

  virtual function void copy(Class_MEMWB_SequenceItem targetItem);
    // Copy all fields
    targetItem.DRAM_OUT          = this.DRAM_OUT;
    targetItem.S1_ADD_OUT        = this.S1_ADD_OUT;
    targetItem.S3_REG_NPC_OUT    = this.S3_REG_NPC_OUT;
    targetItem.S3_REG_ALU_OUT    = this.S3_REG_ALU_OUT;
    targetItem.S3_REG_DATA_OUT   = this.S3_REG_DATA_OUT;
                                                         ;
    targetItem.S3_FF_JAL_EN_OUT     = this.S3_FF_JAL_EN_OUT;
    targetItem.S3_FF_COND_OUT    = this.S3_FF_COND_OUT;
    targetItem.DRAM_WE           = this.DRAM_WE;
    targetItem.LMD_LATCH_EN      = this.LMD_LATCH_EN;
    targetItem.JUMP_EN           = this.JUMP_EN;
    targetItem.PC_LATCH_EN       = this.PC_LATCH_EN;
    targetItem.WB_MUX_SEL        = this.WB_MUX_SEL;
    targetItem.RF_WE             = this.RF_WE;

    targetItem.DP_TO_DLX_PC      = this.DP_TO_DLX_PC;
    targetItem.S5_MUX_DATAIN_OUT = this.S5_MUX_DATAIN_OUT;

    targetItem.S3_REG_ADD_WR_OUT = this.S3_REG_ADD_WR_OUT;
    targetItem.S4_REG_ADD_WR_OUT = this.S4_REG_ADD_WR_OUT;
    super.copy(targetItem);  // keep base-class stuff consistent
  endfunction
  /* CONSTRAINED RANDOM GENERATION */

  // There are no functional constraints.
  constraint Probability {
  }

endclass


/*
* SEQUENCE: Collection of many data items which can be combined to
* create various test scenarios.
* */
class Class_MEMWB_Sequence extends uvm_sequence #(Class_MEMWB_SequenceItem);
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  `uvm_object_utils(Class_MEMWB_Sequence)

  /*
  * SEQUENCE CLASS MEMBERS
  * */
  int unsigned numSequenceItems = 10;

  // Constructor
  function new(string name = "Class_MEMWB_Sequence");
    super.new(name);
    // Get numSequenceItems from config DB (default or overwritten by user)
    // coverage off b
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

    `uvm_info("SEQUENCE", $sformatf("body(): Generating %0d valid Sequence Items", numSequenceItems
              ), UVM_MEDIUM);

    repeat (numSequenceItems) begin
      // Create instance of a new sequence item
      // NOTE: Do not specify "this" as parent because 2nd argument must
      // be of type uvm_component, while SequenceItem is uvm_sequence!
      Class_MEMWB_SequenceItem memwb_sequenceItem = Class_MEMWB_SequenceItem::type_id::create(
          "memwb_sequenceItem"
      );

      // Reserve Sequencer slot for current item
      start_item(memwb_sequenceItem);

      // Randomize the item to let the Sequencer "execute"
      assert(memwb_sequenceItem.randomize());

      // Signal the Sequencer that the initialization is done,
      // now Driver can pick up item using .get_next_item()
      finish_item(memwb_sequenceItem);
    end

    `uvm_info("SEQUENCE", $sformatf(
              "body(): Done generating %0d Sequence Items...", numSequenceItems), UVM_MEDIUM);
  endtask : body
endclass

