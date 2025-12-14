library ieee;
  use ieee.std_logic_1164.all;

library work;
  use work.rf_pkg.log2; -- import log2()

package myTypes is

  -- Number of ALU Opcodes
  -- constant NUM_ALU_OPCODES : integer := log2(21);
  constant NUM_ALU_OPCODES : integer := 5;

  -- These are all the possible operations the ALU can perform given the Instruction Set that is to be implemented.
  type aluOp is (
    -- DLX Basic Version ALU Opcodes
    NOP,    -- 0 No Operation
    ADD_op, -- 1 Signed Addition
    AND_op, -- 2 Bitwise
    OR_op,  -- 3 Bitwise
    SGE_op, -- 4 Set Greater than or Equal to
    SLE_op, -- 5 Set Less than or Equal to
    SLL_op, -- 6 Unsigned Logical Shift Left
    SNE_op, -- 7 Set Not Equal to
    SRL_op, -- 8 Unsigned Arithmetic Shift Right
    SUB_op, -- 9 Signed Subtraction
    XOR_op, -- 10 Bitwise

    -- DLX Pro Version ALU Opcodes
    SRA_op,  -- 11 Shift Right Arithmetic
    ADDU_op, -- 12 Unsigned Addition
    SUBU_op, -- 13 Unsigned Subtraction
    SEQ_op,  -- 14 Set if Equal
    SLT_op,  -- 15 Set if Less Than
    SGT_op,  -- 16 Set Greater Than
    SLTU_op, -- 17 Set if Less Than (Unsigned)
    SGTU_op, -- 28 Set Greater Than (Unsigned)
    SLEU_op, -- 19 Set if Less Than or Equal (Unsigned)
    SGEU_op  -- 20 Set Greater Than or Equal (Unsigned)
  );

end package myTypes;

