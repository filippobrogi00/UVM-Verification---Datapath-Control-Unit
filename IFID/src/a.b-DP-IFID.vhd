library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.myTypes.all;
  use work.rf_pkg.all;

entity DP_IFID is
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
    CLK          : in    std_logic;                              -- Clock
    nRST         : in    std_logic;                              -- nRST:Active-Low
    DLX_PC_to_DP : in    std_logic_vector(IR_SIZE - 1 downto 0); -- Used to connect PC (Program Counter) from DLX to Adder in Datapath.
    DLX_IR_to_DP : in    std_logic_vector(IR_SIZE - 1 downto 0); -- Used to connect IR (Instruction Register) from DLX to Stage 2 in Datapath.

    -- Instruction Fetch - STAGE 1
    IR_LATCH_EN  : in    std_logic;
    NPC_LATCH_EN : in    std_logic;

    -- Instruction Decode - STAGE 2
    RegA_LATCH_EN   : in    std_logic;
    SIGN_UNSIGN_EN  : in    std_logic;
    RegIMM_LATCH_EN : in    std_logic;
    JAL_EN          : in    std_logic;

    -- Additional RF inputs (STAGES 4 and 5)
    RF_WE             : in    std_logic;
    S4_REG_ADD_WR_OUT : in    std_logic_vector(log2(RF_numRegs) - 1 downto 0);
    S5_MUX_DATAIN_OUT : in    std_logic_vector(RF_regBits - 1 downto 0);

    -- Outputs to EX Stage
    S1_REG_NPC_OUT    : out   std_logic_vector(IR_SIZE - 1 downto 0);
    S2_REG_NPC_OUT    : out   std_logic_vector(IR_SIZE - 1 downto 0);
    S2_FF_JAL_EN_OUT  : out   std_logic;
    S2_REG_ADD_WR_OUT : out   std_logic_vector(OPERAND_SIZE - 1 downto 0); -- Part of sequence of registers at Write-Address input of Register File.
    S2_RFILE_A_OUT    : out   std_logic_vector(IR_SIZE - 1 downto 0);      -- RFILE = Register File
    S2_RFILE_B_OUT    : out   std_logic_vector(IR_SIZE - 1 downto 0);
    S2_REG_SE_IMM_OUT : out   std_logic_vector(IR_SIZE - 1 downto 0);
    S2_REG_UE_IMM_OUT : out   std_logic_vector(IR_SIZE - 1 downto 0);

    -- Outputs to MEMWB Macro-Stage
    S1_ADD_OUT : out   std_logic_vector(IR_SIZE - 1 downto 0) -- Read as "Output of Stage 1 adder."
  );
end entity DP_IFID;

