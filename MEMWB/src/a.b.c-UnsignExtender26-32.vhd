library IEEE;
use IEEE.std_logic_1164.all; 

entity unsign_extender26_32 is 
	GENERIC (N: integer := 26;
			IR_SIZE: integer := 32);

	Port (	
    	IMM_IN  :	In	std_logic_vector (N-1 DOWNTO 0);
		IMM_OUT :	Out	std_logic_vector (IR_SIZE-1 DOWNTO 0));
end unsign_extender26_32;

architecture BEH_COMB_unsign_extender of unsign_extender26_32 is 

begin
	
	GEN_SIGNALS: FOR i IN 0 to IR_SIZE-1 GENERATE
        LowerBits: IF i < N-1 GENERATE
			IMM_OUT(i) <= IMM_IN(i); 
		END GENERATE LowerBits;
		UpperBits: IF i >= N-1 GENERATE
			IMM_OUT(i) <= '0';  
		END GENERATE UpperBits;	
    END GENERATE GEN_SIGNALS;

end BEH_COMB_unsign_extender;


