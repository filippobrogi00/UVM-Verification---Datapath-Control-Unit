library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.all; 
use work.myTypes.all;

entity ALU is

	GENERIC (IR_SIZE: integer := 32);
	Port (	
    	A			:	IN	std_logic_vector (IR_SIZE-1 DOWNTO 0);
		B			: 	IN 	std_logic_vector (IR_SIZE-1 DOWNTO 0);
		ALU_OPCODE	: 	IN  aluOp;
		Y			: 	OUT	std_logic_vector (IR_SIZE-1 DOWNTO 0));

end ALU;

architecture BEH_COMB of ALU is 

	constant N : INTEGER := 32;
	
	COMPONENT SHIFTER_GENERIC is
	generic(N: integer := 32);
	port(	A: in std_logic_vector(N-1 downto 0);
			B: in std_logic_vector(4 downto 0);
			LOGIC_ARITH: in std_logic;	-- 1 = logic, 0 = arith
			LEFT_RIGHT: in std_logic;	-- 1 = left, 0 = right
			SHIFT_ROTATE: in std_logic;	-- 1 = shift, 0 = rotate
			RESULT: out std_logic_vector(N-1 downto 0));
	END COMPONENT; 

	SIGNAL LOGIC_ARITH_shftr : STD_LOGIC;
	SIGNAL LEFT_RIGHT_shftr : STD_LOGIC;
	SIGNAL SHIFT_ROTATE_shftr : STD_LOGIC;
	SIGNAL RESULT_shftr : std_logic_vector(N-1 downto 0);

begin
	
	LOGIC_ARITH_shftr <= '1' WHEN ALU_OPCODE = SLL_op ELSE
            			 '1' WHEN ALU_OPCODE = SRL_op ELSE
            			 '0' WHEN ALU_OPCODE = SRA_op ELSE   -- Pro Version Instruction (SRA)
            			 'Z';

	LEFT_RIGHT_shftr <=  '1' WHEN ALU_OPCODE = SLL_op ELSE
            			 '0' WHEN ALU_OPCODE = SRL_op ELSE
            			 '0' WHEN ALU_OPCODE = SRA_op ELSE   -- Pro Version Instruction (SRA)
            			 'Z';

	SHIFT_ROTATE_shftr <='1' WHEN ALU_OPCODE = SLL_op ELSE
            			 '1' WHEN ALU_OPCODE = SRL_op ELSE
            			 '1' WHEN ALU_OPCODE = SRA_op ELSE   -- Pro Version Instruction (SRA)
            			 'Z';


shifter: SHIFTER_GENERIC
	GENERIC MAP (N => N)
	port map (
        A 				=> A,
		B 				=> B(4 DOWNTO 0),
		LOGIC_ARITH		=> LOGIC_ARITH_shftr,
		LEFT_RIGHT		=> LEFT_RIGHT_shftr,
		SHIFT_ROTATE	=> SHIFT_ROTATE_shftr,
		RESULT			=> RESULT_shftr);


	process (A, B, ALU_OPCODE, RESULT_shftr)
	begin
		case ALU_OPCODE is 	
		-- *** DLX Basic Version Operations: *** 
			-- Addition - Straightforward implementation
			WHEN ADD_op => Y <= std_logic_vector(signed(A) + signed(B));

			-- Substraction - Straightforward implementation
			WHEN SUB_op => Y <= std_logic_vector(signed(A) - signed(B));
			
			-- Bitwise Operations
			WHEN AND_op => Y <= A AND B; 
			WHEN OR_op 	=> Y <= A OR B; 
			WHEN XOR_op => Y <= A XOR B;

			-- Shift Operations  
			WHEN SLL_op => Y <= RESULT_shftr;        -- Shift Left Logical
			WHEN SRL_op => Y <= RESULT_shftr;        -- Shift Right Logical
			WHEN SRA_op => Y <= RESULT_shftr;        -- Shift Right Arithmetic (Pro Version Instruction)

			-- Comparison Operations
			WHEN SGE_op =>
					if signed(A) >= signed(B) THEN 
						Y <= std_logic_vector(to_unsigned(1, IR_SIZE)); 
					ELSE
						Y <= (OTHERS => '0');
					END IF; 

			WHEN SLE_op =>
					if signed(A) <= signed(B) THEN 
						Y <= std_logic_vector(to_unsigned(1, IR_SIZE)); 
					ELSE
						Y <= (OTHERS => '0');
					END IF;					

			WHEN SNE_op =>
					if signed(A) /= signed(B) THEN 
						Y <= std_logic_vector(to_unsigned(1, IR_SIZE)); 
					ELSE
						Y <= (OTHERS => '0');
					END IF;
					
			-- NOP 
			WHEN NOP => Y <= (OTHERS => 'Z'); 
			
		-- @@@ DLX Pro Version Operations: @@@ 
		
		    -- ADDUI - Straightforward Implementation
		    WHEN ADDU_op => Y <= std_logic_vector(unsigned(A) + unsigned(B));
		    
		    -- SUBUI - Straightforward Implementation
		    WHEN SUBU_op => Y <= std_logic_vector(unsigned(A) - unsigned(B));
		    
		    -- SEQ
		    WHEN SEQ_op => 
		            if signed(A) = signed(B) THEN 
						Y <= std_logic_vector(to_unsigned(1, IR_SIZE)); 
					ELSE
						Y <= (OTHERS => '0');
					END IF;
		    
		    -- SLT
		    WHEN SLT_op =>
					if signed(A) < signed(B) THEN 
						Y <= std_logic_vector(to_unsigned(1, IR_SIZE)); 
					ELSE
						Y <= (OTHERS => '0');
					END IF;
		    
		    -- SGT
		    WHEN SGT_op =>
					if signed(A) > signed(B) THEN 
						Y <= std_logic_vector(to_unsigned(1, IR_SIZE)); 
					ELSE
						Y <= (OTHERS => '0');
					END IF;		    
		    
		    -- SLTU
		    WHEN SLTU_op =>
					if unsigned(A) < unsigned(B) THEN 
						Y <= std_logic_vector(to_unsigned(1, IR_SIZE)); 
					ELSE
						Y <= (OTHERS => '0');
					END IF;
		    
		    -- SGTU
		    WHEN SGTU_op =>
					if unsigned(A) > unsigned(B) THEN 
						Y <= std_logic_vector(to_unsigned(1, IR_SIZE)); 
					ELSE
						Y <= (OTHERS => '0');
					END IF;	
						    
		    -- SLEU
		    WHEN SLEU_op =>
					if unsigned(A) <= unsigned(B) THEN 
						Y <= std_logic_vector(to_unsigned(1, IR_SIZE)); 
					ELSE
						Y <= (OTHERS => '0');
					END IF;		    
		    
		    -- SGEU
			WHEN SGEU_op =>
					if unsigned(A) >= unsigned(B) THEN 
						Y <= std_logic_vector(to_unsigned(1, IR_SIZE)); 
					ELSE
						Y <= (OTHERS => '0');
					END IF;		    		
			
			WHEN OTHERS => Y <= (OTHERS => 'Z'); 
		END CASE;
	 

	end process;
	

end BEH_COMB;


