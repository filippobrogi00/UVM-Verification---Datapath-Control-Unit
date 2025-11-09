library IEEE;
use IEEE.std_logic_1164.all; 

entity TB_sign_extender16_32 is
end TB_sign_extender16_32;

architecture TB_BEH_COMB_sign_extender of TB_sign_extender16_32 is
	
	COMPONENT sign_extender16_32 IS
		GENERIC (
			N: integer := 16;
			IR_SIZE: integer := 32);

		PORT (
			IMM_IN  :	In	std_logic_vector (N-1 DOWNTO 0);
			IMM_OUT :	Out	std_logic_vector (IR_SIZE-1 DOWNTO 0));
	END COMPONENT;

	CONSTANT tb_IR_SIZE : INTEGER := 32;
	CONSTANT tb_N : INTEGER := 16;
	SIGNAL tb_IMM_IN : STD_LOGIC_VECTOR(tb_N - 1 DOWNTO 0); 
	SIGNAL tb_IMM_OUT : STD_LOGIC_VECTOR(tb_IR_SIZE - 1 DOWNTO 0);  

begin

	DUT_sign_extender16_32: entity work.sign_extender16_32
	 GENERIC MAP(
		N => tb_N,
		IR_SIZE => tb_IR_SIZE)
	 PORT MAP(
		IMM_IN => tb_IMM_IN,
		IMM_OUT => tb_IMM_OUT);

	process
	begin
		tb_IMM_IN <= "1010101010101010";
		WAIT FOR 5 NS; 

		tb_IMM_IN <= (OTHERS => '1');
		WAIT FOR 5 NS; 

		tb_IMM_IN <= "1000000000000000";
		WAIT FOR 5 NS; 

		tb_IMM_IN <= "0111111111111111"; 
		WAIT FOR 5 NS; 
	end process;

end TB_BEH_COMB_sign_extender;


