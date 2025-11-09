-- vhdl-linter-disable type-resolved
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.rf_pkg.all; -- Needed for "log2()" function. 

entity gen_register_file is
	generic (
		regBits: integer := 32;
		numRegs: integer := 32
	); 
 port ( 
	-- INPUTS
	CLK, nRST 			:	IN std_logic; -- ACTIVE LOW RESET!
	ENABLE				: 	IN std_logic;

	-- Read operation
	RD1, RD2 			: 	IN std_logic; -- Read Enable signals
	ADD_RD1, ADD_RD2	: 	IN std_logic_vector(log2(numRegs)-1 downto 0); -- Read Addresses

	-- Write operation
	WR 					: 	IN std_logic; -- Write Enable signal
	ADD_WR 				: 	IN std_logic_vector(log2(numRegs)-1 downto 0); -- Write Address
	DATAIN 				: 	IN std_logic_vector(regBits-1 downto 0); -- Data to write 

	-- OUTPUTS
	OUT1: 		OUT std_logic_vector(regBits-1 downto 0);
	OUT2: 		OUT std_logic_vector(regBits-1 downto 0)
);
end gen_register_file;

architecture beh of gen_register_file is

	-- Following structures were provided from professor.
	subtype REG_ADDR is natural range 0 to (numRegs-1); -- using natural type. Indirizzo del registro. 
	type REG_ARRAY is array(REG_ADDR) of std_logic_vector((regBits-1) downto 0); -- Array of REG_ADDR elements where each element is 64 bits.
	signal REGISTERS : REG_ARRAY; 	-- Signal of type REG_ARRAY. This is the Register File. 

begin 
	ClkProc: PROCESS(CLK)
	BEGIN
		IF rising_edge(CLK) THEN 
			-- Reset 
			IF (nRST = '0') THEN
				FOR addr in 0 to (numRegs-1) loop
					REGISTERS(addr) <= (OTHERS => '0'); 
				end loop;
				OUT1 <= (OTHERS => '0');
				OUT2 <= (OTHERS => '0');
			END IF; 
		
			-- Operation 
			IF ((ENABLE = '1') AND (nRST = '1')) THEN   
				-- Write 
				IF (WR = '1') THEN 
					REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN; 
				END IF; 
				
				-- Read from port 1  
				IF (RD1 = '1' ) THEN 
					OUT1 <= REGISTERS(to_integer(unsigned(ADD_RD1))); 
				END IF; 					
				
				-- Read from port 2
				IF (RD2 = '1') THEN 
					OUT2 <= REGISTERS(to_integer(unsigned(ADD_RD2))); 
				END IF; 					
			END IF; 

		END IF;  
	END PROCESS; 
end beh;
