// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

/*
* SEQUENCE ITEM: Data item to which can be grouped into a Sequence
* and then sent to the Driver.
  * Also implements Constraints on data so that the Sequencer generates
  * random constrained sequences to send to the Driver.
* */

// Import bins constants
import pkg_const::*;

class Class_ControlUnit_SequenceItem extends uvm_sequence_item;
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off bc
  `uvm_object_utils(Class_ControlUnit_SequenceItem);
  // coverage on bc

  // Constructor
  function new(string name = "Class_ControlUnit_SequenceItem");
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
  /* INPUTS */
  rand opcode_field_t opcode;
  rand func_field_t func;

  /* OUTPUTS */
  // First stage
  logic en_stage1;  // (RF + Stage 1 registers) Enable
  logic rf_rden_port1;  // RF Port 1 Read Enable
  logic rf_rden_port2;  // RF Port 2 Read Enable
  logic rf_wren;  // RF Write Enable
  // Second stage
  logic en_stage2;  // Enables stage 2 registers
  logic mux_a_sel;  // Operand A Mux Enable
  logic mux_b_sel;  // Operand B Mux Enable
  logic [1:0] alu_op_sel;  // Selects which of the four operations the ALU has to perform
  // Third stage
  logic en_stage3;  // Enables stage 3 registers and memory
  logic mem_rd_en;  // Memory Read Enable
  logic mem_wr_en;  // Memory Write Enable
  logic mux_wb_sel;  // Selection on Write Back Mux


  /*
  * SEQUENCE ITEM METHODS
  * */

  // Converts just the input fields into strings
  virtual function void print();
    // coverage off b
    `uvm_info("BLUE", $sformatf(
              "[SEQUENCE %0t] {OPCODE = %u, FUNC = %u}: %b%b%b%b %b%b%b%2b %b%b%b%b",
              $time,
              /* INPUTS */
              opcode,
              func,
              /* OUTPUTS */
              // Stage 1
              en_stage1,
              rf_rden_port1,
              rf_rden_port2,
              rf_wren,
              // Stage 2
              en_stage2,
              mux_a_sel,
              mux_b_sel,
              alu_op_sel,
              // Stage 3
              en_stage3,
              mem_rd_en,
              mem_wr_en,
              mux_wb_sel
              ), UVM_MEDIUM);
    // coverage on b
  endfunction

  // Copies "this" Sequence Item fields to the one passed as argument
  virtual function void copy(Class_ControlUnit_SequenceItem targetItem);
    // Copy all fields
    targetItem.opcode        = this.opcode;
    targetItem.func          = this.func;

    targetItem.en_stage1     = this.en_stage1;
    targetItem.rf_rden_port1 = this.rf_rden_port1;
    targetItem.rf_rden_port2 = this.rf_rden_port2;
    targetItem.rf_wren       = this.rf_wren;

    targetItem.en_stage2     = this.en_stage2;
    targetItem.mux_a_sel     = this.mux_a_sel;
    targetItem.mux_b_sel     = this.mux_b_sel;
    targetItem.alu_op_sel    = this.alu_op_sel;

    targetItem.en_stage3     = this.en_stage3;
    targetItem.mem_rd_en     = this.mem_rd_en;
    targetItem.mem_wr_en     = this.mem_wr_en;
    targetItem.mux_wb_sel    = this.mux_wb_sel;

    super.copy(targetItem);  // keep base-class stuff consistent
  endfunction

  /*
  * CONSTRAINED RANDOM GENERATION
  * */
  // Ensures OPCODE field is among a valid value
  constraint Constraint_ValidOpcode {
    // verilog_format: off
    opcode inside {
      /* R-TYPE */
      RTYPE,  // ADD SUB AND OR NOP
      /* I-TYPE */
      ITYPE_ADDI1,
      ITYPE_SUBI1,
      ITYPE_ANDI1,
      ITYPE_ORI1,
      ITYPE_ADDI2,
      ITYPE_SUBI2,
      ITYPE_ANDI2,
      ITYPE_ORI2,
      ITYPE_MOV,
      ITYPE_SREG1,
      ITYPE_SREG2,
      ITYPE_SMEM,
      ITYPE_LMEM1,
      ITYPE_LMEM2
    };
    // verilog_format: on
  }

  // FUNC field is defined only for R-TYPE ALU operations (ADD SUB AND OR)
  constraint Constraint_FuncDefined {

    // Only for R-Types instructions
    if (opcode == RTYPE) {
      func inside {RTYPE_NOP, RTYPE_ADD, RTYPE_SUB, RTYPE_AND, RTYPE_OR};
    } else {
      func inside {0};
    }

  }

endclass


/*
* SEQUENCE: Collection of many data items which can be combined to
* create various test scenarios.
* */
class Class_ControlUnit_Sequence extends uvm_sequence #(Class_ControlUnit_SequenceItem);
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off bc
  `uvm_object_utils(Class_ControlUnit_Sequence)
  // coverage on bc

  /*
  * SEQUENCE CLASS MEMBERS
  * */
  int unsigned numSequenceItems = 10;

  // Constructor
  function new(string name = "Class_ControlUnit_Sequence");
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

    // coverage off b
    `uvm_info("SEQUENCE", $sformatf("body(): Generating %0d valid Sequence Items", numSequenceItems
              ), UVM_MEDIUM);
    // coverage on b

    repeat (numSequenceItems) begin

      // Create instance of a new sequence item
      // NOTE: Do not specify "this" as parent because 2nd argument must
      // be of type uvm_component, while SequenceItem is uvm_sequence!
      Class_ControlUnit_SequenceItem ctrlunit_sequenceItem = Class_ControlUnit_SequenceItem::type_id::create(
          "ctrlunit_sequenceItem"
      );

      // Reserve Sequencer slot for current item
      start_item(ctrlunit_sequenceItem);

      // Randomize the item to let the Sequencer "execute"
      assert (ctrlunit_sequenceItem.randomize());

      // Signal the Sequencer that the initialization is done,
      // now Driver can pick up item using .get_next_item()
      finish_item(ctrlunit_sequenceItem);
    end

    // coverage off b
    `uvm_info("SEQUENCE", $sformatf(
              "body(): Done generating %0d Sequence Items...", numSequenceItems), UVM_MEDIUM);
    // coverage on b
  endtask : body

endclass

