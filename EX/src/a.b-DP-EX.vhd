library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.myTypes.all;
  use work.rf_pkg.all;

entity DP_EX is
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
    CLK  : in    std_logic; -- Clock
    nRST : in    std_logic; -- nRST:Active-Low

    -- Inputs from IF+ID Block
    S1_REG_NPC_OUT    : in    std_logic_vector(IR_SIZE - 1 downto  0);
    S2_FF_JAL_EN_OUT  : in    std_logic;
    S2_REG_NPC_OUT    : in    std_logic_vector(IR_SIZE - 1 downto 0);
    S2_REG_ADD_WR_OUT : in    std_logic_vector(OPERAND_SIZE - 1 downto 0); -- Part of sequence of registers at Write-Address input of Register File.
    S2_RFILE_A_OUT    : in    std_logic_vector(IR_SIZE - 1 downto 0);      -- RFILE = Register File
    S2_RFILE_B_OUT    : in    std_logic_vector(IR_SIZE - 1 downto 0);
    S2_REG_SE_IMM_OUT : in    std_logic_vector(IR_SIZE - 1 downto 0);
    S2_REG_UE_IMM_OUT : in    std_logic_vector(IR_SIZE - 1 downto 0);

    -- Execute (STAGE 3) input signals
    MUX_A_SEL     : in    std_logic;
    MUX_B_SEL     : in    std_logic;
    ALU_OUTREG_EN : in    std_logic;
    EQ_COND       : in    std_logic;
    JMP           : in    std_logic;
    EQZ_NEQZ      : in    std_logic;
    DP_ALU_OPCODE : in    aluOp;

    -- Outputs
    DRAM_Addr : out   std_logic_vector(IR_SIZE - 1 downto 0);
    DRAM_DATA : out   std_logic_vector(IR_SIZE - 1 downto 0);

    -- Outputs to MEM+WB Block
    S3_FF_JAL_EN_OUT  : out   	std_logic; -- Part of sequence of Flip-Flops which connect to the select signal of the MUX in Stage 5.
    S3_REG_ADD_WR_OUT : out   	std_logic_vector(4 downto 0);
    S3_FF_COND_OUT    : out   	std_logic; -- Output of S3_REG_COND register
    S3_REG_ALU_OUT    : out   	std_logic_vector(IR_SIZE - 1 downto 0);
    S3_REG_DATA_OUT   : out   	std_logic_vector(IR_SIZE - 1 downto 0);  
 	S3_BranchTaken    : out 	std_logic;
 	S3_MUX_A_OUT      : out 	std_logic_vector(IR_SIZE - 1 downto 0);
 	S3_MUX_B_OUT      : out 	std_logic_vector(IR_SIZE - 1 downto 0);
 	S3_ALU_OUT        : out 	std_logic_vector(IR_SIZE - 1 downto 0);
 	S3_MUX_JMP_OUT    : out 	std_logic_vector(IR_SIZE - 1 downto 0);
 	S3_REG_NPC_OUT    : out		std_logic_vector(IR_SIZE - 1 downto 0)
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

begin

  -- ****************************************************************************************
  -- ******************************** STAGE 3 INSTANTIATIONS ********************************
  -- ****************************************************************************************

  -- NOTE: Moved from "STAGE 4 INSTANTIATIONS" original DLX placement to here because these
  -- are actually produced by "Stage 3" internal signals.
  DRAM_Addr <= S3_REG_ALU_OUT;  -- Connects Datapath's Stage 3 Register called "ALU_OUT" to Address input of the DRAM.
  DRAM_DATA <= S3_REG_DATA_OUT; -- Connects Datapath's Stage 3 Register called "DATA_OUT" to Data input of the DRAM.

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

end architecture structural;
