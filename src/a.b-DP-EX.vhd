library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DP_EX is
  generic (
    IR_SIZE         : INTEGER := 32; -- Instruction size.
    OPERAND_SIZE    : INTEGER := 5;  -- Source / Destination Operand Size
    I_TYPE_IMM_SIZE : INTEGER := 16; -- Immediate Bit Field Size for I-Type Instruction
    J_TYPE_IMM_SIZE : INTEGER := 26  -- Immediate Bit Field Size for J-Type Instruction
  );
  port (
    CLK          : in    std_logic;                              -- Clock
    nRST         : in    std_logic;                              -- nRST:Active-Low

    -- Execute (STAGE 3) input signals
    MUX_A_SEL     : in    std_logic;
    MUX_B_SEL     : in    std_logic;
    ALU_OUTREG_EN : in    std_logic;
    EQ_COND       : in    std_logic;
    JMP           : in    std_logic;
    EQZ_NEQZ      : in    std_logic

  -- Outputs
  );
end entity DP_EX;

architecture structural of DP_EX is


  -- ***********************************************************************
  -- *********************** COMPONENT DECLARATIONS ************************
  -- ***********************************************************************

  -- ******************************** ADDER (for PC OFFSET) DECLARATION ********************************
  component PC_Adder is
    generic (
      IR_SIZE : integer := 32
    );
    port (
      A : in    std_logic_vector(IR_SIZE - 1 downto 0);
      Y : out   std_logic_vector(IR_SIZE - 1 downto 0)
    );
  end component PC_Adder;

  -- ******************************** REGISTER DECLARATION ********************************
  component NBit_Reg is
    generic (
      N : integer := 4
    );
    port (
      CLK   : in    std_logic;
      nRST  : in    std_logic;
      LD_EN : in    std_logic;
      D     : in    std_logic_vector(N - 1 downto 0);
      Q     : out   std_logic_vector(N - 1 downto 0)
    );
  end component NBit_Reg;

  -- ******************************** REGISTER FILE DECLARATION ********************************
  component gen_register_file is

    generic (
      regBits : integer := 32;
      numRegs : integer := 32
    );
    port (
      -- INPUTS
      CLK     : in    std_logic;
      nRST    : in    std_logic;
      ENABLE  : in    std_logic;
      RD1     : in    std_logic;
      RD2     : in    std_logic;
      ADD_RD1 : in    std_logic_vector(log2(numRegs) - 1 downto 0);
      ADD_RD2 : in    std_logic_vector(log2(numRegs) - 1 downto 0);

      -- Write operation
      WR     : in    std_logic;
      ADD_WR : in    std_logic_vector(log2(numRegs) - 1 downto 0);
      DATAIN : in    std_logic_vector(regBits - 1 downto 0);

      -- OUTPUTS
      OUT1 : out   std_logic_vector(regBits - 1 downto 0);
      OUT2 : out   std_logic_vector(regBits - 1 downto 0)
    );
  end component gen_register_file;

  -- ******************************** SIGNED 16 to 32 EXTENDER DECLARATION ********************************
  component sign_extender16_32 is
    generic (
      N       : integer := 16;
      IR_SIZE : integer := 32
    );
    port (
      IMM_IN         : in    std_logic_vector(N - 1 downto 0);
      SIGN_UNSIGN_EN : in    std_logic;
      IMM_OUT        : out   std_logic_vector(IR_SIZE - 1 downto 0)
    );
  end component sign_extender16_32;

  -- ******************************** SIGNED 26 to 32 EXTENDER DECLARATION ********************************
  component sign_extender26_32 is
    generic (
      N       : integer := 26;
      IR_SIZE : integer := 32
    );
    port (
      IMM_IN  : in    std_logic_vector(N - 1 downto 0);
      IMM_OUT : out   std_logic_vector(IR_SIZE - 1 downto 0)
    );
  end component sign_extender26_32;

  -- ******************************** ZERO COMPARATOR DECLARATION ********************************
  component ZeroCompa is
    generic (
      IR_SIZE : integer := 32
    );
    port (
      NUMtoCHECK : in    std_logic_vector(IR_SIZE - 1 downto 0);
      EQZ        : in    std_logic;
      JMP        : in    std_logic;
      RESULT     : out   std_logic
    );
  end component ZeroCompa;

  -- ******************************** MUX DECLARATION ********************************
  component NBit_2to1MUX is
    generic (
      N : integer := 1
    );
    port (
      A : in    std_logic_vector(N - 1 downto 0);
      B : in    std_logic_vector(N - 1 downto 0);
      S : in    std_logic;
      Y : out   std_logic_vector(N - 1 downto 0)
    );
  end component NBit_2to1MUX;

  -- ******************************** ALU DECLARATION ********************************
  component ALU is
    generic (
      IR_SIZE : integer := 32
    );
    port (
      A          : in    std_logic_vector(IR_SIZE - 1 downto 0);
      B          : in    std_logic_vector(IR_SIZE - 1 downto 0);
      ALU_OPCODE : in    aluOp;
      Y          : out   std_logic_vector(IR_SIZE - 1 downto 0)
    );
  end component ALU;

  -- ******************************** STAGE 3 SIGNALS ********************************
  signal S3_BranchTaken    : std_logic;
  signal S3_MUX_A_OUT      : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S3_MUX_B_OUT      : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S3_ALU_OUT        : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S3_MUX_JMP_OUT    : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S3_REG_ALU_OUT    : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S3_FF_COND_OUT    : std_logic;
  signal S3_REG_DATA_OUT   : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S3_FF_JAL_EN_OUT  : std_logic; -- Part of sequence of Flip-Flops which connect to the select signal of the MUX in Stage 5.
  signal S3_REG_ADD_WR_OUT : std_logic_vector(4 downto 0);
  signal S3_REG_NPC_OUT    : std_logic_vector(IR_SIZE - 1 downto 0);

begin



end architecture structural;
