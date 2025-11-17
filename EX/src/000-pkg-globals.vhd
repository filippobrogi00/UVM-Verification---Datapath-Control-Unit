library ieee;
use ieee.std_logic_1164.all;

package myTypes is

    -- Constant encodings for ALU operations
    constant NOP     : integer := 0;
    constant ADD_op  : integer := 1;
    constant AND_op  : integer := 3;
    constant OR_op   : integer := 4;
    constant SGE_op  : integer := 5;
    constant SLE_op  : integer := 6;
    constant SLL_op  : integer := 7;
    constant SNE_op  : integer := 8;
    constant SRL_op  : integer := 9;
    constant SUB_op  : integer := 10;
    constant XOR_op  : integer := 11;

    -- DLX Pro Version
    constant SRA_op  : integer := 112;
    constant ADDU_op : integer := 13;
    constant SUBU_op : integer := 14;
    constant SEQ_op  : integer := 15;
    constant SLT_op  : integer := 16;
    constant SGT_op  : integer := 17;
    constant SLTU_op : integer := 18;
    constant SGTU_op : integer := 19;
    constant SLEU_op : integer := 20;
    constant SGEU_op : integer := 21;

end myTypes;

