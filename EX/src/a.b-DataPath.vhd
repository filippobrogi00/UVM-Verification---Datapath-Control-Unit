library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.myTypes.all;
  use work.rf_pkg.all; -- Needed for "log2()" function.

entity DATAPATH is
  generic (
    IR_SIZE         : INTEGER := 32; -- Instruction size.
    OPERAND_SIZE    : INTEGER := 5;  -- Source / Destination Operand Size
    I_TYPE_IMM_SIZE : INTEGER := 16; -- Immediate Bit Field Size for I-Type Instruction
    J_TYPE_IMM_SIZE : INTEGER := 26  -- Immediate Bit Field Size for J-Type Instruction
  );
  port (
    -- Other Pins
    CLK          : in    std_logic;                              -- Clock
    nRST         : in    std_logic;                              -- nRST:Active-Low
    DP_to_DLX_PC : out   std_logic_vector(IR_SIZE - 1 downto 0); -- Will connect output of S4_MUX_JMP_OUT to PC signal in DLX entity.
    DLX_PC_to_DP : in    std_logic_vector(IR_SIZE - 1 downto 0); -- Used to connect PC (Program Counter) from DLX to Adder in Datapath.
    DLX_IR_to_DP : in    std_logic_vector(IR_SIZE - 1 downto 0); -- Used to connect IR (Instruction Register) from DLX to Stage 2 in Datapath.

    -- DRAM Connections
    DRAM_Addr : out   std_logic_vector(IR_SIZE - 1 downto 0);
    DRAM_DATA : out   std_logic_vector(IR_SIZE - 1 downto 0);
    DRAM_OUT  : in    std_logic_vector(IR_SIZE - 1 downto 0);

    --- PIPELINE CONTROL SIGNAL INPUTS ---
    -- Instruction Fetch - STAGE 1
    IR_LATCH_EN  : in    std_logic;
    NPC_LATCH_EN : in    std_logic;

    -- Instruction Decode - STAGE 2
    RegA_LATCH_EN : in    std_logic;
    -- RegB_LATCH_EN        : IN std_logic;
    SIGN_UNSIGN_EN  : in    std_logic;
    RegIMM_LATCH_EN : in    std_logic;
    JAL_EN          : in    std_logic;

    -- Execute - STAGE 3
    MUX_A_SEL     : in    std_logic;
    MUX_B_SEL     : in    std_logic;
    ALU_OUTREG_EN : in    std_logic;
    EQ_COND       : in    std_logic;
    JMP           : in    std_logic;
    EQZ_NEQZ      : in    std_logic;

    -- ALU Operation Code (STAGE 3)
    --DP_ALU_OPCODE : in    aluOp;
    DP_ALU_OPCODE : in    std_logic_vector(4 downto 0);

    -- Memory - STAGE 4
    DRAM_WE      : in    std_logic; -- Data RAM Write Enable
    LMD_LATCH_EN : in    std_logic; -- LMD Register Latch Enable
    JUMP_EN      : in    std_logic; -- JUMP Enable Signal for PC input MUX
    PC_LATCH_EN  : in    std_logic; -- Program Counte Latch Enable

    -- Writeback - STAGE 5
    WB_MUX_SEL : in    std_logic; -- Write Back MUX Sel
    RF_WE      : in    std_logic; -- Register File Write Enable

    -- DEBUG:
    ALU_OUT : out   std_logic_vector(IR_SIZE - 1 downto 0)
  );
end entity DATAPATH;

architecture STRUCT_DATAPATH of DATAPATH is

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

  -- ******************************** STAGE 1 SIGNALS ********************************
  signal S1_ADD_OUT     : std_logic_vector(IR_SIZE - 1 downto 0); -- Read as "Output of Stage 1 adder."
  signal S1_REG_IR_OUT  : std_logic_vector(IR_SIZE - 1 downto 0); -- Read as "Output of Stage 1 Register named "IR"."
  signal S1_REG_NPC_OUT : std_logic_vector(IR_SIZE - 1 downto 0); -- Read as "Output of Stage 1 Register named "NPC."

  -- ******************************** STAGE 2 SIGNALS ********************************
  signal S2_SE16_OUT       : std_logic_vector(IR_SIZE - 1 downto 0);      -- SE16 = Sign Extender w/16-bit input.
  signal S2_SE26_OUT       : std_logic_vector(IR_SIZE - 1 downto 0);      -- SE26 = Sign Extender w/26-bit input.
  signal S2_REG_SE_IMM_OUT : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S2_REG_UE_IMM_OUT : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S2_RFILE_A_OUT    : std_logic_vector(IR_SIZE - 1 downto 0);      -- RFILE = Register File
  signal S2_RFILE_B_OUT    : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S2_REG_A_OUT      : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S2_REG_B_OUT      : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S2_FF_JAL_EN_OUT  : std_logic;                                   -- Part of sequence of Flip-Flops which connect to the select signal of the MUX in Stage 5.
  signal S2_MUX_ADD_WR_OUT : std_logic_vector(OPERAND_SIZE - 1 downto 0); -- Part of sequence of registers at Write-Address input of Register File.
  signal S2_MUX_IorR_OUT   : std_logic_vector(OPERAND_SIZE - 1 downto 0); -- To select correct bits from either R-Type or I-Type Instruction.
  signal S2_REG_ADD_WR_OUT : std_logic_vector(OPERAND_SIZE - 1 downto 0); -- Part of sequence of registers at Write-Address input of Register File.
  signal S2_REG_NPC_OUT    : std_logic_vector(IR_SIZE - 1 downto 0);

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

  -- ******************************** STAGE 4 SIGNALS ********************************
  signal S4_AND_OUT        : std_logic;
  signal S4_REG_LMD_OUT    : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S4_REG_ALU_OUT    : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S4_MUX_JMP_OUT    : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S4_FF_JAL_EN_OUT  : std_logic;                    -- Part of sequence of Flip-Flops which connect to the select signal of the MUX in Stage 5.
  signal S4_REG_ADD_WR_OUT : std_logic_vector(4 downto 0); -- Part of sequence of registers at Write-Address input of Register File.
  signal S4_REG_NPC_OUT    : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S4_MUX_JMP_SEL    : std_logic;

  -- ******************************** STAGE 5 SIGNALS ********************************
  signal S5_MUX_DATAIN_OUT : std_logic_vector(IR_SIZE - 1 downto 0);
  signal S5_MUX_WB_OUT     : std_logic_vector(IR_SIZE - 1 downto 0);

