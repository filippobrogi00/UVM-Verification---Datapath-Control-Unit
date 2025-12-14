library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package myTypes is
	
    -- 5-bit ALU operation type
    subtype aluOp is std_logic_vector(4 downto 0);

    -- Constant encodings for ALU operations (as aluOp values)
    constant NOP     : aluOp := std_logic_vector(to_unsigned(0, 5));
    constant ADD_op  : aluOp := std_logic_vector(to_unsigned(1, 5));
    constant AND_op  : aluOp := std_logic_vector(to_unsigned(3, 5));
    constant OR_op   : aluOp := std_logic_vector(to_unsigned(4, 5));
    constant SGE_op  : aluOp := std_logic_vector(to_unsigned(5, 5));
    constant SLE_op  : aluOp := std_logic_vector(to_unsigned(6, 5));
    constant SLL_op  : aluOp := std_logic_vector(to_unsigned(7, 5));
    constant SNE_op  : aluOp := std_logic_vector(to_unsigned(8, 5));
    constant SRL_op  : aluOp := std_logic_vector(to_unsigned(9, 5));
    constant SUB_op  : aluOp := std_logic_vector(to_unsigned(10, 5));
    constant XOR_op  : aluOp := std_logic_vector(to_unsigned(11, 5));

    -- DLX Pro Version
    constant SRA_op  : aluOp := std_logic_vector(to_unsigned(12, 5));
    constant ADDU_op : aluOp := std_logic_vector(to_unsigned(13, 5));
    constant SUBU_op : aluOp := std_logic_vector(to_unsigned(14, 5));
    constant SEQ_op  : aluOp := std_logic_vector(to_unsigned(15, 5));
    constant SLT_op  : aluOp := std_logic_vector(to_unsigned(16, 5));
    constant SGT_op  : aluOp := std_logic_vector(to_unsigned(17, 5));
    constant SLTU_op : aluOp := std_logic_vector(to_unsigned(18, 5));
    constant SGTU_op : aluOp := std_logic_vector(to_unsigned(19, 5));
    constant SLEU_op : aluOp := std_logic_vector(to_unsigned(20, 5));
    constant SGEU_op : aluOp := std_logic_vector(to_unsigned(21, 5));

end myTypes;

