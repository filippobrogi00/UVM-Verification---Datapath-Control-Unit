library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all; -- DEPRECATED!
use ieee.numeric_std.all;

-- Data memory for DLX
entity TB_IRAM is
end TB_IRAM;

architecture TB_IRam_Bhe of TB_IRAM is

component IRAM is
  generic (
    RAM_DEPTH : integer := 48;
    I_SIZE : integer := 32);
  port (
    nRst  		 : in  std_logic;  
    Addr 		 : in  std_logic_vector(I_SIZE - 1 downto 0);
    Dout 		 : OUT std_logic_vector(I_SIZE - 1 downto 0));
end component;

	CONSTANT tb_RAM_DEPTH : INTEGER := 48;	
	CONSTANT tb_I_SIZE : INTEGER := 32;	
	SIGNAL tb_nRst : STD_LOGIC; 
	SIGNAL tb_Addr : std_logic_vector(tb_I_SIZE - 1 DOWNTO 0);
	SIGNAL tb_Dout : std_logic_vector(tb_I_SIZE - 1 DOWNTO 0);

begin

	tb_IRAM: entity work.IRAM
	 generic map(
		RAM_DEPTH => tb_RAM_DEPTH,
		I_SIZE => tb_I_SIZE)
	 port map(
		nRst => tb_nRst,
		Addr => tb_Addr,
		Dout => tb_Dout);


		process
		begin

			tb_nRst <= '0';
			tb_Addr <= (others => '0'); 
			WAIT FOR 5 ns; 

			-- Read from IRAM. 
			tb_nRst <= '1';
			for i in 0 to tb_RAM_DEPTH - 1  loop
				tb_Addr <= std_logic_vector(to_unsigned(i, tb_I_SIZE)); 
				WAIT FOR 5 ns; 
			end loop;

			-- Reset IRAM. 
			-- tb_nRst <= '0'; 
			-- WAIT FOR 2.5 ns; 
			--
			-- -- Then Read from IRAM again. 
			-- for i in 0 to tb_RAM_DEPTH - 1  loop
			-- 	tb_Addr <= std_logic_vector(to_unsigned(i, tb_I_SIZE)); 
			-- 	WAIT FOR 5 ns; 
			-- end loop;			

			WAIT; 

		end process;


end TB_IRam_Bhe;
