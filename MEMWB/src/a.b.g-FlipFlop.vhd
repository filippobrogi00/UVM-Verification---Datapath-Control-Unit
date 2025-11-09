library IEEE;
use IEEE.std_logic_1164.all; 

entity NBit_Reg is
	GENERIC (N: integer := 4); 
	Port (	
		CLK      :	In	std_logic;
		nRST	 :	In	std_logic; -- ACTIVE LOW RESET
		LD_EN 	 : 	IN 	std_logic; 
    	D        :	In	std_logic_vector (N-1 DOWNTO 0);
		Q        :	Out	std_logic_vector (N-1 DOWNTO 0)
  );
end NBit_Reg;

architecture BEH_NBit_Reg of NBit_Reg is -- flip flop D with syncronous reset
begin
	PSYNCH: process(CLK)
	begin
	  if rising_edge(CLK) then -- positive edge triggered:
	    if nRST = '0' then  
	      Q <= (OTHERS => '0'); 
	    elsif (LD_EN = '1') then
	      Q <= D; -- input is written on output	      
	    end if;
	  end if;
	end process; 
end BEH_NBit_Reg;