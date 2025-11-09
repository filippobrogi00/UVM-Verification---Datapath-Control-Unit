library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.myTypes.all;
  use work.rf_pkg.all;

entity DP_MEMWB is
  generic (
    IR_SIZE         : INTEGER := 32; -- Instruction size.
    OPERAND_SIZE    : INTEGER := 5;  -- Source / Destination Operand Size
    I_TYPE_IMM_SIZE : INTEGER := 16; -- Immediate Bit Field Size for I-Type Instruction
    J_TYPE_IMM_SIZE : INTEGER := 26; -- Immediate Bit Field Size for J-Type Instruction
    RF_regBits      : integer := 32; -- Bitwidth of RF words
    RF_numRegs      : integer := 32  -- Number of RF registers
  );
  port (
    -- Inputs
    CLK      : in    std_logic; -- Clock
    nRST     : in    std_logic; -- nRST:Active-Low
    DRAM_OUT : in    std_logic_vector(IR_SIZE - 1 downto 0);

    -- Input signals from IF+ID Block
    S1_ADD_OUT : in    std_logic_vector(IR_SIZE - 1 downto 0); -- Read as "Output of Stage 1 adder."

    -- Input signals from EX Block
    S3_REG_NPC_OUT    : in    std_logic_vector(IR_SIZE - 1 downto 0);
    S3_FF_JAL_EN_OUT  : in    std_logic; -- Part of sequence of Flip-Flops which connect to the select signal of the MUX in Stage 5.
    S3_REG_ADD_WR_OUT : in    std_logic_vector(4 downto 0);
    S3_FF_COND_OUT    : in    std_logic; -- Output of S3_REG_COND register
    S3_REG_ALU_OUT    : in    std_logic_vector(IR_SIZE - 1 downto 0);
    S3_REG_DATA_OUT   : in    std_logic_vector(IR_SIZE - 1 downto 0);

    -- Memory (STAGE 4) input signals
    DRAM_WE      : in    std_logic; -- Data RAM Write Enable
    LMD_LATCH_EN : in    std_logic; -- LMD Register Latch Enable
    JUMP_EN      : in    std_logic; -- JUMP Enable Signal for PC input MUX
    PC_LATCH_EN  : in    std_logic; -- Program Counte Latch Enable

    -- Writeback - STAGE 5
    WB_MUX_SEL : in    std_logic; -- Write Back MUX Sel
    RF_WE      : in    std_logic; -- Register File Write Enable

    -- Outputs
    DP_to_DLX_PC : out   std_logic_vector(IR_SIZE - 1 downto 0); -- Will connect output of S4_MUX_JMP_OUT to PC signal in DLX entity.

    -- Outputs to IF+ID Block
    S4_REG_ADD_WR_OUT : out   std_logic_vector(4 downto 0); -- Part of sequence of registers at Write-Address input of Register File.
    S5_MUX_DATAIN_OUT : out   std_logic_vector(IR_SIZE - 1 downto 0)
  );
end entity DP_MEMWB;

architecture structural of DP_MEMWB is

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

  -- ******************************** STAGE 4 SIGNALS ********************************
  signal S4_AND_OUT       : std_logic;
  signal S4_REG_LMD_OUT   : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S4_REG_ALU_OUT   : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S4_MUX_JMP_OUT   : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S4_FF_JAL_EN_OUT : std_logic;                    -- Part of sequence of Flip-Flops which connect to the select signal of the MUX in Stage 5.
  signal S4_REG_NPC_OUT   : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S4_MUX_JMP_SEL   : std_logic;

  -- ******************************** STAGE 5 SIGNALS ********************************
  signal S5_MUX_WB_OUT : std_logic_vector(IR_SIZE - 1 downto 0);

begin

  -- ****************************************************************************************
  -- ******************************** STAGE 4 INSTANTIATIONS ********************************
  -- ****************************************************************************************

  S4_MUX_JMP_SEL <= ((S3_FF_COND_OUT) and (JUMP_EN));

  S4_MUX_JMP : component NBit_2to1MUX
    generic map (
      N => IR_SIZE
    )
    port map (
      A => S3_REG_ALU_OUT,
      -- vsg_off
      -- DEBUG: Either S1_REG_ADD_OUT (combinational) or the registered version S1_REG_NPC_OUT.
      -- In the original DLX code, it was ADD_OUT, in the diagram (an error probably) it was REG_NPC_OUT.
      B => S1_ADD_OUT,
      -- vsg_on
      S => S4_MUX_JMP_SEL,
      Y => DP_to_DLX_PC
    );

  S4_REG_LMD : component NBit_Reg
    generic map (
      N => IR_SIZE
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => LMD_LATCH_EN,
      D     => DRAM_OUT,
      Q     => S4_REG_LMD_OUT
    );

  S4_REG_ALU : component NBit_Reg
    generic map (
      N => IR_SIZE
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => '1',
      D     => S3_REG_ALU_OUT,
      Q     => S4_REG_ALU_OUT
    );

  S4_FF_JAL_EN : component NBit_Reg
    generic map (
      N => 1
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => '1',
      D(0)  => S3_FF_JAL_EN_OUT,
      Q(0)  => S4_FF_JAL_EN_OUT
    );

  S4_REG_NPC : component NBit_Reg
    generic map (
      N => IR_SIZE
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => '1',
      D     => S3_REG_NPC_OUT,
      Q     => S4_REG_NPC_OUT
    );

  S4_REG_ADD_WR : component NBit_Reg
    generic map (
      N => OPERAND_SIZE
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => '1',
      D     => S3_REG_ADD_WR_OUT,
      Q     => S4_REG_ADD_WR_OUT
    );

  -- ****************************************************************************************
  -- ******************************** STAGE 5 INSTANTIATIONS ********************************
  -- ****************************************************************************************

  S5_MUX_WB : component NBit_2to1MUX
    generic map (
      N => IR_SIZE
    )
    port map (
      A => S4_REG_ALU_OUT,
      B => S4_REG_LMD_OUT,
      S => WB_MUX_SEL,
      Y => S5_MUX_WB_OUT
    );

  S5_MUX_DATAIN : component NBit_2to1MUX
    generic map (
      N => IR_SIZE
    )
    port map (
      A => S4_REG_NPC_OUT,
      B => S5_MUX_WB_OUT,
      S => S4_FF_JAL_EN_OUT,
      Y => S5_MUX_DATAIN_OUT
    );

end architecture structural;
