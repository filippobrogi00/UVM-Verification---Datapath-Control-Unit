// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

// DUT Interface
interface Iface_IFID #(
    parameter IR_SIZE = 32,
    parameter OPERAND_SIZE = 5,
    parameter I_TYPE_IMM_SIZE = 16,
    parameter J_TYPE_IMM_SIZE = 26,
    parameter RF_REGBITS = 32,
    parameter RF_NUMREGS = 32
) (
    input logic CLK,
    input logic nRST  // active low
);
// 	port (
//    	-- Inputs
//   	CLK  : in    std_logic; -- Clock
//  	nRST : in    std_logic; -- nRST:Active-Low
//
//   	-- Inputs from IF+ID Block
//	  	S1_REG_NPC_OUT    : in    std_logic_vector(IR_SIZE - 1 downto  0);
//	  	S2_FF_JAL_EN_OUT  : in    std_logic;
//	  	S2_REG_NPC_OUT    : in    std_logic_vector(IR_SIZE - 1 downto 0);
//	  	S2_REG_ADD_WR_OUT : in    std_logic_vector(OPERAND_SIZE - 1 downto 0); -- Part of sequence of registers at Write-Address input of Register File.
//	  	S2_RFILE_A_OUT    : in    std_logic_vector(IR_SIZE - 1 downto 0);      -- RFILE = Register File
//	  	S2_RFILE_B_OUT    : in    std_logic_vector(IR_SIZE - 1 downto 0);
//	  	S2_REG_SE_IMM_OUT : in    std_logic_vector(IR_SIZE - 1 downto 0);
//	 	 	S2_REG_UE_IMM_OUT : in    std_logic_vector(IR_SIZE - 1 downto 0);
//
//	  	-- Execute (STAGE 3) input signals
//	  	MUX_A_SEL     : in    std_logic;
//	  	MUX_B_SEL     : in    std_logic;
//	  	ALU_OUTREG_EN : in    std_logic;
//	  	EQ_COND       : in    std_logic;
//	  	JMP           : in    std_logic;
//	  	EQZ_NEQZ      : in    std_logic;
//   	DP_ALU_OPCODE : in    aluOp;
//	
//	    -- Outputs
//	    DRAM_Addr : out   std_logic_vector(IR_SIZE - 1 downto 0);
//	    DRAM_DATA : out   std_logic_vector(IR_SIZE - 1 downto 0);
//	
//	    -- Outputs to MEM+WB Block
//	    S3_FF_JAL_EN_OUT  : out   	std_logic; -- Part of sequence of Flip-Flops which connect to the select signal of the MUX in Stage 5.
//    	S3_REG_ADD_WR_OUT : out   	std_logic_vector(4 downto 0);
//    	S3_FF_COND_OUT    : out   	std_logic; -- Output of S3_REG_COND register
//    	S3_REG_ALU_OUT    : out   	std_logic_vector(IR_SIZE - 1 downto 0);
//    	S3_REG_DATA_OUT   : out   	std_logic_vector(IR_SIZE - 1 downto 0);  
// 		S3_BranchTaken    : out 	std_logic;
// 		S3_MUX_A_OUT      : out 	std_logic_vector(IR_SIZE - 1 downto 0);
// 		S3_MUX_B_OUT      : out 	std_logic_vector(IR_SIZE - 1 downto 0);
// 		S3_ALU_OUT        : out 	std_logic_vector(IR_SIZE - 1 downto 0);
// 		S3_MUX_JMP_OUT    : out 	std_logic_vector(IR_SIZE - 1 downto 0);
//		S3_REG_NPC_OUT    : out		std_logic_vector(IR_SIZE - 1 downto 0)
// 	 );


  	/***********
  	*  INPUTS  *
  	************/
    // Inputs from IF+ID Block
    logic[IR_SIZE-1 : 0] 			S1_REG_NPC_OUT; 
    logic 							S2_FF_JAL_EN_OUT; 
    logic[IR_SIZE-1 : 0] 			S2_REG_NPC_OUT; 
    logic[OPERAND_SIZE - 1 : 0]	S2_REG_ADD_WR_OUT;  			// Part of sequence of registers at Write-Address input of Register File.
    logic[IR_SIZE-1 : 0] 			S2_RFILE_A_OUT; 				// RFILE = Register File
    logic[IR_SIZE-1 : 0] 			S2_RFILE_B_OUT; 				// RFILE = Register File
    logic[IR_SIZE-1 : 0] 			S2_REG_SE_IMM_OUT;
    logic[IR_SIZE-1 : 0] 			S2_REG_UE_IMM_OUT;	

	/***********
  	* CONTROLS *
  	************/
    // Execute (STAGE 3) input control signals
    logic 			MUX_A_SEL;
    logic 			MUX_B_SEL;
    logic 			ALU_OUTREG_EN;
    logic 			EQ_COND;
    logic 			JMP;
    logic 			EQZ_NEQZ;
    logic[4 : 0] 	DP_ALU_OPCODE;

	/***********
  	*  OUTPUTS *
  	************/
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

  	/************
  	*  MODPORTS *
	*************/
	// verilog_format: off
  	modport DUT(
      	input CLK, nRST,
        // Testbench inputs as seen by DUT
		S1_REG_NPC_OUT, S2_FF_JAL_EN_OUT, S2_REG_NPC_OUT, S2_REG_ADD_WR_OUT, S2_RFILE_A_OUT, S2_RFILE_B_OUT,
		S2_REG_SE_IMM_OUT, S2_REG_UE_IMM_OUT,
		MUX_A_SEL, MUX_B_SEL, ALU_OUTREG_EN, EQ_COND, JMP, EQZ_NEQZ, DP_ALU_OPCODE,
			
      	// Testbench outputs as seen by DUT
      	output DRAM_Addr, DRAM_DATA,
		S3_FF_JAL_EN_OUT, S3_REG_ADD_WR_OUT, S3_FF_COND_OUT, S3_REG_ALU_OUT, S3_REG_DATA_OUT,
		S3_BranchTaken, S3_MUX_A_OUT, S3_MUX_B_OUT, S3_ALU_OUT, S3_MUX_JMP_OUT, S3_REG_NPC_OUT
  	);
  // verilog_format: on

  // Clocking block for timing synchronization
  clocking ClockingBlock_EXE @(posedge CLK);
  	// TODO to adapt to EXE
    /* (TB) INPUTS: TB <- DUT */
    // NOTE: TB's result (CW) signals are sampled at (posedge clk + CLKPERIOD/4)
    input #(1) S2_REG_ADD_WR_OUT, S2_RFILE_A_OUT, S2_RFILE_B_OUT, S2_REG_SE_IMM_OUT,
      S2_REG_UE_IMM_OUT, S1_ADD_OUT;


    /* (TB) OUTPUTS: TB -> DUT */
    // NOTE: Drive DUT's inputs at (posedge clk - CLKPERIOD/4)
    output #(-1) DLX_PC_to_DP, DLX_IR_to_DP, IR_LATCH_EN,
      NPC_LATCH_EN, RegA_LATCH_EN, SIGN_UNSIGN_EN,
      RegIMM_LATCH_EN, JAL_EN, RF_WE,
      S4_REG_ADD_WR_OUT, S5_MUX_DATAIN_OUT;
  endclocking

endinterface