begin

  -- DEBUG:
  ALU_OUT <= S3_ALU_OUT;

  -- ****************************************************************************************
  -- ******************************** STAGE 1 INSTANTIATIONS ********************************
  -- ****************************************************************************************

  S1_REG_IR_OUT <= DLX_IR_to_DP; -- Connects DLX Entity's Instruction Register (DLX_IR_to_DP) value to the Datapath (S1_REG_IR_OUT).

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
      regBits => IR_SIZE,
      numRegs => 32
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

  -- ****************************************************************************************
  -- ******************************** STAGE 3 INSTANTIATIONS ********************************
  -- ****************************************************************************************

  S3_MUX_A : component NBit_2to1MUX
    generic map (
      N => IR_SIZE
    )
    port map (
      A => S2_RFILE_A_OUT,
      B => S1_REG_NPC_OUT,
      S => MUX_A_SEL,
      Y => S3_MUX_A_OUT
    );

  S3_MUX_B : component NBit_2to1MUX
    generic map (
      N => IR_SIZE
    )
    port map (
      A => S3_MUX_JMP_OUT,
      B => S2_RFILE_B_OUT,
      S => MUX_B_SEL,
      Y => S3_MUX_B_OUT
    );

  S3_MUX_JMP : component NBit_2to1MUX
    generic map (
      N => IR_SIZE
    )
    port map (
      A => S2_REG_UE_IMM_OUT,
      B => S2_REG_SE_IMM_OUT,
      S => JMP,
      Y => S3_MUX_JMP_OUT
    );

  S3_ALU : component ALU
    generic map (
      IR_SIZE => IR_SIZE
    )
    port map (
      A          => S3_MUX_A_OUT,
      B          => S3_MUX_B_OUT,
      ALU_OPCODE => DP_ALU_OPCODE,
      Y          => S3_ALU_OUT
    );

  S3_REG_ALU : component NBit_Reg
    generic map (
      N => IR_SIZE
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => ALU_OUTREG_EN,
      D     => S3_ALU_OUT,
      Q     => S3_REG_ALU_OUT
    );

  S3_REG_DATA : component NBit_Reg
    generic map (
      N => IR_SIZE
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => '1',
      D     => S2_RFILE_B_OUT,
      Q     => S3_REG_DATA_OUT
    );

  S3_REG_COND : component NBit_Reg
    generic map (
      N => 1
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => EQ_COND,
      D(0)  => S3_BranchTaken,
      Q(0)  => S3_FF_COND_OUT
    );

  S3_ZeroCompa : component ZeroCompa
    generic map (
      IR_SIZE => IR_SIZE
    )
    port map (
      NUMtoCHECK => S2_RFILE_A_OUT,
      EQZ        => EQZ_NEQZ,
      JMP        => JMP,
      RESULT     => S3_BranchTaken
    );

  S3_FF_JAL_EN : component NBit_Reg
    generic map (
      N => 1
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => '1',
      D(0)  => S2_FF_JAL_EN_OUT,
      Q(0)  => S3_FF_JAL_EN_OUT
    );

  S3_REG_NPC : component NBit_Reg
    generic map (
      N => IR_SIZE
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => '1',
      D     => S2_REG_NPC_OUT,
      Q     => S3_REG_NPC_OUT
    );

  S3_REG_ADD_WR : component NBit_Reg
    generic map (
      N => OPERAND_SIZE
    )
    port map (
      CLK   => CLK,
      nRST  => nRST,
      LD_EN => '1',
      D     => S2_REG_ADD_WR_OUT,
      Q     => S3_REG_ADD_WR_OUT
    );

  -- ****************************************************************************************
  -- ******************************** STAGE 4 INSTANTIATIONS ********************************
  -- ****************************************************************************************

  DRAM_Addr      <= S3_REG_ALU_OUT;  -- Connects Datapath's Stage 3 Register called "ALU_OUT" to Address input of the DRAM.
  DRAM_DATA      <= S3_REG_DATA_OUT; -- Connects Datapath's Stage 3 Register called "DATA_OUT" to Data input of the DRAM.
  S4_MUX_JMP_SEL <= ((S3_FF_COND_OUT) and (JUMP_EN));

  S4_MUX_JMP : component NBit_2to1MUX
    generic map (
      N => IR_SIZE
    )
    port map (
      A => S3_REG_ALU_OUT,
      B => S1_ADD_OUT,
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

end architecture STRUCT_DATAPATH;
