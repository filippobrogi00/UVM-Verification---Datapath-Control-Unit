// Copyright (c) 2025 Filippo Brogi. All Rights Reserved.

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
  // port (
  //     // Inputs
  //     CLK          : in    std_logic;                              // Clock
  //     nRST         : in    std_logic;                              // nRST:Active-Low
  //     DLX_PC_to_DP : in    std_logic_vector(IR_SIZE - 1 downto 0); // Used to connect PC (Program Counter) from DLX to Adder in Datapath.
  //DLX_IR_to_DP : in    std_logic_vector(IR_SIZE - 1 downto 0); // Used to connect IR (Instruction Register) from DLX to Stage 2 in Datapath.
  //
  //     // Instruction Fetch - STAGE 1
  //     IR_LATCH_EN  : in    std_logic;
  //     NPC_LATCH_EN : in    std_logic;
  //
  //     // Instruction Decode - STAGE 2
  //     RegA_LATCH_EN   : in    std_logic;
  //     SIGN_UNSIGN_EN  : in    std_logic;
  //     RegIMM_LATCH_EN : in    std_logic;
  //     JAL_EN          : in    std_logic;
  //
  //     // Additional RF inputs (STAGES 4 and 5)
  //     RF_WE             : in    std_logic;
  //     S4_REG_ADD_WR_OUT : in    std_logic_vector(log2(RF_numRegs) - 1 downto 0);
  //     S5_MUX_DATAIN_OUT : in    std_logic_vector(RF_regBits - 1 downto 0);
  //
  //     // Outputs to EX Block
  //     S2_REG_ADD_WR_OUT : out   std_logic_vector(OPERAND_SIZE - 1 downto 0); // Part of sequence of registers at Write-Address input of Register File.
  //     S2_RFILE_A_OUT    : out   std_logic_vector(IR_SIZE - 1 downto 0);      // RFILE = Register File
  //     S2_RFILE_B_OUT    : out   std_logic_vector(IR_SIZE - 1 downto 0);
  //     S2_REG_SE_IMM_OUT : out   std_logic_vector(IR_SIZE - 1 downto 0);
  //     S2_REG_UE_IMM_OUT : out   std_logic_vector(IR_SIZE - 1 downto 0);
  //
  //     // Outputs to MEMWB Block
  //     S1_ADD_OUT     : std_logic_vector(IR_SIZE - 1 downto 0) // Read as "Output of Stage 1 adder."
  //   );

  /***********
  *  INPUTS  *
  ************/
  /* General inputs */
  logic [IR_SIZE-1:0] DLX_PC_to_DP;
  logic [IR_SIZE-1:0] DLX_IR_to_DP;

  /* STAGE 1 Inputs */
  logic IR_LATCH_EN;
  logic NPC_LATCH_EN;

  /* STAGE 2 Inputs */
  logic RegA_LATCH_EN;
  logic SIGN_UNSIGN_EN;
  logic RegIMM_LATCH_EN;
  logic JAL_EN;

  /* Additional inputs from MEMWB Block */
  logic RF_WE;
  logic [$clog2(RF_NUMREGS)-1:0] S4_REG_ADD_WR_OUT;
  logic [RF_REGBITS-1:0] S5_MUX_DATAIN_OUT;

  /***********
  *  OUTPUTS *
  ************/
  /* EX Block Outputs */
  logic [OPERAND_SIZE-1:0] S2_REG_ADD_WR_OUT;
  logic [IR_SIZE-1:0] S2_RFILE_A_OUT;
  logic [IR_SIZE-1:0] S2_RFILE_B_OUT;
  logic [IR_SIZE-1:0] S2_REG_SE_IMM_OUT;
  logic [IR_SIZE-1:0] S2_REG_UE_IMM_OUT;

  /* Outputs to MEMWB Block */
  logic [IR_SIZE-1:0] S1_ADD_OUT;

  modport DUT(
      input DLX_PC_to_DP, DLX_IR_to_DP,
          IR_LATCH_EN, NPC_LATCH_EN,
          RegA_LATCH_EN, SIGN_UNSIGN_EN, RegIMM_LATCH_EN, JAL_EN,
          RF_WE, S4_REG_ADD_WR_OUT, S5_MUX_DATAIN_OUT,

      output S2_REG_ADD_WR_OUT, S2_RFILE_A_OUT, S2_RFILE_B_OUT,
      S2_REG_SE_IMM_OUT, S2_REG_UE_IMM_OUT,
      S1_ADD_OUT
  );

endinterface



