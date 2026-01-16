// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

// Standard UVM packages for UVM macros and functions
`include "uvm_macros.svh"
import uvm_pkg::*;

// Package includes
import pkg_const::*;


// Function to convert aluOp enum value to string
function string aluOp_to_string(input int op_value);
    // coverage off
    case (op_value)
        0:  return "NOP";
        1:  return "ADD_op";
        3:  return "AND_op";
        4:  return "OR_op";
        5:  return "SGE_op";
        6:  return "SLE_op";
        7:  return "SLL_op";
        8:  return "SNE_op";
        9:  return "SRL_op";
        10: return "SUB_op";
        11: return "XOR_op";
        12: return "SRA_op";
        13: return "ADDU_op";
        14: return "SUBU_op";
        15: return "SEQ_op";
        16: return "SLT_op";
        17: return "SGT_op";
        18: return "SLTU_op";
        19: return "SGTU_op";
        20: return "SLEU_op";
        21: return "SGEU_op";
        default: return $sformatf("UNKNOWN_OP(%0d)", op_value);
    endcase
    // coverage on
endfunction


/*
* SCOREBOARD :
  * Checks functionality of DUT
  * Receives Transaction-Level Objects via Analysis Port
  * Also implements Assertions so that it can compare the received
  * data items from the Monitor with the "golden model".
* */

class Class_EXE_Scoreboard extends uvm_scoreboard;
	// Register to Factory
  // coverage off
	`uvm_component_utils(Class_EXE_Scoreboard)
  // coverage on
	
	/* Scoreboard class variables */
	int error;
	`ifdef FAULT_INJECTION_CAMPAIGN
		string injected_fault;
		int injected_value;
	`endif // FAULT_INJECTION_CAMPAIGN
	
	// Constructor
	function new(string name = "Class_EXE_Scoreboard", uvm_component parent = null);
		super.new(name, parent);
		error = 0;
		
		`ifdef FAULT_INJECTION_CAMPAIGN
			// Get current fault line and injected value from UVM DB variables set by top level 
			uvm_config_db#(string)::get(null, "", "current_fault", injected_fault);
			uvm_config_db#(int)::get(null, "", "current_inj_value", injected_value);
		`endif // FAULT_INJECTION_CAMPAIGN
  endfunction

	// Analysis Port to receive data objects from other TB components
	uvm_analysis_imp #(Class_EXE_SequenceItem, Class_EXE_Scoreboard) analysis_port_imp;

	/*
	* BUILD PHASE: Create instance of Analysis Port
	* */
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		// Instance the Analysis Port
		analysis_port_imp = new("analysis_port_imp", this);
	endfunction : build_phase


	/*
	* WRITE FUNCTION :
    * Monitor sends via Analysis Port a complete transaction to the Scoreboard
    * Here we re-compute the Expected Result and check it against DUTs'
	* */
	virtual function void write(Class_EXE_SequenceItem exe_seqitem);

		/****************************************
		* Expected Result variables declaration *
		*****************************************/
		/* EX Block Outputs */
		/* Outputs */
		//		logic[IR_SIZE-1 : 0] 	Expected_DRAM_Addr;
		//		logic[IR_SIZE-1 : 0] 	Expected_DRAM_DATA;
		// coverage off
		logic 					Expected_S3_FF_JAL_EN_OUT;
		logic[4 : 0] 			Expected_S3_REG_ADD_WR_OUT;
		logic 					Expected_S3_FF_COND_OUT;
		logic[IR_SIZE-1 : 0] 	Expected_S3_REG_ALU_OUT;
		logic[IR_SIZE-1 : 0] 	Expected_S3_REG_DATA_OUT;
		logic[IR_SIZE-1 : 0] 	Expected_S3_REG_NPC_OUT;

		/*************************************************
		* Calculate expected results (Golden Model) *
		**************************************************/

		/*********** Variables ***********/

		// Intermediate variable
		logic 					BranchTaken;
		logic [IR_SIZE-1 : 0] 	S3_MUX_A_OUT;
		logic [IR_SIZE-1 : 0] 	S3_MUX_B_OUT;
		logic [IR_SIZE-1 : 0] 	S3_ALU_OUT;
		logic [IR_SIZE-1 : 0] 	S3_MUX_JMP_OUT;

		// Shifter variable
		logic LOGIC_ARITH	= 0;
		logic LEFT_RIGHT	= 0;
		logic SHIFT_ROTATE	= 0;
		logic [IR_SIZE-1 : 0] 	Shifter_Result;
		logic [4 : 0]		Shift_amount;

		// Register variable
		static logic [IR_SIZE-1 : 0] 	prev_S3_REG_ALU_OUT;
		static logic [IR_SIZE-1 : 0] 	prev_S3_REG_DATA_OUT;
		static logic 			prev_S3_FF_COND_OUT;
		static logic 			prev_S3_FF_JAL_EN_OUT;
		static logic [IR_SIZE-1 : 0] 	prev_S3_REG_NPC_OUT;
		static logic [4 : 0] 		prev_S3_REG_ADD_WR_OUT;

		static logic [IR_SIZE-1 : 0] 	syn_prev_S3_REG_ALU_OUT;
		static logic [IR_SIZE-1 : 0] 	syn_prev_S3_REG_DATA_OUT;
		static logic 			syn_prev_S3_FF_COND_OUT;
		static logic 			syn_prev_S3_FF_JAL_EN_OUT;
		static logic [IR_SIZE-1 : 0] 	syn_prev_S3_REG_NPC_OUT;
		static logic [4 : 0] 		syn_prev_S3_REG_ADD_WR_OUT;

		/******** Mimicking logic ********/

		// When fault simulating, we use post-synthesis netlist. 
		// Since an extra delay is inserted, we need to update mimicking behavior. 
		`ifdef FAULT_INJECTION_CAMPAIGN
			
			// -------- Mimick register behavior (post-synthesis netlist) --------
			if (exe_seqitem.nRST == 1) begin
				Expected_S3_REG_ALU_OUT 	= syn_prev_S3_REG_ALU_OUT;
				Expected_S3_REG_DATA_OUT 	= syn_prev_S3_REG_DATA_OUT;
				Expected_S3_FF_COND_OUT 	= syn_prev_S3_FF_COND_OUT;
				Expected_S3_FF_JAL_EN_OUT 	= syn_prev_S3_FF_JAL_EN_OUT;
				Expected_S3_REG_NPC_OUT 	= syn_prev_S3_REG_NPC_OUT;
				Expected_S3_REG_ADD_WR_OUT 	= syn_prev_S3_REG_ADD_WR_OUT;
			end else begin
				Expected_S3_REG_ALU_OUT 	= 0;
				Expected_S3_REG_DATA_OUT 	= 0;
				Expected_S3_FF_COND_OUT 	= 0;
				Expected_S3_FF_JAL_EN_OUT 	= 0;
				Expected_S3_REG_NPC_OUT 	= 0;
				Expected_S3_REG_ADD_WR_OUT 	= 0;
			end
			syn_prev_S3_REG_ALU_OUT 	= prev_S3_REG_ALU_OUT;
			syn_prev_S3_REG_DATA_OUT 	= prev_S3_REG_DATA_OUT;
			syn_prev_S3_FF_COND_OUT 	= prev_S3_FF_COND_OUT;
			syn_prev_S3_FF_JAL_EN_OUT 	= prev_S3_FF_JAL_EN_OUT;
			syn_prev_S3_REG_NPC_OUT 	= prev_S3_REG_NPC_OUT;
			syn_prev_S3_REG_ADD_WR_OUT 	= prev_S3_REG_ADD_WR_OUT;

		`else 

			// -------- Mimick register behavior (RTL netlist) --------
			if (exe_seqitem.nRST == 1) begin
				Expected_S3_REG_ALU_OUT		= prev_S3_REG_ALU_OUT;
				Expected_S3_REG_DATA_OUT	= prev_S3_REG_DATA_OUT;
				Expected_S3_FF_COND_OUT		= prev_S3_FF_COND_OUT;
				Expected_S3_FF_JAL_EN_OUT	= prev_S3_FF_JAL_EN_OUT;
				Expected_S3_REG_NPC_OUT		= prev_S3_REG_NPC_OUT;
				Expected_S3_REG_ADD_WR_OUT	= prev_S3_REG_ADD_WR_OUT;
			end else begin
				Expected_S3_REG_ALU_OUT 	= 0;
				Expected_S3_REG_DATA_OUT 	= 0;
				Expected_S3_FF_COND_OUT 	= 0;
				Expected_S3_FF_JAL_EN_OUT 	= 0;
				Expected_S3_REG_NPC_OUT 	= 0;
				Expected_S3_REG_ADD_WR_OUT 	= 0;
			end

		`endif // FAULT_INJECTION_CAMPAIGN


    // ---------- Mimick mux behavior -----------
		S3_MUX_JMP_OUT	= (exe_seqitem.JMP == 1) ? exe_seqitem.S2_REG_UE_IMM_OUT : exe_seqitem.S2_REG_SE_IMM_OUT;
		S3_MUX_A_OUT 	= (exe_seqitem.MUX_A_SEL == 1) ? exe_seqitem.S2_RFILE_A_OUT : exe_seqitem.S1_REG_NPC_OUT;
		S3_MUX_B_OUT 	= (exe_seqitem.MUX_B_SEL == 1) ? S3_MUX_JMP_OUT : exe_seqitem.S2_RFILE_B_OUT;

		// --------- Mimick Shifter behavior --------
		// Shifter instruction decoding
		if(exe_seqitem.DP_ALU_OPCODE == SLL_op) begin
			LOGIC_ARITH 	= 1;
			LEFT_RIGHT		= 1;
			SHIFT_ROTATE	= 1;
		end
		else if(exe_seqitem.DP_ALU_OPCODE == SRL_op) begin
			LOGIC_ARITH 	= 1;
			LEFT_RIGHT		= 0;
			SHIFT_ROTATE	= 1;
		end
		else if(exe_seqitem.DP_ALU_OPCODE == SRA_op) begin
			LOGIC_ARITH 	= 0;
			LEFT_RIGHT		= 0;
			SHIFT_ROTATE	= 1;
		end

		Shift_amount = S3_MUX_B_OUT[4:0];

		if ( SHIFT_ROTATE == 0 ) begin
			// ROTATE
			if ( LEFT_RIGHT == 0) begin
				// RIGHT
				Shifter_Result = (S3_MUX_A_OUT >> Shift_amount) | (S3_MUX_A_OUT << (IR_SIZE-Shift_amount));
			end
			else begin
				// LEFT
				Shifter_Result = (S3_MUX_A_OUT << Shift_amount) | (S3_MUX_A_OUT >> (IR_SIZE-Shift_amount));
			end
		end
		else begin
			// SHIFT
			if ( LEFT_RIGHT == 0) begin
				// RIGHT
				if ( LOGIC_ARITH == 0 ) begin
					// ARITH
					Shifter_Result = $signed(S3_MUX_A_OUT) >>> Shift_amount;
				end
				else begin
					// LOGIC
					Shifter_Result = S3_MUX_A_OUT >> Shift_amount;
				end
			end
			else begin
				// LEFT
				if ( LOGIC_ARITH == 0 ) begin
					// ARITH
					Shifter_Result = $signed(S3_MUX_A_OUT) <<< Shift_amount;
				end
				else begin
					// LOGIC
					Shifter_Result = S3_MUX_A_OUT << Shift_amount;
				end
			end

		end

		// ----------- Mimick ALU behavior ----------
		if (exe_seqitem.DP_ALU_OPCODE == SLL_op)
			S3_ALU_OUT = Shifter_Result;
		else if (exe_seqitem.DP_ALU_OPCODE == SRL_op)
			S3_ALU_OUT = Shifter_Result;
		else if (exe_seqitem.DP_ALU_OPCODE == SRA_op)
			S3_ALU_OUT = Shifter_Result;
		else if (exe_seqitem.DP_ALU_OPCODE == ADD_op)
			S3_ALU_OUT = S3_MUX_A_OUT + S3_MUX_B_OUT;
		else if(exe_seqitem.DP_ALU_OPCODE == SUB_op)
			S3_ALU_OUT = S3_MUX_A_OUT - S3_MUX_B_OUT;
		else if (exe_seqitem.DP_ALU_OPCODE == ADDU_op)
			S3_ALU_OUT = S3_MUX_A_OUT + S3_MUX_B_OUT;
		else if(exe_seqitem.DP_ALU_OPCODE == SUBU_op)
			S3_ALU_OUT = S3_MUX_A_OUT - S3_MUX_B_OUT;
		else if(exe_seqitem.DP_ALU_OPCODE == AND_op)
			S3_ALU_OUT = S3_MUX_A_OUT & S3_MUX_B_OUT;
		else if(exe_seqitem.DP_ALU_OPCODE == OR_op)
			S3_ALU_OUT = S3_MUX_A_OUT | S3_MUX_B_OUT;
		else if(exe_seqitem.DP_ALU_OPCODE == XOR_op)
			S3_ALU_OUT = S3_MUX_A_OUT ^ S3_MUX_B_OUT;
		else if(exe_seqitem.DP_ALU_OPCODE == SLT_op)
			S3_ALU_OUT = ($signed(S3_MUX_A_OUT) < $signed(S3_MUX_B_OUT)) ? 1 : 0;
		else if(exe_seqitem.DP_ALU_OPCODE == SLE_op)
			S3_ALU_OUT = ($signed(S3_MUX_A_OUT) <= $signed(S3_MUX_B_OUT)) ? 1 : 0;
		else if(exe_seqitem.DP_ALU_OPCODE == SGT_op)
			S3_ALU_OUT = ($signed(S3_MUX_A_OUT) > $signed(S3_MUX_B_OUT)) ? 1 : 0;
		else if(exe_seqitem.DP_ALU_OPCODE == SGE_op)
			S3_ALU_OUT = ($signed(S3_MUX_A_OUT) >= $signed(S3_MUX_B_OUT)) ? 1 : 0;
		else if(exe_seqitem.DP_ALU_OPCODE == SEQ_op)
			S3_ALU_OUT = ($signed(S3_MUX_A_OUT) == $signed(S3_MUX_B_OUT)) ? 1 : 0;
		else if(exe_seqitem.DP_ALU_OPCODE == SNE_op)
			S3_ALU_OUT = ($signed(S3_MUX_A_OUT) != $signed(S3_MUX_B_OUT)) ? 1 : 0;
		else if(exe_seqitem.DP_ALU_OPCODE == SLTU_op)
			S3_ALU_OUT = (S3_MUX_A_OUT < S3_MUX_B_OUT) ? 1 : 0;
		else if(exe_seqitem.DP_ALU_OPCODE == SLEU_op)
			S3_ALU_OUT = (S3_MUX_A_OUT <= S3_MUX_B_OUT) ? 1 : 0;
		else if(exe_seqitem.DP_ALU_OPCODE == SGTU_op)
			S3_ALU_OUT = (S3_MUX_A_OUT > S3_MUX_B_OUT) ? 1 : 0;
		else if(exe_seqitem.DP_ALU_OPCODE == SGEU_op)
			S3_ALU_OUT = (S3_MUX_A_OUT >= S3_MUX_B_OUT) ? 1 : 0;
		else
			S3_ALU_OUT = {IR_SIZE{1'bz}};

		//  ----------- Mimick Comparator -----------
		if (exe_seqitem.JMP == 1)
			BranchTaken = 1;
		else if ((exe_seqitem.S2_RFILE_A_OUT == 0 && exe_seqitem.EQZ_NEQZ == 1))
			BranchTaken = 1;
		else if ((exe_seqitem.S2_RFILE_A_OUT != 0 && exe_seqitem.EQZ_NEQZ == 0))
			BranchTaken = 1;
		else
			BranchTaken = 0;

		// --- Storing computation for next cycle ---
		if (exe_seqitem.ALU_OUTREG_EN == 1)
			prev_S3_REG_ALU_OUT = S3_ALU_OUT;
		prev_S3_REG_DATA_OUT = exe_seqitem.S2_RFILE_B_OUT;

		if (exe_seqitem.EQ_COND == 1)
			prev_S3_FF_COND_OUT	= BranchTaken;

		prev_S3_FF_JAL_EN_OUT 	= exe_seqitem.S2_FF_JAL_EN_OUT;
		prev_S3_REG_NPC_OUT		= exe_seqitem.S2_REG_NPC_OUT;
		prev_S3_REG_ADD_WR_OUT 	= exe_seqitem.S2_REG_ADD_WR_OUT;
		// coverage on

	  /*************************************************
		* Compare Expected vs DUT (compare NBITS fields) *
		**************************************************/

		exe_seqitem.print();

		// Initialize "detected" UVM shared variable to 0 
		// `ifdef FAULT_INJECTION_CAMPAIGN
		// 	uvm_config_db#(int)::set(null, "", "detected", 0);
		// `endif // FAULT_INJECTION_CAMPAIGN

		assert (Expected_S3_FF_JAL_EN_OUT ==? exe_seqitem.S3_FF_JAL_EN_OUT) begin
			// coverage off b
			`uvm_info("GREEN", "JAL_EN OK!", UVM_MEDIUM);

			`ifdef FAULT_INJECTION_CAMPAIGN
				save_current_fault_to_file(injected_fault, injected_value, 0);
			`endif // FAULT_INJECTION_CAMPAIGN
			
			// coverage on b
		end
		else begin
		  // coverage off b
			error++;
			`uvm_info("RED", $sformatf(
				"JAL_EN mismatch: expected 0x%0h, got 0x%0h",
				Expected_S3_FF_JAL_EN_OUT,
				exe_seqitem.S3_FF_JAL_EN_OUT
				), UVM_MEDIUM); 

			`ifdef FAULT_INJECTION_CAMPAIGN
				// Stop fault simulation on error throwing UVM_ERROR
				`uvm_error("SCOREBOARD", "[SCOREBOARD] ========== FAULT SIMULATION ENDED ==========");
				save_current_fault_to_file(injected_fault, injected_value, 1);
			`endif // FAULT_INJECTION_CAMPAIGN

			// coverage on b
		end

		assert (Expected_S3_REG_ADD_WR_OUT ==? exe_seqitem.S3_REG_ADD_WR_OUT) begin
			// coverage off b
			`uvm_info("GREEN", "ADD_WR OK!", UVM_MEDIUM);

			`ifdef FAULT_INJECTION_CAMPAIGN
				save_current_fault_to_file(injected_fault, injected_value, 0);
			`endif // FAULT_INJECTION_CAMPAIGN
			
			// coverage on b
		end
		else begin
		  // coverage off b
			error++;
			`uvm_info("RED", $sformatf(
				"ADD_WR mismatch: expected 0x%0h, got 0x%0h",
				Expected_S3_REG_ADD_WR_OUT,
				exe_seqitem.S3_REG_ADD_WR_OUT
				), UVM_MEDIUM); 

			`ifdef FAULT_INJECTION_CAMPAIGN
				// Stop fault simulation on error throwing UVM_ERROR
				`uvm_error("SCOREBOARD", "[SCOREBOARD] ========== FAULT SIMULATION ENDED ==========");
				save_current_fault_to_file(injected_fault, injected_value, 1);
			`endif // FAULT_INJECTION_CAMPAIGN

			// coverage on b
		end

		assert (Expected_S3_FF_COND_OUT ==? exe_seqitem.S3_FF_COND_OUT) begin
			// coverage off b
			`uvm_info("GREEN", "COND OK!", UVM_MEDIUM);

			`ifdef FAULT_INJECTION_CAMPAIGN
				save_current_fault_to_file(injected_fault, injected_value, 0);
			`endif // FAULT_INJECTION_CAMPAIGN

			// coverage on b
		end
		else begin
		  // coverage off b
			error++;
			`uvm_info("RED", $sformatf(
				"COND mismatch: JMP: %b, EQZ_NEQZ: %b, RFILE_A: 0x%0h, expected 0x%0h, got 0x%0h",
				exe_seqitem.JMP,
				exe_seqitem.EQZ_NEQZ,
				exe_seqitem.S2_RFILE_A_OUT, 
				Expected_S3_FF_COND_OUT,
				exe_seqitem.S3_FF_COND_OUT
				), UVM_MEDIUM);

			`ifdef FAULT_INJECTION_CAMPAIGN
				// Stop fault simulation on error throwing UVM_ERROR
				`uvm_error("SCOREBOARD", "[SCOREBOARD] ========== FAULT SIMULATION ENDED ==========");
				save_current_fault_to_file(injected_fault, injected_value, 1);
			`endif // FAULT_INJECTION_CAMPAIGN

			// coverage on b
		end

		assert (Expected_S3_REG_ALU_OUT ==? exe_seqitem.S3_REG_ALU_OUT) begin
			// coverage off b
			`uvm_info("GREEN", "ALU OK!", UVM_MEDIUM);

			`ifdef FAULT_INJECTION_CAMPAIGN
				save_current_fault_to_file(injected_fault, injected_value, 0);
			`endif // FAULT_INJECTION_CAMPAIGN

			// coverage on b
		end
		else begin
		  // coverage off b
			error++;
			`uvm_info("RED", $sformatf(
				"ALU mismatch: OP: %s, MUX_A: 0x%0h, MUX_B: 0x%0h expected 0x%0h, got 0x%0h",
				aluOp_to_string(exe_seqitem.DP_ALU_OPCODE),
				S3_MUX_A_OUT,
				S3_MUX_B_OUT, 
				Expected_S3_REG_ALU_OUT,
				exe_seqitem.S3_REG_ALU_OUT
				), UVM_MEDIUM);

			`ifdef FAULT_INJECTION_CAMPAIGN
				// Stop fault simulation on error throwing UVM_ERROR
				`uvm_error("SCOREBOARD", "[SCOREBOARD] ========== FAULT SIMULATION ENDED ==========");
				save_current_fault_to_file(injected_fault, injected_value, 1);
			`endif // FAULT_INJECTION_CAMPAIGN

			// coverage on b
		end

		assert (Expected_S3_REG_DATA_OUT ==? exe_seqitem.S3_REG_DATA_OUT) begin
			// coverage off b
			`uvm_info("GREEN", "DATA OK!", UVM_MEDIUM);

			`ifdef FAULT_INJECTION_CAMPAIGN
				save_current_fault_to_file(injected_fault, injected_value, 0);
			`endif // FAULT_INJECTION_CAMPAIGN
			
			// coverage on b
		end
		else begin
		  // coverage off b
			error++;
			`uvm_info("RED", $sformatf(
				"DATA mismatch: expected 0x%0h, got 0x%0h",
				Expected_S3_REG_DATA_OUT,
				exe_seqitem.S3_REG_DATA_OUT
				), UVM_MEDIUM); 

			`ifdef FAULT_INJECTION_CAMPAIGN
				// Stop fault simulation on error throwing UVM_ERROR
				`uvm_error("SCOREBOARD", "[SCOREBOARD] ========== FAULT SIMULATION ENDED ==========");
				save_current_fault_to_file(injected_fault, injected_value, 1);
			`endif // FAULT_INJECTION_CAMPAIGN

			// coverage on b
	end

		assert (Expected_S3_REG_NPC_OUT ==? exe_seqitem.S3_REG_NPC_OUT) begin
			// coverage off b
			`uvm_info("GREEN", "PC OK!", UVM_MEDIUM);
			`ifdef FAULT_INJECTION_CAMPAIGN
				save_current_fault_to_file(injected_fault, injected_value, 0);
			`endif // FAULT_INJECTION_CAMPAIGN
			// coverage on b
		end
		else begin
		  // coverage off b
			error++;
			`uvm_info("RED", $sformatf(
				"PC mismatch: expected 0x%0h, got 0x%0h",
				Expected_S3_REG_NPC_OUT,
				exe_seqitem.S3_REG_NPC_OUT
				), UVM_MEDIUM); 

		`ifdef FAULT_INJECTION_CAMPAIGN
			// Stop fault simulation on error throwing UVM_ERROR
			`uvm_error("SCOREBOARD", "[SCOREBOARD] ========== FAULT SIMULATION ENDED ==========");
			save_current_fault_to_file(injected_fault, injected_value, 1);
		`endif // FAULT_INJECTION_CAMPAIGN
		// coverage on b
	end

	endfunction : write

	virtual function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		if(error > 0) begin
			// coverage off b
			`uvm_info("RED", $sformatf(
				"Found %d errors",
				error
				), UVM_MEDIUM);
	    // coverage on b
		end
		else begin
			`uvm_info("GREEN", "No error found", UVM_MEDIUM);
		end
	endfunction

endclass



