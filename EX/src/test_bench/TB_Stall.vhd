library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_stall is 
end entity tb_stall; 

architecture test of tb_stall is 
  component IRAM is
    generic (
      RAM_DEPTH : integer := 48;
      I_SIZE : integer := 32);
    port (
      nRst  : in  std_logic;
      Addr  : in  std_logic_vector(I_SIZE - 1 downto 0);
      Dout  : out std_logic_vector(I_SIZE - 1 downto 0)
      );
  end component;

  signal clk : STD_LOGIC;

  constant I_SIZE : integer := 32;
  signal s_nRst  : std_logic;
  signal s_Addr  : std_logic_vector(I_SIZE - 1 downto 0);
  signal s_Dout  : std_logic_vector(I_SIZE - 1 downto 0);
begin 
  
  IRAM0: entity work.IRAM
   generic map(
      RAM_DEPTH => 48,
      I_SIZE => 32
  )
   port map(
      nRst => s_nRst,
      Addr => s_Addr,
      Dout => s_Dout
  );

  clock_proc: process(clk)
  begin
    clk <= not clk after 0.5 ns;
  end process clock_proc;

end architecture test;
