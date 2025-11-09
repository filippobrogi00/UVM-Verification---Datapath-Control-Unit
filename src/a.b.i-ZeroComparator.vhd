library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity ZeroCompa is
  generic (
    IR_SIZE : integer := 32
  );
  port (
    NUMtoCHECK : in    std_logic_vector(IR_SIZE - 1 downto 0);
    EQZ        : in    std_logic;                -- EQZ = 1 -> Checks if input is equal to '0'; EQZ = 0 -> Checks if input is not equal to '0'.
    JMP        : in    std_logic;
    RESULT     : out   std_logic
  );
end entity ZeroCompa;

architecture BEH_COMB of ZeroCompa is

begin

  RESULT <= '1' when (JMP = '1') else
            '1' when ((NUMtoCHECK = std_logic_vector(to_unsigned(0, IR_SIZE)) and (EQZ = '1'))) else
            '1' when ((NUMtoCHECK /= std_logic_vector(to_unsigned(0, IR_SIZE)) and (EQZ = '0'))) else
            '0';

end architecture BEH_COMB;


