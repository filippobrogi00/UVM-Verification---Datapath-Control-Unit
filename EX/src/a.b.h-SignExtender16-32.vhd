library IEEE;
use IEEE.std_logic_1164.all; 

entity sign_extender16_32 is
	GENERIC (N: integer := 16;
			IR_SIZE: integer := 32);

	Port (	
    	IMM_IN  :	In	std_logic_vector (N-1 DOWNTO 0);
    	SIGN_UNSIGN_EN : IN std_logic; -- '1' outputs sign extended input; '0' outputs unsign extended input.
		IMM_OUT :	Out	std_logic_vector (IR_SIZE-1 DOWNTO 0));
end sign_extender16_32;

architecture BEH_COMB_sign_extender of sign_extender16_32 is 

    SIGNAL SignExtended: std_logic_vector (IR_SIZE-1 DOWNTO 0);
    SIGNAL UnsignExtended: std_logic_vector (IR_SIZE-1 DOWNTO 0);

begin
	
	Sign_GEN_SIGNALS: FOR i IN 0 to IR_SIZE-1 GENERATE
        LowerBits: IF i < N-1 GENERATE
			SignExtended(i) <= IMM_IN(i); 
		END GENERATE LowerBits;
		UpperBits: IF i >= N-1 GENERATE 
			  SignExtended(i) <= IMM_IN(N-1); 
		END GENERATE UpperBits;	
    END GENERATE Sign_GEN_SIGNALS;
    
    Unsign_GEN_SIGNALS: FOR i IN 0 to IR_SIZE-1 GENERATE
        LowerBits: IF i < N-1 GENERATE
			UnsignExtended(i) <= IMM_IN(i); 
		END GENERATE LowerBits;
		UpperBits: IF i >= N-1 GENERATE 
			  UnsignExtended(i) <= '0'; 
		END GENERATE UpperBits;	
    END GENERATE Unsign_GEN_SIGNALS;
    
    IMM_OUT <= SignExtended WHEN Sign_Unsign_EN = '1' ELSE 
               UnsignExtended; 

end BEH_COMB_sign_extender;


