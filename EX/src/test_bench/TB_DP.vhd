library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.myTypes.all;

entity tb_dp is
end entity tb_dp;

architecture test of tb_dp is

		-- DUT generics
    constant IR_SIZE       : integer := 32;
    constant OPERAND_SIZE  : integer := 5;
    constant I_TYPE_IMM_SIZE : integer := 16;
    constant J_TYPE_IMM_SIZE : integer := 26;

    -- Clock & reset
    signal CLK_i        : std_logic := '0';
		constant TB_CLK_PERIOD : time := 5 ns;
    signal nRST_i       : std_logic := '0';

    -- PC/IR interface
    signal DLX_PC_to_DP_i : std_logic_vector(IR_SIZE-1 downto 0) := (others => '0');
    signal DLX_IR_to_DP_i : std_logic_vector(IR_SIZE-1 downto 0) := (others => '0');
    signal DP_to_DLX_PC   : std_logic_vector(IR_SIZE-1 downto 0);

    -- DRAM interface
    signal DRAM_Addr      : std_logic_vector(IR_SIZE-1 downto 0);
    signal DRAM_DATA      : std_logic_vector(IR_SIZE-1 downto 0);
    signal DRAM_OUT_i     : std_logic_vector(IR_SIZE-1 downto 0) := (others => '0');

    -- Pipeline control signals
    signal IR_LATCH_EN_i     : std_logic := '0';
    signal NPC_LATCH_EN_i    : std_logic := '0';
    signal RegA_LATCH_EN_i   : std_logic := '0';
    signal RegB_LATCH_EN_i   : std_logic := '0';
    signal RegIMM_LATCH_EN_i : std_logic := '0';
    signal JAL_EN_i          : std_logic := '0';

    -- Execute stage
    signal MUX_A_SEL_i      : std_logic := '0';
    signal MUX_B_SEL_i      : std_logic := '0';
    signal ALU_OUTREG_EN_i  : std_logic := '0';
    signal EQ_COND_i        : std_logic := '0';
    signal JMP_i            : std_logic := '0';
    signal EQZ_NEQZ_i       : std_logic := '0';
    signal DP_ALU_OPCODE_i  : aluOp;

    -- Memory stage
    signal DRAM_WE_i        : std_logic := '0';
    signal LMD_LATCH_EN_i   : std_logic := '0';
    signal JUMP_EN_i        : std_logic := '0';
    signal PC_LATCH_EN_i    : std_logic := '0';

    -- Writeback stage
    signal WB_MUX_SEL_i     : std_logic := '0';
    signal RF_WE_i          : std_logic := '0';

    -- Debug:
    signal ALU_OUTREG_INTERNAL : std_logic_vector(IR_SIZE-1 downto 0);

	-- Component:
	component DATAPATH is
    generic (
        IR_SIZE : INTEGER := 32;            -- Instruction size.
        OPERAND_SIZE : INTEGER := 5;        -- Source / Destination Operand Size
        I_TYPE_IMM_SIZE : INTEGER := 16;    -- Immediate Bit Field Size for I-Type Instruction
        J_TYPE_IMM_SIZE : INTEGER := 26     -- Immediate Bit Field Size for J-Type Instruction
    );
    port(

        -- Other Pins
        CLK                  : IN  std_logic;  -- Clock
        nRST                 : IN  std_logic;  -- nRST:Active-Low
        DP_to_DLX_PC         : OUT std_logic_vector(IR_SIZE - 1 DOWNTO 0); -- Will connect output of S4_MUX_JMP_OUT to PC signal in DLX entity.
        DLX_PC_to_DP         : IN std_logic_vector(IR_SIZE - 1 DOWNTO 0); -- Used to connect PC (Program Counter) from DLX to Adder in Datapath.
        DLX_IR_to_DP         : IN std_logic_vector(IR_SIZE - 1 DOWNTO 0); -- Used to connect IR (Instruction Register) from DLX to Stage 2 in Datapath.

        -- DRAM Connections
        DRAM_Addr            : OUT std_logic_vector(IR_SIZE - 1 DOWNTO 0);
        DRAM_DATA            : OUT std_logic_vector(IR_SIZE - 1 DOWNTO 0);
        DRAM_OUT             : IN std_logic_vector(IR_SIZE - 1 DOWNTO 0);

        --- PIPELINE CONTROL SIGNAL INPUTS ---
        -- Instruction Fetch - STAGE 1
        IR_LATCH_EN          : IN std_logic;
        NPC_LATCH_EN         : IN std_logic;

        -- Instruction Decode - STAGE 2
        RegA_LATCH_EN        : IN std_logic;
        RegB_LATCH_EN        : IN std_logic;
        RegIMM_LATCH_EN      : IN std_logic;
        JAL_EN               : IN std_logic;

        -- Execute - STAGE 3
        MUX_A_SEL             : IN std_logic;
        MUX_B_SEL             : IN std_logic;
        ALU_OUTREG_EN        : IN std_logic;
        EQ_COND              : IN std_logic;
        JMP                  : IN std_logic;
        EQZ_NEQZ             : IN std_logic;

        -- ALU Operation Code (STAGE 3)
        DP_ALU_OPCODE           : IN aluOp;

        -- Memory - STAGE 4
        DRAM_WE              : IN std_logic;  -- Data RAM Write Enable
        LMD_LATCH_EN         : IN std_logic;  -- LMD Register Latch Enable
        JUMP_EN              : IN std_logic;  -- JUMP Enable Signal for PC input MUX
        PC_LATCH_EN          : IN std_logic;  -- Program Counte Latch Enable

        -- Writeback - STAGE 5
        WB_MUX_SEL           : IN std_logic;    -- Write Back MUX Sel
        RF_WE                : IN std_logic;   -- Register File Write Enable

				-- DEBUG SIGNALS:
				ALU_OUTREG_INTERNAL : OUT std_logic_vector(IR_SIZE-1 downto 0)
    );
	end component;

