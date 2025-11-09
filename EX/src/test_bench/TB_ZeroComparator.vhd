library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_signed.all;
use IEEE.NUMERIC_STD.all; 

entity TB_ZeroComparator is
end TB_ZeroComparator;

architecture TB_BEH_COMB_zero_compa of TB_ZeroComparator is
	
	COMPONENT ZeroCompa IS
		GENERIC (IR_SIZE: integer := 32);
		Port (	
			NUMtoCHECK  :	IN	std_logic_vector (IR_SIZE-1 DOWNTO 0);
			EQZ			: 	IN 	std_logic;								-- EQZ = 1 -> Checks if input is equal to '0'; EQZ = 0 -> Checks if input is not equal to '0'. 
			JMP			: 	IN 	std_logic; 
			RESULT 		:	OUT	std_logic);
	END COMPONENT;

	CONSTANT tb_IR_SIZE : INTEGER := 32;
	SIGNAL tb_NUMtoCHECK : STD_LOGIC_VECTOR(tb_IR_SIZE - 1 DOWNTO 0);  
	SIGNAL tb_EQZ : STD_LOGIC;
	SIGNAL tb_JMP : STD_LOGIC;
	SIGNAL tb_RESULT: STD_LOGIC;

begin

	DUT_ZeroCompa: entity work.ZeroCompa
	 generic map(IR_SIZE => tb_IR_SIZE)
	 port map(
		NUMtoCHECK => tb_NUMtoCHECK,
		EQZ => tb_EQZ,
		JMP => tb_JMP,
		RESULT => tb_RESULT);

	process
	begin

		tb_NUMtoCHECK <= std_logic_vector(to_unsigned(47, tb_IR_SIZE));
		tb_EQZ <= '1'; 
		tb_JMP <= '0'; 
		WAIT FOR 5 NS; 

		tb_EQZ <= '0'; 
		tb_JMP <= '0'; 
		WAIT FOR 5 NS;

		tb_NUMtoCHECK <= (OTHERS => '0'); 
		tb_EQZ <= '1'; 
		tb_JMP <= '0'; 
		WAIT FOR 5 NS; 

		tb_EQZ <= '0'; 
		tb_JMP <= '0'; 
		WAIT FOR 5 NS;

		tb_NUMtoCHECK <= std_logic_vector(to_unsigned(74, tb_IR_SIZE));
		tb_EQZ <= '1'; 
		tb_JMP <= '1'; 
		WAIT FOR 5 NS;
		
		tb_NUMtoCHECK <= std_logic_vector(to_unsigned(74, tb_IR_SIZE));
		tb_EQZ <= '0'; 
		tb_JMP <= '1'; 
		WAIT FOR 5 NS;		
		
		WAIT; 
	end process;

end TB_BEH_COMB_zero_compa;


