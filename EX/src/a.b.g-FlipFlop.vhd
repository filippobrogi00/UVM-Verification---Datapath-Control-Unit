library IEEE;
  use IEEE.std_logic_1164.all;

entity NBit_Reg is
  generic (
    N : integer := 4
  );
  port (
    CLK   : in    std_logic;
    nRST  : in    std_logic; -- ACTIVE LOW RESET
    LD_EN : in    std_logic;
    D     : in    std_logic_vector(N - 1 downto 0);
    Q     : out   std_logic_vector(N - 1 downto 0)
  );
end entity NBit_Reg;

architecture BEH_NBit_Reg of NBit_Reg is -- flip flop D with syncronous reset

begin

  PSYNCH : process (CLK) is
  begin

    if rising_edge(CLK) then   -- positive edge triggered:
	if (nRST = '0') then
        Q <= (others => '0');
      elsif (LD_EN = '1') then
        Q <= D;                -- input is written on output
      end if;
    end if;

  end process PSYNCH;

end architecture BEH_NBit_Reg;

