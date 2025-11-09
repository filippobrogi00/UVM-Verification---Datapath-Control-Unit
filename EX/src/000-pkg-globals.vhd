library ieee;
use ieee.std_logic_1164.all;

package myTypes is

    -- These are all the possible operations the ALU can perform given the Instruction Set that is to be implemented.
	type aluOp is (
	        -- DLX Basic Version ALU Opcodes
			NOP,
			ADD_op,   -- Signed Addition
			AND_op,   -- Bitwise
			OR_op,    -- Bitwise
			SGE_op,   -- Set Greater than or Equal to
			SLE_op,   -- Set Less than or Equal to
			SLL_op,   -- Unsigned Logical Shift Left
			SNE_op,   -- Set Not Equal to
			SRL_op,   -- Unsigned Arithmetic Shift Right
			SUB_op,   -- Signed Subtraction
			XOR_op,   -- Bitwise

			-- DLX Pro Version ALU Opcodes
			SRA_op,   -- Shift Right Arithmetic
			ADDU_op,  -- Unsigned Addition
			SUBU_op,  -- Unsigned Subtraction
			SEQ_op,   -- Set if Equal
			SLT_op,   -- Set if Less Than
			SGT_op,   -- Set Greater Than
			SLTU_op,  -- Set if Less Than (Unsigned)
			SGTU_op,  -- Set Greater Than (Unsigned)
			SLEU_op,  -- Set if Less Than or Equal (Unsigned)
			SGEU_op); -- Set Greater Than or Equal (Unsigned)
end myTypes;

