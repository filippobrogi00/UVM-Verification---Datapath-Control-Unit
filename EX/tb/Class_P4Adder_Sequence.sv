// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

/*
* SEQUENCE ITEM: Data item to which can be grouped into a Sequence
* and then sent to the Driver.
  * Also implements Constraints on data so that the Sequencer generates
  * random constrained sequences to send to the Driver.
* */

// Import bins constants
import pkg_const::*;

class Class_P4Adder_SequenceItem extends uvm_sequence_item;
  // coverage off b
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  `uvm_object_utils(Class_P4Adder_SequenceItem);
  // coverage on b

  // Constructor
  function new(string name = "Class_P4Adder_SequenceItem");
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

  // Shadow fields used only for randomization
  rand int signed sint_A, sint_B;

  // Actual SequenceItem fields (A, B actually overwritten by sint_A, sint_B)
  logic signed [NBITS-1:0] A, B;
  rand logic Cin;
  logic signed [NBITS-1:0] Sum;
  logic Cout;

  /*
  * SEQUENCE ITEM METHODS
  * */

  // Converts just the input fields into strings
  virtual function void print();
    `uvm_info("ITEM", $sformatf(
              "A = %0d, B = %0d, Cin = %0d, sint_A = %0b, sint_B = %0b", A, B, Cin, sint_A, sint_B),
              UVM_MEDIUM);
  endfunction

  /*
  * CONSTRAINED RANDOM GENERATION
  * */
  constraint Constraint_LegalInputs_EdgeSkewed {

    sint_A dist {
      MIN_NEG_VALUE :/ 20,  // minimum value 'b1000000
      [MIN_NEG_VALUE + 1 : MINUS_ONE - 1] :/ 10,        // rest of nevative values (treat as unsigned otherwise vsim error)
      MINUS_ONE :/ 20,  // -1
      ZERO :/ 15,  // 0
      ONE :/ 15,  // 1
      [ONE+1 : MAX_POS_VALUE-1]               :/ 10,  // rest of positive values (treat as unsigned otherwise vsim error)
      MAX_POS_VALUE :/ 20  // maximum value 'b0111111
    };

    sint_B dist {
      MIN_NEG_VALUE :/ 20,  // minimum value 'b1000000
      [MIN_NEG_VALUE + 1 : MINUS_ONE - 1] :/ 10,        // rest of nevative values (treat as unsigned otherwise vsim error)
      MINUS_ONE :/ 20,  // -1
      ZERO :/ 15,  // 0
      ONE :/ 15,  // 1
      [ONE+1 : MAX_POS_VALUE-1]               :/ 10,  // rest of positive values (treat as unsigned otherwise vsim error)
      MAX_POS_VALUE :/ 20  // maximum value 'b0111111
    };

    Cin inside {[0 : 1]};
  }

  // Called after .randomize()
  function void post_randomize();
    super.post_randomize();
    A = $signed(sint_A[NBITS-1:0]);
    B = $signed(sint_B[NBITS-1:0]);
  endfunction

endclass


/*
* SEQUENCE: Collection of many data items which can be combined to
* create various test scenarios.
* */
class Class_P4Adder_Sequence extends uvm_sequence #(Class_P4Adder_SequenceItem);
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  `uvm_object_utils(Class_P4Adder_Sequence)

  /*
  * SEQUENCE CLASS MEMBERS
  * */
  int unsigned numSequenceItems = 10;

  // Constructor
  function new(string name = "Class_P4Adder_Sequence");
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
              "body(): Generating %0d Sequence Items in [-2**(%0d-1), +(2**(%0d-1))-1]...",
              numSequenceItems,
              NBITS,
              NBITS
              ), UVM_MEDIUM);

    repeat (numSequenceItems) begin
      // Create instance of a new sequence item
      // NOTE: Do not specify "this" as parent because 2nd argument must
      // be of type uvm_component, while SequenceItem is uvm_sequence!
      Class_P4Adder_SequenceItem p4adder_sequenceItem = Class_P4Adder_SequenceItem::type_id::create(
          "p4adder_sequenceItem"
      );

      // Reserve Sequencer slot for current item
      start_item(p4adder_sequenceItem);

      // Randomize the item to let the Sequencer "execute"
      assert (p4adder_sequenceItem.randomize());

      // Signal the Sequencer that the initialization is done,
      // now Driver can pick up item using .get_next_item()
      finish_item(p4adder_sequenceItem);
    end

    `uvm_info("SEQUENCE", $sformatf(
              "body(): Done generating %0d Sequence Items...", numSequenceItems), UVM_MEDIUM);
  endtask : body

endclass