architecture structural of DP_IFID is

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
      RF_regBits : integer := 32;
      RF_numRegs : integer := 32
    );
    port (
      -- INPUTS
      CLK     : in    std_logic;
      nRST    : in    std_logic;
      ENABLE  : in    std_logic;
      RD1     : in    std_logic;
      RD2     : in    std_logic;
      ADD_RD1 : in    std_logic_vector(log2(RF_numRegs) - 1 downto 0);
      ADD_RD2 : in    std_logic_vector(log2(RF_numRegs) - 1 downto 0);

      -- Write operation
      WR     : in    std_logic;
      ADD_WR : in    std_logic_vector(log2(RF_numRegs) - 1 downto 0);
      DATAIN : in    std_logic_vector(RF_regBits - 1 downto 0);

      -- OUTPUTS
      OUT1 : out   std_logic_vector(RF_regBits - 1 downto 0);
      OUT2 : out   std_logic_vector(RF_regBits - 1 downto 0)
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

  -- ******************************** STAGE 1 SIGNALS ********************************
  signal S1_REG_IR_OUT : std_logic_vector(IR_SIZE - 1 downto 0); -- Read as "Output of Stage 1 Register named "IR"."

  -- ******************************** STAGE 2 SIGNALS ********************************
  signal S2_SE16_OUT       : std_logic_vector(IR_SIZE - 1 downto 0);      -- SE16 = Sign Extender w/16-bit input.
  signal S2_SE26_OUT       : std_logic_vector(IR_SIZE - 1 downto 0);      -- SE26 = Sign Extender w/26-bit input.
  signal S2_REG_A_OUT      : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S2_REG_B_OUT      : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S2_MUX_ADD_WR_OUT : std_logic_vector(OPERAND_SIZE - 1 downto 0); -- Part of sequence of registers at Write-Address input of Register File.
  signal S2_MUX_IorR_OUT   : std_logic_vector(OPERAND_SIZE - 1 downto 0); -- To select correct bits from either R-Type or I-Type Instruction.

begin

  S1_REG_IR_OUT <= DLX_IR_to_DP; -- Connects DLX Entity's Instruction Register (DLX_IR_to_DP) value to the Datapath (S1_REG_IR_OUT).

  -- ****************************************************************************************
  -- ******************************** STAGE 1 INSTANTIATIONS ********************************
  -- ****************************************************************************************

  S1_ADD : component PC_Adder
    generic map (
      IR_SIZE => IR_SIZE
    )
    port map (
      A => DLX_PC_to_DP,
      Y => S1_ADD_OUT
    );

  S1_REG_NPC : component NBit_Reg
    generic map (
      N => IR_SIZE
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => NPC_LATCH_EN,
      D     => S1_ADD_OUT,
      Q     => S1_REG_NPC_OUT
    );

  -- ****************************************************************************************
  -- ******************************** STAGE 2 INSTANTIATIONS ********************************
  -- ****************************************************************************************

  S2_MUX_IorR : component NBit_2to1MUX
    generic map (
      N => OPERAND_SIZE
    )
    port map (
      A => S1_REG_IR_OUT(20 downto 16),
      B => S1_REG_IR_OUT(15 downto 11),
      S => RegIMM_LATCH_EN,
      Y => S2_MUX_IorR_OUT
    );

  S2_MUX_ADD_WR : component NBit_2to1MUX
    generic map (
      N => OPERAND_SIZE
    )
    port map (
      A => "11111",
      B => S2_MUX_IorR_OUT,
      S => JAL_EN,
      Y => S2_MUX_ADD_WR_OUT
    );

  S2_REG_ADD_WR : component NBit_Reg
    generic map (
      N => OPERAND_SIZE
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => '1',
      D     => S2_MUX_ADD_WR_OUT,
      Q     => S2_REG_ADD_WR_OUT
    );

  S2_RFILE : component gen_register_file
    generic map (
      RF_regBits => IR_SIZE,
      RF_numRegs => 32
    )
    port map (
      CLK     => CLK,
      nRST    => nRST,
      ENABLE  => '1',
      RD1     => '1',
      RD2     => '1',
      ADD_RD1 => S1_REG_IR_OUT(25 downto 21),
      ADD_RD2 => S1_REG_IR_OUT(20 downto 16),
      WR      => RF_WE,
      ADD_WR  => S4_REG_ADD_WR_OUT,
      DATAIN  => S5_MUX_DATAIN_OUT,
      OUT1    => S2_RFILE_A_OUT,
      OUT2    => S2_RFILE_B_OUT
    );

  S2_SE16 : component sign_extender16_32
    generic map (
      IR_SIZE => IR_SIZE
    )
    port map (
      IMM_IN         => S1_REG_IR_OUT(15 downto 0),
      SIGN_UNSIGN_EN => SIGN_UNSIGN_EN,
      IMM_OUT        => S2_SE16_OUT
    );

  S2_SE26 : component sign_extender26_32
    generic map (
      IR_SIZE => IR_SIZE
    )
    port map (
      IMM_IN  => S1_REG_IR_OUT(25 downto 0),
      IMM_OUT => S2_SE26_OUT
    );

  S2_REG_SE16_IMM : component NBit_Reg
    generic map (
      N => IR_SIZE
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => RegIMM_LATCH_EN,
      D     => S2_SE16_OUT,
      Q     => S2_REG_SE_IMM_OUT
    );

  S2_REG_SE26_IMM : component NBit_Reg
    generic map (
      N => IR_SIZE
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => RegIMM_LATCH_EN,
      D     => S2_SE26_OUT,
      Q     => S2_REG_UE_IMM_OUT
    );

  S2_FF_JAL_EN : component NBit_Reg
    generic map (
      N => 1
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => '1',
      D(0)  => JAL_EN,
      Q(0)  => S2_FF_JAL_EN_OUT
    );

  S2_REG_NPC : component NBit_Reg
    generic map (
      N => IR_SIZE
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => '1',
      D     => S1_REG_NPC_OUT,
      Q     => S2_REG_NPC_OUT
    );

end architecture structural;
