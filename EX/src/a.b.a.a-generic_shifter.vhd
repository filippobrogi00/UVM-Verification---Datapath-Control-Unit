library IEEE;
use IEEE.std_logic_1164.all;
-- use IEEE.std_logic_arith.all; -- DEPRECATED!
-- use IEEE.std_logic_unsigned.all; -- DEPRECATED!
use IEEE.NUMERIC_STD.all;
--use WORK.all; -- Not sure where this folder is exactly.


entity SHIFTER_GENERIC is
	generic(N: integer := 32);
	port(	A: in std_logic_vector(N-1 downto 0);
			B: in std_logic_vector(4 downto 0);
			LOGIC_ARITH: in std_logic;	-- 1 = logic, 0 = arith
			LEFT_RIGHT: in std_logic;	-- 1 = left, 0 = right
			SHIFT_ROTATE: in std_logic;	-- 1 = shift, 0 = rotate
			RESULT: out std_logic_vector(N-1 downto 0)
	);

end entity SHIFTER_GENERIC;


architecture BEHAVIORAL of SHIFTER_GENERIC is

begin
	SHIFT: process (A, B, LOGIC_ARITH, LEFT_RIGHT, SHIFT_ROTATE) is
	begin
	
		if SHIFT_ROTATE = '0' then 		-- '0' means ROTATE 
			if LEFT_RIGHT = '0' then	-- '0' means RIGHT
				RESULT <= std_logic_vector(rotate_right(unsigned(A), to_integer(unsigned(B)))); 
			else						-- '1' means LEFT
				RESULT <= std_logic_vector(rotate_left(unsigned(A), to_integer(unsigned(B))));
			end if;
			
		else							-- '1' means SHIFT
		
			if LEFT_RIGHT = '0' then	-- '0' means RIGHT
				if LOGIC_ARITH = '0' then	-- '0' means ARITHMETIC
					RESULT <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B))));
				else					-- '1' means LOGICAL
					RESULT <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))));
				end if;				
				
			else                        -- '1' means LEFT
				if LOGIC_ARITH = '0' then	-- '0' means ARITHMETIC 
					RESULT <= std_logic_vector(shift_left(signed(A), to_integer(unsigned(B))));
				else					-- '1' means LOGICAL 
					RESULT <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B))));
				end if;
			end if;
			
		end if;
		
	end process;
end architecture BEHAVIORAL;



