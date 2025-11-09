library IEEE;
use IEEE.std_logic_1164.all; 
--use IEEE.std_logic_signed.all; -- deprecated!
use IEEE.NUMERIC_STD.all; 
use work.myTypes.all;

entity TB_ALU is
end TB_ALU;

architecture TB_BEH_COMB of TB_ALU is 

	-- DUT Component Declaration
	COMPONENT ALU IS
		GENERIC (IR_SIZE: integer := 32);
		Port (	
			A			:	IN	std_logic_vector (IR_SIZE-1 DOWNTO 0);
			B			: 	IN 	std_logic_vector (IR_SIZE-1 DOWNTO 0);
			ALU_OPCODE	: 	IN  aluOp;
			Y			: 	OUT	std_logic_vector (IR_SIZE-1 DOWNTO 0));
	END COMPONENT;

		CONSTANT tb_IR_SIZE : INTEGER := 32;
		SIGNAL tb_A : STD_LOGIC_VECTOR(tb_IR_SIZE - 1 DOWNTO 0); 
		SIGNAL tb_B : STD_LOGIC_VECTOR(tb_IR_SIZE - 1 DOWNTO 0); 
		SIGNAL tb_ALU_OPCODE : aluOp; 
		SIGNAL tb_Y : STD_LOGIC_VECTOR(tb_IR_SIZE - 1 DOWNTO 0); 		
		

begin

	ALU_inst: entity work.ALU
	 GENERIC MAP(IR_SIZE => tb_IR_SIZE)
	 PORT MAP(
		A => tb_A,
		B => tb_B,
		ALU_OPCODE => tb_ALU_OPCODE,
		Y => tb_Y);


	process
	begin

		-- Prepping Input Operands
		tb_A <= std_logic_vector(to_unsigned(85, tb_IR_SIZE));
		tb_B <= std_logic_vector(to_unsigned(170, tb_IR_SIZE));
		tb_ALU_OPCODE <= NOP; 
		WAIT FOR 5 ns; 

		-- ADDITION TEST
		tb_ALU_OPCODE <= ADD_op;
		WAIT FOR 5 ns; 

		-- SUBTRACTION TEST
		tb_ALU_OPCODE <= SUB_op;
		WAIT FOR 5 ns; 

		-- BITWISE TESTS
		tb_ALU_OPCODE <= AND_op;
		WAIT FOR 5 ns; 
		tb_ALU_OPCODE <= OR_op;
		WAIT FOR 5 ns; 
		tb_ALU_OPCODE <= XOR_op;
		WAIT FOR 5 ns; 

		-- SHIFT TESTS
		tb_ALU_OPCODE <= SRL_op;
		WAIT FOR 5 ns; 
		tb_ALU_OPCODE <= SLL_op;
		WAIT FOR 5 ns; 

		-- COMPARISON TESTS
		tb_ALU_OPCODE <= SGE_op;
		WAIT FOR 5 ns; 		
		tb_ALU_OPCODE <= SLE_op;
		WAIT FOR 5 ns; 	
		tb_ALU_OPCODE <= SNE_op;
		WAIT; 		

	END PROCESS;

end TB_BEH_COMB;


