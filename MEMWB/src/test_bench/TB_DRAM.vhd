library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Data memory for DLX
entity TB_DRAM is
end TB_DRAM;

architecture TB_DRam_Bhe of TB_DRAM is

component DRAM is
  generic (
    RAM_DEPTH : integer := 48;
    D_SIZE : integer := 32);
  port (
    Rst  		 : in  std_logic;
	DRAM_WE 	 : IN  std_logic; 
	DataIN 		 : in std_logic_vector(D_SIZE - 1 DOWNTO 0); 
    Addr 		 : in  std_logic_vector(D_SIZE - 1 downto 0);
    Dout 		 : OUT std_logic_vector(D_SIZE - 1 downto 0));
end component;

	CONSTANT tb_RAM_DEPTH : INTEGER := 48;	
	CONSTANT tb_D_SIZE : INTEGER := 32;	
	SIGNAL tb_Rst : STD_LOGIC;
	SIGNAL tb_DRAM_WE : STD_LOGIC;
	SIGNAL tb_DataIN : std_logic_vector(tb_D_SIZE - 1 DOWNTO 0); 
	SIGNAL tb_Addr : std_logic_vector(tb_D_SIZE - 1 DOWNTO 0);
	SIGNAL tb_Dout : std_logic_vector(tb_D_SIZE - 1 DOWNTO 0);

begin

	tb_DRAM: entity work.DRAM
	 generic map(
		RAM_DEPTH => tb_RAM_DEPTH,
		D_SIZE => tb_D_SIZE)
	 port map(
		Rst => tb_Rst,
		DRAM_WE => tb_DRAM_WE,
		DataIN => tb_DataIN,
		Addr => tb_Addr,
		Dout => tb_Dout);


		process
		begin
			tb_Rst <= '0';
			tb_DRAM_WE <= '1'; 
			tb_DataIN <= (others => '0');
			tb_Addr <= (others => '0'); 
			WAIT FOR 5 ns; 

			-- Write into DRAM. 
			tb_Rst <= '1';
			for i in 0 to tb_RAM_DEPTH - 1  loop
				tb_Addr <= std_logic_vector(to_unsigned(i, tb_D_SIZE)); 
				tb_DataIN <= std_logic_vector(to_unsigned(i, tb_D_SIZE));
				WAIT FOR 5 ns; 
			end loop;

			-- Read from DRAM. 
			tb_DRAM_WE <= '0'; 
			for i in 0 to tb_RAM_DEPTH - 1  loop
				tb_Addr <= std_logic_vector(to_unsigned(i, tb_D_SIZE)); 
				WAIT FOR 5 ns; 
			end loop;

			-- Reset DRAM 
			tb_Rst <= '1'; 
			WAIT FOR 2.5 ns; 

			-- Clear Reset. 
			tb_Rst <= '0'; 
			WAIT FOR 2.5 ns; 

			-- Then Read from DRAM again to ensure all values are zero. 
			for i in 0 to tb_RAM_DEPTH - 1  loop
				tb_Addr <= std_logic_vector(to_unsigned(i, tb_D_SIZE)); 
				WAIT FOR 5 ns; 
			end loop;			

			WAIT; 

		end process;


end TB_DRam_Bhe;
