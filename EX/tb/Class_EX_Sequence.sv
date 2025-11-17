// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

/*
* SEQUENCE ITEM: Data item to which can be grouped into a Sequence
* and then sent to the Driver.
  * Also implements Constraints on data so that the Sequencer generates
  * random constrained sequences to send to the Driver.
* */

// Import bins constants
import pkg_const::*;

class Class_EXE_SequenceItem extends uvm_sequence_item;
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off bc
  `uvm_object_utils(Class_EXE_SequenceItem);
  // coverage on bc

  // Constructor
  function new(string name = "Class_EXE_SequenceItem");
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


    // Inputs from IF+ID Block
    rand logic[IR_SIZE-1 : 0] 			S1_REG_NPC_OUT; 
    rand logic 							S2_FF_JAL_EN_OUT; 
    rand logic[IR_SIZE-1 : 0] 			S2_REG_NPC_OUT; 
    rand logic[OPERAND_SIZE - 1 : 0]	S2_REG_ADD_WR_OUT;  			// Part of sequence of registers at Write-Address input of Register File.
    rand logic[IR_SIZE-1 : 0] 			S2_RFILE_A_OUT; 				// RFILE = Register File
    rand logic[IR_SIZE-1 : 0] 			S2_RFILE_B_OUT; 				// RFILE = Register File
    rand logic[IR_SIZE-1 : 0] 			S2_REG_SE_IMM_OUT;
    rand logic[IR_SIZE-1 : 0] 			S2_REG_UE_IMM_OUT;

    // Execute (STAGE 3) input control signals
    rand logic 			MUX_A_SEL;
    rand logic 			MUX_B_SEL;
    rand logic 			ALU_OUTREG_EN;
    rand logic 			EQ_COND;
    rand logic 			JMP;
    rand logic 			EQZ_NEQZ;
    rand logic[4 : 0] 	DP_ALU_OPCODE;

    // Outputs
    logic[IR_SIZE-1 : 0] 	DRAM_Addr;
    logic[IR_SIZE-1 : 0] 	DRAM_DATA;
    logic 					S3_FF_JAL_EN_OUT;		// Part of sequence of Flip-Flops which connect to the select signal of the MUX in Stage 5.
    logic[4 : 0] 			S3_REG_ADD_WR_OUT;
    logic 					S3_FF_COND_OUT; 		// Output of S3_REG_COND register
    logic[IR_SIZE-1 : 0] 	S3_REG_ALU_OUT;
    logic[IR_SIZE-1 : 0] 	S3_REG_DATA_OUT;
 	logic					S3_BranchTaken;
 	logic[IR_SIZE-1 : 0] 	S3_MUX_A_OUT;
 	logic[IR_SIZE-1 : 0] 	S3_MUX_B_OUT;
 	logic[IR_SIZE-1 : 0] 	S3_ALU_OUT;
 	logic[IR_SIZE-1 : 0] 	S3_MUX_JMP_OUT;
 	logic[IR_SIZE-1 : 0] 	S3_REG_NPC_OUT;


	// Generate constants
    localparam logic [IR_SIZE-1:0] ALL_ZERO = {IR_SIZE{1'b0}};
    localparam logic [IR_SIZE-1:0] ALL_ONES = {IR_SIZE{1'b1}};
    
	localparam logic [IR_SIZE-1:0] ALL_ZERO_2 = {OPERAND_SIZE{1'b0}};
    localparam logic [IR_SIZE-1:0] ALL_ONES_2 = {OPERAND_SIZE{1'b1}};

  	/*
  	* SEQUENCE ITEM METHODS
  	* */

  	// Converts just the input fields into strings
  	virtual function void print();
    	// coverage off b
    	`uvm_info("BLUE", $sformatf(
            {
				"---------- ITEM INFO ----------\n",
            	"/********** CONTROLS *********/\n",
				"MUX_A_SEL        	= %b		\n", 
				"MUX_B_SEL		  	= %b		\n",
				"ALU_OUTREG_EN	  	= %b		\n",
				"EQ_COND          	= %b         \n",
				"JMP              	= %b		\n",
				"DP_ALU_OPCODE    	= %b		\n",
            	"/*********** INPUTS  *********/\n",
				"S1_REG_NPC_OUT   	= %x		\n",
				"S2_FF_JAL_EN_OUT 	= %b		\n",
				"S2_REG_NPC_OUT   	= %x		\n",
				"S2_REG_ADD_WR_OUT 	= %x		\n",
				"S2_RFILE_A_OUT 	= %x		\n",
				"S2_RFILE_B_OUT 	= %x		\n",
				"S2_REG_SE_IMM_OUT 	= %x		\n",
				"S2_REG_UE_IMM_OUT 	= %x		\n",
            	"/*********** OUTPUTS *********/\n",
				"DRAM_Addr   		= %x		\n",
				"DRAM_DATA   		= %x		\n",
				"S3_FF_JAL_EN_OUT 	= %b		\n",
				"S3_REG_ADD_WR_OUT  = %x		\n",
				"S3_FF_COND_OUT 	= %b		\n",
				"S3_REG_ALU_OUT  	= %x		\n",
				"S3_REG_DATA_OUT  	= %x		\n",
				"S3_BranchTaken 	= %b		\n",
				"S3_MUX_A_OUT  		= %x		\n",
				"S3_MUX_B_OUT  		= %x		\n",
				"S3_ALU_OUT  		= %x		\n",
				"S3_MUX_JMP_OUT  	= %x		\n",
				"S3_REG_NPC_OUT  	= %x		\n",
                "-------------------------------\n"
			},
            /* CONTROL SIGNALS*/
			MUX_A_SEL,
			MUX_B_SEL,
			ALU_OUTREG_EN,
			EQ_COND,
			JMP,
			EQZ_NEQZ,
			DP_ALU_OPCODE,
			/* INPUTS */
            S1_REG_NPC_OUT,
            S2_FF_JAL_EN_OUT,
            S2_REG_NPC_OUT,
            S2_REG_ADD_WR_OUT,
            S2_RFILE_A_OUT,
            S2_RFILE_B_OUT,
            S2_REG_SE_IMM_OUT,
            S2_REG_UE_IMM_OUT,
            /* OUTPUTS */
			DRAM_Addr,
			DRAM_DATA,
			S3_FF_JAL_EN_OUT,
			S3_REG_ADD_WR_OUT,
			S3_FF_COND_OUT,
			S3_REG_ALU_OUT,
			S3_REG_DATA_OUT,
			S3_BranchTaken,
			S3_MUX_A_OUT,
			S3_MUX_B_OUT,
			S3_ALU_OUT,
			S3_MUX_JMP_OUT,
			S3_REG_NPC_OUT
            ), UVM_MEDIUM);
  endfunction

  // Copies "this" Sequence Item fields to the one passed as argument
  virtual function void copy(Class_EXE_SequenceItem targetItem);
    // Copy all fields
	/* INPUT SIGNALS */
	targetItem.S1_REG_NPC_OUT  		= this.S1_REG_NPC_OUT;
	targetItem.S2_FF_JAL_EN_OUT 	= this.S2_FF_JAL_EN_OUT;
	targetItem.S2_REG_NPC_OUT 		= this.S2_REG_NPC_OUT;
	targetItem.S2_REG_ADDR_WR_OUT 	= this.S2_REG_ADDR_WR_OUT;
	targetItem.S2_RFILE_A_OUT 		= this.S2_RFILE_A_OUT;
	targetItem.S2_RFILE_B_OUT 		= this.S2_RFILE_B_OUT;
	targetItem.S2_REG_SE_IMM_OUT 	= this.S2_REG_SE_IMM_OUT;
	targetItem.S2_REG_UE_IMM_OUT 	= this.S2_REG_UE_IMM_OUT;

	/* CONTROL SIGNALS */
	targetItem.MUX_A_SEL 			= this.MUX_A_SEL;
	targetItem.MUX_B_SEL 			= this.MUX_B_SEL;
	targetItem.ALU_OUTREG_EN 		= this.ALU_OUTREG_EN;
	targetItem.EQ_COND 				= this.EQ_COND;
	targetItem.JMP 					= this.JMP;
	targetItem.EQZ_NEQZ 			= this.EQZ_NEQZ;
	targetItem.DP_ALU_OPCODE 		= this.DP_ALU_OPCODE;

	/* OUTPUT SIGNALS */
	targetItem.DRAM_Addr 			= this.DRAM_Addr;
	targetItem.DRAM_DATA 			= this.DRAM_DATA;
	targetItem.S3_FF_JAL_EN_OUT 	= this.S3_FF_JAL_EN_OUT;
	targetItem.S3_REG_ADD_WR_OUT 	= this.S3_REG_ADD_WR_OUT;
	targetItem.S3_FF_COND_OUT 		= this.S3_FF_COND_OUT;
	targetItem.S3_REG_ALU_OUT 		= this.S3_REG_ALU_OUT;
	targetItem.S3_REG_DATA_OUT 		= this.S3_REG_DATA_OUT;
	targetItem.S3_BranchTaken 		= this.S3_BranchTaken;
	targetItem.S3_MUX_A_OUT 		= this.S3_MUX_A_OUT;
	targetItem.S3_MUX_B_OUT 		= this.S3_MUX_B_OUT;
	targetItem.S3_ALU_OUT 			= this.S3_ALU_OUT;
	targetItem.S3_MUX_JMP_OUT 		= this.S3_MUX_JMP_OUT;
	targetItem.S3_REG_NPC_OUT 		= this.S3_REG_NPC_OUT;
	
    super.copy(targetItem);  // keep base-class stuff consistent
  endfunction

  /*
  * CONSTRAINED RANDOM GENERATION
  * */
  // Ensures OPCODE field is among a valid value
  	constraint Constraint_ValidALUOpcode {
		DP_ALU_OPCODE inside {
	  		NOP,
			ADD_op,
			SUB_op,
			ADDU_op,
			SUBU_op,
			AND_op,
			OR_op,
			XOR_op,
			SLT_op,
			SLE_op,
			SGT_op,
			SGE_op,
			SEQ_op,
			SNE_op,
			SLTU_op,
			SLEU_op,
			SGTU_op,
			SGEU_op,
			SLL_op,
			SRL_op,
			SRA_op
    	};
	}

  	constraint Constraint_InputsFromIFIDBlock {
		S1_REG_NPC_OUT dist {
			ALL_ZERO := 10,
			ALL_ONES := 10,
			[ALL_ZERO + 1 : ALL_ONES - 1] := 1
		};
		S2_FF_JAL_EN_OUT dist {
			1'b0 := 1,
			1'b1 := 1
		};
		S2_REG_NPC_OUT dist {
			ALL_ZERO := 10,
			ALL_ONES := 10,
			[ALL_ZERO + 1 : ALL_ONES - 1] := 1
		};
		S2_REG_ADD_WR_OUT dist {
			ALL_ZERO_2 := 10,
			ALL_ONES_2 := 10,
			[ALL_ZERO_2 + 1 : ALL_ONES_2 - 1] := 1
		};
		S2_RFILE_A_OUT dist {
			ALL_ZERO := 10,
			ALL_ONES := 10,
			[ALL_ZERO + 1 : ALL_ONES - 1] := 1
		};
		S2_RFILE_B_OUT dist {
			ALL_ZERO := 10,
			ALL_ONES := 10,
			[ALL_ZERO + 1 : ALL_ONES - 1] := 1
		};
		S2_REG_SE_IMM_OUT dist {
			ALL_ZERO := 10,
			ALL_ONES := 10,
			[ALL_ZERO + 1 : ALL_ONES - 1] := 1
		};
		S2_REG_UE_IMM_OUT dist {
			ALL_ZERO := 10,
			ALL_ONES := 10,
			[ALL_ZERO + 1 : ALL_ONES - 1] := 1
		};
  	}

	
  	constraint Constraint_InputsFromIFIDBlock {
		MUX_A_SEL dist {
			1'b0 := 1,
			1'b1 := 1		
		};
		MUX_B_SEL dist {
			1'b0 := 1,
			1'b1 := 1		
		};
		ALU_OUTREG_EN dist {
			1'b0 := 1,
			1'b1 := 1		
		};
		EQ_COND dist {
			1'b0 := 1,
			1'b1 := 1		
		};
		JMP dist {
			1'b0 := 1,
			1'b1 := 1		
		};
		EQZ_NEQZ dist {
			1'b0 := 1,
			1'b1 := 1		
		};
	}

