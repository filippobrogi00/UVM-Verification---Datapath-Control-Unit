library IEEE;
use IEEE.std_logic_1164.all;
use WORK.all;

-- Entity declaration for testbench
entity tb_dlx is
end tb_dlx;

-- Architecture body
architecture TEST of tb_dlx is

    -- Constants
    constant tb_SIZE_IR      : integer := 32; -- Instruction Register Size
    constant tb_SIZE_PC      : integer := 32; -- Program Counter Size
    constant tb_SIZE_ALU_OPC : integer := 6;  -- ALU Op Code Word Size (for explicit coding)

    -- Testbench signals
    signal tb_Clock : std_logic := '0';
    signal tb_nRst : std_logic := '1';

    -- Clock period
    constant CLK_PERIOD : Time := 1 ns;

    -- DLX component declaration
    component DLX
        generic (
            IR_SIZE : integer := 32; -- Instruction Register Size
            PC_SIZE : integer := 32  -- Program Counter Size
        );
        port (
            Clk : in std_logic;
            nRst : in std_logic       -- Active Low
        );
    end component;

begin

    -- Instance of DLX
    U1: DLX
        generic map (
            IR_SIZE => tb_SIZE_IR,
            PC_SIZE => tb_SIZE_PC
            -- ALU_OPC_SIZE not used in component
        )
        port map (
            Clk => tb_Clock,
            nRst => tb_nRst
        );

    -- Clock generation process
    PCLOCK : process(tb_Clock)
    begin
        tb_Clock <= not tb_Clock after CLK_PERIOD/2;
    end process;

    -- Reset signal sequencing
    tb_nRst <= '0',
             '1' after 6*CLK_PERIOD;


end TEST;

-- Configuration for tb_dlx
configuration CFG_TB of tb_dlx is
    for TEST
    end for;
end CFG_TB;