begin

		-- Clock generation
    clk_process : process
    begin
        CLK_i <= not CLK_i; wait for TB_CLK_PERIOD/2;
    end process;

    -- Reset stimulus
    stim_proc : process
    begin
        nRST_i <= '0';
        wait for 2*TB_CLK_PERIOD;
        nRST_i <= '1';

        -- simple stimulus
        IR_LATCH_EN_i   <= '1';
        NPC_LATCH_EN_i  <= '1';
        RegA_LATCH_EN_i <= '1';
        -- ... add more stimuli as needed ...

        wait;
    end process;

    -- DUT instantiation
    UUT : entity work.DATAPATH
        generic map (
            IR_SIZE        => IR_SIZE,
            OPERAND_SIZE   => OPERAND_SIZE,
            I_TYPE_IMM_SIZE => I_TYPE_IMM_SIZE,
            J_TYPE_IMM_SIZE => J_TYPE_IMM_SIZE
        )
        port map (
            -- Other pins
            CLK              => CLK_i,
            nRST             => nRST_i,
            DP_to_DLX_PC     => DP_to_DLX_PC,
            DLX_PC_to_DP     => DLX_PC_to_DP_i,
            DLX_IR_to_DP     => DLX_IR_to_DP_i,

            -- DRAM
            DRAM_Addr        => DRAM_Addr,
            DRAM_DATA        => DRAM_DATA,
            DRAM_OUT         => DRAM_OUT_i,

            -- Pipeline control
            IR_LATCH_EN      => IR_LATCH_EN_i,
            NPC_LATCH_EN     => NPC_LATCH_EN_i,
            RegA_LATCH_EN    => RegA_LATCH_EN_i,
            RegB_LATCH_EN    => RegB_LATCH_EN_i,
            RegIMM_LATCH_EN  => RegIMM_LATCH_EN_i,
            JAL_EN           => JAL_EN_i,

            -- Execute
            MUX_A_SEL        => MUX_A_SEL_i,
            MUX_B_SEL        => MUX_B_SEL_i,
            ALU_OUTREG_EN    => ALU_OUTREG_EN_i,
            EQ_COND          => EQ_COND_i,
            JMP              => JMP_i,
            EQZ_NEQZ         => EQZ_NEQZ_i,
            DP_ALU_OPCODE    => DP_ALU_OPCODE_i,

            -- Memory
            DRAM_WE          => DRAM_WE_i,
            LMD_LATCH_EN     => LMD_LATCH_EN_i,
            JUMP_EN          => JUMP_EN_i,
            PC_LATCH_EN      => PC_LATCH_EN_i,

            -- Writeback
            WB_MUX_SEL       => WB_MUX_SEL_i,
            RF_WE            => RF_WE_i,

            -- Debug
            ALU_OUTREG_INTERNAL => ALU_OUTREG_INTERNAL
        );


end architecture tb_dp;