endclass


/*
* SEQUENCE: Collection of many data items which can be combined to
* create various test scenarios.
* */
class Class_EXE_Sequence extends uvm_sequence #(Class_EXE_SequenceItem);
  // Register to factory (doens't extend uvm_component -> use uvm_object_utils)
  // coverage off bc
  `uvm_object_utils(Class_EXE_Sequence)
  // coverage on bc

  /*
  * SEQUENCE CLASS MEMBERS
  * */
  int unsigned numSequenceItems = 10;

  // Constructor
  function new(string name = "Class_EXE_Sequence");
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
      Class_EXE_SequenceItem exe_sequenceItem = Class_EXE_SequenceItem::type_id::create(
          "exe_sequenceItem"
      );

      // Reserve Sequencer slot for current item
      start_item(exe_sequenceItem);

      // Randomize the item to let the Sequencer "execute"
      assert (exe_sequenceItem.randomize());

      // Signal the Sequencer that the initialization is done,
      // now Driver can pick up item using .get_next_item()
      finish_item(exe_sequenceItem);
    end

    // coverage off b
    `uvm_info("SEQUENCE", $sformatf(
              "body(): Done generating %0d Sequence Items...", numSequenceItems), UVM_MEDIUM);
    // coverage on b
  endtask : body

endclass

