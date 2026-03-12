library IEEE;
use IEEE.std_logic_1164.all; 
-- Deprecated!: use IEEE.std_logic_signed.all; -- Added to use '+' and '-' operators.
use IEEE.NUMERIC_STD.all; -- to use "to_unsigned". 

entity PC_Adder is

	GENERIC (IR_SIZE: integer := 32);	
	Port (	
    	A			:	IN	std_logic_vector (IR_SIZE - 1 DOWNTO 0);
		Y			: 	OUT	std_logic_vector (IR_SIZE - 1 DOWNTO 0));

end PC_Adder;

architecture BEH_COMB_PC_ADD of PC_Adder is 
		
begin

		Y <= std_logic_vector(unsigned(A) + to_unsigned(4, IR_SIZE));  
		
end BEH_COMB_PC_ADD;


