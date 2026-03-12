library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_signed.all; -- Added to use '+' and '-' operators.
use IEEE.NUMERIC_STD.all; -- to use "to_unsigned". 

entity TB_PC_Adder is
end TB_PC_Adder;

architecture TB_BEH_COMB_PC_ADD of TB_PC_Adder is 

	COMPONENT PC_Adder IS
		GENERIC (IR_SIZE: integer := 32);	
		Port (	
			A			:	IN	std_logic_vector (IR_SIZE - 1 DOWNTO 0);
			Y			: 	OUT	std_logic_vector (IR_SIZE - 1 DOWNTO 0));
	END COMPONENT;
	
	CONSTANT tb_IR_SIZE : INTEGER := 32;
	SIGNAL TB_A  : STD_LOGIC_VECTOR(tb_IR_SIZE - 1 DOWNTO 0);
	SIGNAL TB_Y  : STD_LOGIC_VECTOR(tb_IR_SIZE - 1 DOWNTO 0);	

begin
	DUT_PC_Adder: PC_Adder
	 GENERIC MAP(IR_SIZE => tb_IR_SIZE)
	 PORT MAP(
		A => tb_A,
		Y => tb_Y);

		process
		begin
			tb_A <= (OTHERS => '0'); 
			WAIT FOR 5 NS; 

			tb_A <= std_logic_vector(to_unsigned(4, tb_IR_SIZE)); 
			WAIT FOR 5 NS; 

			tb_A <= std_logic_vector(to_unsigned(160, tb_IR_SIZE)); 
			WAIT FOR 5 NS; 

			tb_A <= (OTHERS => '1'); 
			WAIT FOR 5 NS; 
			
		end process;
	

end TB_BEH_COMB_PC_ADD;


