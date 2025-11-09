library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

-- Data memory for DLX
entity DRAM is
  generic (
    RAM_DEPTH : integer := 48;
    D_SIZE : integer := 32);
  port (
    nRst  		 : IN  std_logic;
	DRAM_WE 	 : IN  std_logic;         -- DRAM Write Enable
	DRAM_RE 	 : IN  std_logic;         -- DRAM Read Enable
	DataIN 		 : IN std_logic_vector(D_SIZE - 1 DOWNTO 0); 
    Addr 		 : IN  std_logic_vector(D_SIZE - 1 downto 0);
    Dout 		 : OUT std_logic_vector(D_SIZE - 1 downto 0));
end DRAM;

architecture DRam_Bhe of DRAM is

  type RAMtype is array (0 to RAM_DEPTH - 1) of std_logic_vector(D_SIZE - 1 DOWNTO 0); -- of integer;

  SIGNAL DRAM_mem : RAMtype;

begin  -- DRam_Bhe
	
	process (DRAM_WE, Addr, nRst, DataIN)
	begin
		IF nRst = '0' THEN 							-- Reset DRAM 
			for DRAMCell in 0 to (RAM_DEPTH - 1) loop
					DRAM_mem(DRAMCell) <= (OTHERS => '0'); 
			end loop;
				DOUT <= (OTHERS => '0');
		ELSE 
			IF (DRAM_WE = '0' AND DRAM_RE = '1') THEN 					-- Read from DRAM.
				Dout <= DRAM_mem(conv_integer(unsigned(Addr)));
			ELSIF (DRAM_WE = '1' AND DRAM_RE = '0') THEN 				-- Write to DRAM.
				DRAM_mem(conv_integer(unsigned(Addr))) <= DataIN; 
			END IF; 
		END IF; 
	end process;  

end DRam_Bhe;
