-- Code reused from ex2.1.4 of Lab2. 

library IEEE;
use IEEE.std_logic_1164.all;

package  rf_pkg is

  function log2(num : integer) return integer;

end package  rf_pkg;


package body  rf_pkg is

  -- log2()
  -- @Description: Calculates the logarithm in base 2 of the arugment
  -- @params:
  --    num : integer => argument of the logarithm
  function log2(num : integer) return integer is
    variable i : integer := 0;
    variable current_num : integer := num;
  begin

    while current_num > 1 loop
      current_num := current_num / 2;
      i := i + 1;
    end loop;

    return i;
  end function log2;
end package body; 