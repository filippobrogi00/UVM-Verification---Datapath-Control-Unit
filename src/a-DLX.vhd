library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.myTypes.all;

entity DLX is
  generic (
    IR_SIZE : integer := 32; -- Instruction Register Size
    PC_SIZE : integer := 32  -- Program Counter Size
  );
  port (
    Clk  : in    std_logic;
    nRst : in    std_logic -- Active Low
  );
end entity DLX;

architecture dlx_rtl of DLX is

  --------------------------------------------------------------------
  -- Components Declaration
  --------------------------------------------------------------------

  -- ********************************* INSTRUCTION RAM DECLARATION *********************************
  component IRAM is
    generic (
      RAM_DEPTH : integer := 48;
      I_SIZE    : integer := 32
    );
    port (
      nRst : in    std_logic;
      Addr : in    std_logic_vector(PC_SIZE - 1 downto 0);
      Dout : out   std_logic_vector(IR_SIZE - 1 downto 0)
    );
  end component IRAM;

  -- ********************************* DATA RAM DECLARATION *********************************
  component DRAM is
    generic (
      RAM_DEPTH : integer := 48;
      D_SIZE    : integer := 32
    );
    port (
      nRst    : in    std_logic;
      DRAM_WE : in    std_logic;
      DRAM_RE : in    std_logic;
      DataIN  : in    std_logic_vector(D_SIZE - 1 downto 0);
      Addr    : in    std_logic_vector(D_SIZE - 1 downto 0);
      Dout    : out   std_logic_vector(D_SIZE - 1 downto 0)
    );
  end component DRAM;

  -- ********************************* DATAPATH DECLARATION *********************************
  component DATAPATH is
    generic (
      IR_SIZE         : INTEGER := 32;
      OPERAND_SIZE    : INTEGER := 5;
      I_TYPE_IMM_SIZE : INTEGER := 16;
      J_TYPE_IMM_SIZE : INTEGER := 26
    );
    port (
      -- Other Pins
      CLK          : in    std_logic;
      nRst         : in    std_logic;
      DP_to_DLX_PC : out   std_logic_vector(IR_SIZE - 1 downto 0);
      DLX_PC_to_DP : in    std_logic_vector(IR_SIZE - 1 downto 0);
      DLX_IR_to_DP : in    std_logic_vector(IR_SIZE - 1 downto 0);

      -- DRAM Connections
      DRAM_Addr : out   std_logic_vector(IR_SIZE - 1 downto 0);
      DRAM_DATA : out   std_logic_vector(IR_SIZE - 1 downto 0);
      DRAM_OUT  : in    std_logic_vector(IR_SIZE - 1 downto 0);

      --- PIPELINE CONTROL SIGNAL INPUTS ---
      -- IF Control Signals - STAGE 1
      IR_LATCH_EN  : in    std_logic;
      NPC_LATCH_EN : in    std_logic;

      -- ID Control Signals - STAGE 2
      RegA_LATCH_EN : in    std_logic;
      -- RegB_LATCH_EN        : IN std_logic;
      SIGN_UNSIGN_EN  : in    std_logic;
      RegIMM_LATCH_EN : in    std_logic;
      JAL_EN          : in    std_logic;

      -- EX Control Signals - STAGE 3
      MUX_A_SEL     : in    std_logic;
      MUX_B_SEL     : in    std_logic;
      ALU_OUTREG_EN : in    std_logic;
      EQ_COND       : in    std_logic;
      JMP           : in    std_logic;
      EQZ_NEQZ      : in    std_logic;

      -- ALU Operation Code
      DP_ALU_OPCODE : in    aluOp;

      -- MEM Control Signals - STAGE 4
      DRAM_WE      : in    std_logic;
      LMD_LATCH_EN : in    std_logic;
      JUMP_EN      : in    std_logic;
      PC_LATCH_EN  : in    std_logic;

      -- WB Control signals - STAGE 5
      WB_MUX_SEL : in    std_logic;
      RF_WE      : in    std_logic;
      -- DEBUG:
      ALU_OUT : out   std_logic_vector(IR_SIZE - 1 downto 0)
    );
  end component DATAPATH;

  -- ********************************* CONTROL UNIT DECLARATION *********************************
  component dlx_cu is
    generic (
      MICROCODE_MEM_SIZE : integer := 62;
      FUNC_SIZE          : integer := 11;
      OP_CODE_SIZE       : integer := 6;
      -- ALU_OPC_SIZE       :     integer := 6;  -- ALU Op Code Word Size
      IR_SIZE : integer := 32;
      CW_SIZE : integer := 18
    );
    port (
      Clk  : in    std_logic;
      nRst : in    std_logic;

      -- Instruction Register
      IR_IN : in    std_logic_vector(IR_SIZE - 1 downto 0);

      -- IF Control Signal - STAGE 1
      IR_LATCH_EN  : out   std_logic;
      NPC_LATCH_EN : out   std_logic;

      -- ID Control Signals - STAGE 2
      RegA_LATCH_EN : out   std_logic;
      -- RegB_LATCH_EN      : out std_logic;  -- Register B Latch Enable
      SIGN_UNSIGN_EN  : out   std_logic;
      RegIMM_LATCH_EN : out   std_logic;
      JAL_EN          : out   std_logic;

      -- EX Control Signals - STAGE 3
      MUXA_SEL      : out   std_logic;
      MUXB_SEL      : out   std_logic;
      ALU_OUTREG_EN : out   std_logic;
      EQ_COND       : out   std_logic;
      JMP           : out   std_logic;
      EQZ_NEQZ      : out   std_logic;

      -- ALU Operation Code
      ALU_OPCODE : out   aluOp;

      -- MEM Control Signals - STAGE 4
      DRAM_WE      : out   std_logic;
      LMD_LATCH_EN : out   std_logic;
      JUMP_EN      : out   std_logic;
      PC_LATCH_EN  : out   std_logic;

      -- WB Control signals - STAGE 5
      WB_MUX_SEL : out   std_logic;
      RF_WE      : out   std_logic
    );
  end component dlx_cu;

  ----------------------------------------------------------------
  -- Signals Declaration
  ----------------------------------------------------------------

  -- Instruction Register (IR) and Program Counter (PC) declaration
  signal IR : std_logic_vector(IR_SIZE - 1 downto 0);
  signal PC : std_logic_vector(PC_SIZE - 1 downto 0);

  -- Instruction Ram Bus signals
  signal IRam_DOut : std_logic_vector(IR_SIZE - 1 downto 0);
  signal IRAM_ADDR : std_logic_vector(IR_SIZE - 1 downto 0);

  -- Data Ram Bus signals
  signal DRAM_ADDR_i   : std_logic_vector(IR_SIZE - 1 downto 0);
  signal DRAM_DATAIN_i : std_logic_vector(IR_SIZE - 1 downto 0);
  signal DRAM_OUT_i    : std_logic_vector(IR_SIZE - 1 downto 0);

  -- Datapath Bus signal
  signal PC_BUS : std_logic_vector(PC_SIZE - 1 downto 0); -- Connects Next PC from Datapath to DLX.

  -- Other signals
  signal PC_to_IRAM : std_logic_vector(PC_SIZE - 1 downto 0); -- Connects PC Register with Address input to IRAM.

  -- Control Unit Bus signals
  -- STAGE 1 CONTROL SIGNALS
  signal IR_LATCH_EN_i  : std_logic;
  signal NPC_LATCH_EN_i : std_logic;

  -- STAGE 2 CONTROL SIGNALS
  signal JAL_EN_i        : std_logic;
  signal RegA_LATCH_EN_i : std_logic;
  -- signal RegB_LATCH_EN_i : std_logic;
  signal SIGN_UNSIGN_EN_i  : std_logic;
  signal RegIMM_LATCH_EN_i : std_logic;

  -- STAGE 3 CONTROL SIGNALS
  signal EQ_COND_i       : std_logic;
  signal JMP_i           : std_logic;
  signal EQZ_NEQZ_i      : std_logic;
  signal ALU_OPCODE_i    : aluOp;
  signal MUX_A_SEL_i     : std_logic;
  signal MUX_B_SEL_i     : std_logic;
  signal ALU_OUTREG_EN_i : std_logic;

  -- STAGE 4 CONTROL SIGNALS
  signal DRAM_WE_i      : std_logic;
  signal LMD_LATCH_EN_i : std_logic;
  signal PC_LATCH_EN_i  : std_logic;
  signal JUMP_EN_i      : std_logic;

  -- STAGE 5 CONTROL SIGNALS
  signal WB_MUX_SEL_i : std_logic;
  signal RF_WE_i      : std_logic;

  -- ALU OUT DEBUG SIGNAL
  signal ALU_OUT : std_logic_vector(IR_SIZE - 1 downto 0);

