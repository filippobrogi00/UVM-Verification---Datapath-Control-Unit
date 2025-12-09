// Copyright (c) 2025 Filippo Brogi, Giuseppe Maganuco, Mateus Ferreira. All Rights Reserved.

// DUT Interface
interface Iface_CU #(
    parameter MICROCODE_MEM_SIZE = 44, // Microcode Memory Size. Included all Instructions DLX will be able to execute and not.
    parameter FUNC_SIZE = 11,  // Func Field Size for R-Type Ops
    parameter OP_CODE_SIZE = 6,  // Op Code Size
    parameter IR_SIZE = 32,  // Instruction Register Size
    parameter CW_SIZE = 18  // Control Word Size. Added new Control Signals.
) (
    input logic Clk,
    input logic nRst  // active low
);
  // port (
  //   Clk  : in    std_logic; -- Clock
  //   nRst : in    std_logic; -- Reset:Active-Low
  //
  //   -- Instruction Register
  //   IR_IN : in    std_logic_vector(IR_SIZE - 1 downto 0);
  //
  //   -- Debug Signals
  //   DBG_CW_OUT : OUT   std_logic_vector(CW_SIZE - 1 downto 0);
  //
  //   -- IF Control Signal - STAGE 1
  //   IR_LATCH_EN  : out   std_logic; -- Instruction Register Latch Enable
  //   NPC_LATCH_EN : out   std_logic; -- NextProgramCounter Register Latch Enable
  //
  //   -- ID Control Signals - STAGE 2
  //   RegA_LATCH_EN   : out   std_logic; -- Register A Latch Enable
  //   RegB_LATCH_EN   : out   std_logic; -- Register B Latch Enable
  //   RegIMM_LATCH_EN : out   std_logic; -- Immediate Register Latch Enable
  //   JAL_EN          : out   std_logic; -- Control Signal for Jump and Link Instruction
  //
  //   -- EX Control Signals - STAGE 3
  //   MUXA_SEL      : out   std_logic; -- MUX-A Sel
  //   MUXB_SEL      : out   std_logic; -- MUX-B Sel
  //   ALU_OUTREG_EN : out   std_logic; -- ALU Output Register Enable
  //   EQ_COND       : out   std_logic; -- Branch if (not) Equal to Zero
  //   JMP           : out   std_logic; -- Control Signal for unconditional Jump Instructions.
  //   EQZ_NEQZ      : out   std_logic; -- Control Signal for bnez Instruction ('0') and beqz Instruction ('1').
  //
  //   -- ALU Operation Code
  //   ALU_OPCODE : out   aluOp; -- choose between implicit or exlicit coding, like std_logic_vector(ALU_OPC_SIZE -1 downto 0);
  //
  //   -- MEM Control Signals - STAGE 4
  //   DRAM_WE      : out   std_logic; -- Data RAM Write Enable
  //   LMD_LATCH_EN : out   std_logic; -- LMD Register Latch Enable
  //   JUMP_EN      : out   std_logic; -- JUMP Enable Signal for PC input MUX
  //   PC_LATCH_EN  : out   std_logic; -- Program Counte Latch Enable
  //
  //   -- WB Control signals - STAGE 5
  //   WB_MUX_SEL : out   std_logic; -- Write Back MUX Sel
  //   RF_WE      : out   std_logic  -- Register File Write Enable
  // );

  /***********
  *  INPUTS  *
  ************/
  /* General inputs */
  logic [IR_SIZE-1:0] IR_IN;  // Instruction Register

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



  /************
  *  MODPORTS *
  *************/
  modport DUT(
      input Clk, nRst,
      // Testbench inputs as seen by DUT
      IR_IN,

      // Testbench outputs as seen by DUT
      output  IR_LATCH_EN, NPC_LATCH_EN,
        RegA_LATCH_EN, RegB_LATCH_EN, RegIMM_LATCH_EN, JAL_EN,
        MUXA_SEL, MUXB_SEL, ALU_OUTREG_EN, EQ_COND, JMP, EQZ_NEQZ, ALU_OPCODE,
        DRAM_WE, LMD_LATCH_EN, JUMP_EN, PC_LATCH_EN, WB_MUX_SEL, RF_WE
  );

  // Clocking block for timing synchronization
  clocking ClockingBlock_CU @(posedge CLK);
    /* (TB) INPUTS: TB <- DUT */
    // NOTE: TB's result (CW) signals are sampled at (posedge clk + CLKPERIOD/4)
    input #(1)  IR_LATCH_EN, NPC_LATCH_EN,
        RegA_LATCH_EN, RegB_LATCH_EN, RegIMM_LATCH_EN, JAL_EN,
        MUXA_SEL, MUXB_SEL, ALU_OUTREG_EN, EQ_COND, JMP, EQZ_NEQZ, ALU_OPCODE,
        DRAM_WE, LMD_LATCH_EN, JUMP_EN, PC_LATCH_EN, WB_MUX_SEL, RF_WE;

    /* (TB) OUTPUTS: TB -> DUT */
    // NOTE: Drive DUT's inputs at (posedge clk - CLKPERIOD/4)
    output #(-1) IR_IN;
  endclocking

endinterface



