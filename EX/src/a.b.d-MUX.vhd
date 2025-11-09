library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity NBit_2to1MUX is
  generic (N : integer := 1);
  port (
    A, B : in std_logic_vector(N-1 downto 0);
    S    : in std_logic;
    Y    : out std_logic_vector(N-1 downto 0));
end NBit_2to1MUX;

architecture BEH_NBit_2to1MUX of NBit_2to1MUX is
begin
  Y <= A when (S = '1') else B;
end BEH_NBit_2to1MUX;