begin  -- DLX

  -- ********************************* DATAPATH INSTANTIATION *********************************

  DATAPATH_Inst : component DATAPATH
    port map (
      -- Other Pins
      CLK           => Clk,
      nRst          => nRst,
      DP_to_DLX_PC  => PC_BUS,
      DLX_PC_to_DP  => PC,
      DLX_IR_to_DP  => IR,
      DP_ALU_OPCODE => ALU_OPCODE_i,
      -- DRAM Connections
      DRAM_Addr => DRAM_ADDR_i,
      DRAM_DATA => DRAM_DATAIN_i,
      DRAM_Out  => DRAM_OUT_i,
      -- STAGE 1
      IR_LATCH_EN  => IR_LATCH_EN_i,
      NPC_LATCH_EN => NPC_LATCH_EN_i,
      -- STAGE 2
      RegA_LATCH_EN   => RegA_LATCH_EN_i,
      SIGN_UNSIGN_EN  => SIGN_UNSIGN_EN_i,
      RegIMM_LATCH_EN => RegIMM_LATCH_EN_i,
      JAL_EN          => JAL_EN_i,
      -- STAGE 3
      MUX_A_SEL     => MUX_A_SEL_i,
      MUX_B_SEL     => MUX_B_SEL_i,
      ALU_OUTREG_EN => ALU_OUTREG_EN_i,
      EQ_COND       => EQ_COND_i,
      JMP           => JMP_i,
      EQZ_NEQZ      => EQZ_NEQZ_i,
      -- STAGE 4
      DRAM_WE      => DRAM_WE_i,
      LMD_LATCH_EN => LMD_LATCH_EN_i,
      JUMP_EN      => JUMP_EN_i,
      PC_LATCH_EN  => PC_LATCH_EN_i,
      -- STAGE 5
      WB_MUX_SEL => WB_MUX_SEL_i,
      RF_WE      => RF_WE_i,
      -- DEBUG:
      ALU_OUT => ALU_OUT
    );

  -- purpose: Instruction Register Process
  -- type   : sequential
  -- inputs : Clk, nRst, IRam_DOut, IR_LATCH_EN_i
  -- outputs: IR_IN_i
  IR_P : process (Clk, nRst) is
  begin                                   -- process IR_P

    if (nRst = '0') then                  -- asynchronous reset (active low)
      IR <= (others => '0');
    elsif (Clk'event and Clk = '1') then  -- rising clock edge
      if (IR_LATCH_EN_i = '1') then
        IR <= IRam_DOut;
      end if;
    end if;

  end process IR_P;

  -- purpose: Program Counter Process
  -- type   : sequential
  -- inputs : Clk, nRst, PC_BUS
  -- outputs: IRam_Addr
  PC_P : process (Clk, nRst) is
  begin                                   -- process PC_P

    if (nRst = '0') then                  -- asynchronous reset (active low)
      PC <= (others => '0');
    elsif (Clk'event and Clk = '1') then  -- rising clock edge
      if (PC_LATCH_EN_i = '1') then
        PC <= PC_BUS;
      end if;
    end if;

  end process PC_P;

  -- ********************************* Control Unit Instantiation *********************************
  CU_I : component dlx_cu
    port map (
      Clk   => Clk,
      nRst  => nRst,
      IR_IN => IRam_DOut,
      -- STAGE 1
      IR_LATCH_EN  => IR_LATCH_EN_i,
      NPC_LATCH_EN => NPC_LATCH_EN_i,
      -- STAGE 2
      RegA_LATCH_EN   => RegA_LATCH_EN_i,
      SIGN_UNSIGN_EN  => SIGN_UNSIGN_EN_i,
      RegIMM_LATCH_EN => RegIMM_LATCH_EN_i,
      JAL_EN          => JAL_EN_i,
      -- STAGE 3
      MUXA_SEL      => MUX_A_SEL_i,
      MUXB_SEL      => MUX_B_SEL_i,
      ALU_OUTREG_EN => ALU_OUTREG_EN_i,
      EQ_COND       => EQ_COND_i,
      JMP           => JMP_i,
      EQZ_NEQZ      => EQZ_NEQZ_i,
      ALU_OPCODE    => ALU_OPCODE_i,
      -- STAGE 4
      DRAM_WE      => DRAM_WE_i,
      LMD_LATCH_EN => LMD_LATCH_EN_i,
      JUMP_EN      => JUMP_EN_i,
      PC_LATCH_EN  => PC_LATCH_EN_i,
      -- STAGE 5
      WB_MUX_SEL => WB_MUX_SEL_i,
      RF_WE      => RF_WE_i
    );

  -- ********************************* Instruction RAM Instantiation *********************************

  PC_to_IRAM <= to_StdLogicVector(to_bitvector(PC) srl 2); -- "srl" is "Shift Right Logical". Two shifts right is same as dividing "PC" by '4'. Must be done since IRAM is byte-addressable and not 4-byte addressable.

  IRAM_I : component IRAM
    port map (
      nRst => nRst,
      Addr => PC_to_IRAM,
      Dout => IRam_DOut
    );

  -- ********************************* Data RAM Instantiation *********************************
  DRAM_I : component DRAM
    port map (
      nRst    => nRst,
      DRAM_WE => DRAM_WE_i,
      DRAM_RE => LMD_LATCH_EN_i,
      DataIN  => DRAM_DATAIN_i,
      ADDR    => DRAM_ADDR_i,
      Dout    => DRAM_OUT_i
    );

end architecture dlx_rtl;
