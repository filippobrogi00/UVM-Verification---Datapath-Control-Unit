library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all; -- DEPRECATED!
use ieee.numeric_std.all;
use work.myTypes.all;

-- Data memory for DLX
entity TB_CU is
end TB_CU;

architecture TB_CU_Bhe of TB_CU is

-- Function provided from Copilot to turn std_logic_vector into string for reporting purposes: 
    function to_string(slv : std_logic_vector) return string is
        variable result : string(1 to slv'length);
    begin
        for i in slv'range loop
            result(i - slv'low + 1) := character'VALUE(std_ulogic'IMAGE(slv(i)));
        end loop;
        return result;
    end function;

component dlx_cu is
  generic (
    MICROCODE_MEM_SIZE :     integer := 44;  -- Microcode Memory Size. Included all Instructions DLX will be able to execute and not.
    FUNC_SIZE          :     integer := 11;  -- Func Field Size for R-Type Ops
    OP_CODE_SIZE       :     integer := 6;  -- Op Code Size
    -- ALU_OPC_SIZE       :     integer := 6;  -- ALU Op Code Word Size
    IR_SIZE            :     integer := 32;  -- Instruction Register Size    
    CW_SIZE            :     integer := 18);  -- Control Word Size. Added new Control Signals.

  port (
    Clk                : in  std_logic;  -- Clock
    nRst                : in  std_logic;  -- Reset:Active-Low
    
    -- Instruction Register
    IR_IN              : in  std_logic_vector(IR_SIZE - 1 downto 0);
    
    -- Debug Signals
    DBG_CW_OUT         : OUT  std_logic_vector(CW_SIZE - 1 downto 0);
    
    -- IF Control Signal - STAGE 1
    IR_LATCH_EN        : out std_logic;  -- Instruction Register Latch Enable
    NPC_LATCH_EN       : out std_logic;  -- NextProgramCounter Register Latch Enable

    -- ID Control Signals - STAGE 2
    RegA_LATCH_EN      : out std_logic;  -- Register A Latch Enable
    RegB_LATCH_EN      : out std_logic;  -- Register B Latch Enable
    RegIMM_LATCH_EN    : out std_logic;  -- Immediate Register Latch Enable
    JAL_EN	           : out std_logic;  -- Control Signal for Jump and Link Instruction

    -- EX Control Signals - STAGE 3
    MUXA_SEL           : out std_logic;  -- MUX-A Sel
    MUXB_SEL           : out std_logic;  -- MUX-B Sel
    ALU_OUTREG_EN      : out std_logic;  -- ALU Output Register Enable
    EQ_COND            : out std_logic;  -- Branch if (not) Equal to Zero
    JMP 	             : out std_logic;  -- Control Signal for unconditional Jump Instructions.
    EQZ_NEQZ	         : out std_logic;  -- Control Signal for bnez Instruction ('0') and beqz Instruction ('1'). 

    -- ALU Operation Code
    ALU_OPCODE         : out aluOp; -- choose between implicit or exlicit coding, like std_logic_vector(ALU_OPC_SIZE -1 downto 0);
    
    -- MEM Control Signals - STAGE 4
    DRAM_WE            : out std_logic;  -- Data RAM Write Enable
    LMD_LATCH_EN       : out std_logic;  -- LMD Register Latch Enable
    JUMP_EN            : out std_logic;  -- JUMP Enable Signal for PC input MUX
    PC_LATCH_EN        : out std_logic;  -- Program Counte Latch Enable

    -- WB Control signals - STAGE 5
    WB_MUX_SEL         : out std_logic;  -- Write Back MUX Sel
    RF_WE              : out std_logic);  -- Register File Write Enable
    
end component;
    
    -- Constants
	CONSTANT tb_MICROCODE_MEM_SIZE : INTEGER := 44;	
	CONSTANT tb_FUNC_SIZE : INTEGER := 11;
	CONSTANT tb_OP_CODE_SIZE : INTEGER := 6;
	CONSTANT tb_IR_SIZE : INTEGER := 32;
	CONSTANT tb_CW_SIZE : INTEGER := 18;	
	
	-- Main input signals.
	SIGNAL tb_Clk : STD_LOGIC;
	SIGNAL tb_nRst : STD_LOGIC;
	SIGNAL tb_IR_IN : std_logic_vector(tb_IR_SIZE - 1 DOWNTO 0);
	
	-- Debug signals
	SIGNAL tb_DBG_CW_OUT : std_logic_vector(tb_CW_SIZE - 1 DOWNTO 0);
	
	-- Control Signals: STAGE 1 
	SIGNAL tb_IR_LATCH_EN : STD_LOGIC;
	SIGNAL tb_NPC_LATCH_EN : STD_LOGIC;
	
	-- Control Signals: STAGE 2
	SIGNAL tb_RegA_LATCH_EN : STD_LOGIC;
	SIGNAL tb_RegB_LATCH_EN : STD_LOGIC;
	SIGNAL tb_RegIMM_LATCH_EN : STD_LOGIC;
	SIGNAL tb_JAL_EN : STD_LOGIC;
	
	-- Control Signals: STAGE 3
	SIGNAL tb_MUXA_SEL : STD_LOGIC;
	SIGNAL tb_MUXB_SEL : STD_LOGIC;
	SIGNAL tb_ALU_OUTREG_EN : STD_LOGIC;
	SIGNAL tb_EQ_COND : STD_LOGIC;
	SIGNAL tb_JMP : STD_LOGIC;
	SIGNAL tb_EQZ_NEQZ : STD_LOGIC;
	
	-- Control Signals: STAGE 4
	SIGNAL tb_DRAM_WE : STD_LOGIC;
	SIGNAL tb_LMD_LATCH_EN : STD_LOGIC;
	SIGNAL tb_JUMP_EN : STD_LOGIC;
	SIGNAL tb_PC_LATCH_EN : STD_LOGIC;
	
    -- Control Signals: STAGE 5
    SIGNAL tb_WB_MUX_SEL : STD_LOGIC;
    SIGNAL tb_RF_WE : STD_LOGIC;
    
    -- Other signals
    SIGNAL tb_ALU_OPCODE : aluOp;
    SIGNAL tb_CU_OUT    : STD_LOGIC_VECTOR(17 DOWNTO 0); 

begin

	tb_CU: dlx_cu
    generic map (
        MICROCODE_MEM_SIZE => tb_MICROCODE_MEM_SIZE,
        FUNC_SIZE          => tb_FUNC_SIZE,
        OP_CODE_SIZE       => tb_OP_CODE_SIZE,
        IR_SIZE            => tb_IR_SIZE,
        CW_SIZE            => tb_CW_SIZE
    )
    port map (
        Clk             => tb_Clk,
        nRst             => tb_nRst,
        IR_IN           => tb_IR_IN,
        DBG_CW_OUT      => tb_DBG_CW_OUT,

        -- STAGE 1
        IR_LATCH_EN     => tb_IR_LATCH_EN,
        NPC_LATCH_EN    => tb_NPC_LATCH_EN,

        -- STAGE 2
        RegA_LATCH_EN   => tb_RegA_LATCH_EN,
        RegB_LATCH_EN   => tb_RegB_LATCH_EN,
        RegIMM_LATCH_EN => tb_RegIMM_LATCH_EN,
        JAL_EN          => tb_JAL_EN,

        -- STAGE 3
        MUXA_SEL        => tb_MUXA_SEL,
        MUXB_SEL        => tb_MUXB_SEL,
        ALU_OUTREG_EN   => tb_ALU_OUTREG_EN,
        EQ_COND         => tb_EQ_COND,
        JMP             => tb_JMP,
        EQZ_NEQZ        => tb_EQZ_NEQZ,

        -- ALU Opcode
        ALU_OPCODE      => tb_ALU_OPCODE, 

        -- STAGE 4
        DRAM_WE         => tb_DRAM_WE,
        LMD_LATCH_EN    => tb_LMD_LATCH_EN,
        JUMP_EN         => tb_JUMP_EN,
        PC_LATCH_EN     => tb_PC_LATCH_EN,

        -- STAGE 5
        WB_MUX_SEL      => tb_WB_MUX_SEL,
        RF_WE           => tb_RF_WE);

        -- Signal Used for Assert Statement
        tb_CU_OUT <= tb_DBG_CW_OUT; 

        -- Clock Process from Copilot.
        clk_process : process
        begin
        while true loop
            tb_clk <= '0';
            wait for 1 ns;
            tb_clk <= '1';
            wait for 1 ns;
        end loop;
        end process; 

		vec_process: process
		-- NOTE! The "OP-CODE" is the first six Most Significant Bits of the Instruction!
		begin
			tb_nRst <= '0'; 
			WAIT FOR 4 ns; 

			-- Disable reset: 
			tb_nRst <= '1';
			
			-- 'j' Instruction (OP-CODE = 0x02) 
			tb_IR_IN <= X"0800000c"; 
			WAIT FOR 2 ns;
            assert tb_CU_OUT = "110010011110001100" -- change LSB back to '0'
                report "Output mismatch: expected 110010011110001100 but actual Output is: " & to_string(tb_CU_OUT);  
                 
			-- 'jal' Instruction (OP-CODE = 0x03)
			tb_IR_IN <= X"0c000008"; 
			WAIT FOR 2 ns;
			assert tb_CU_OUT = "110011011110001101"
                report "Output mismatch: expected 110011011110001101 but actual Output is: " & to_string(tb_CU_OUT);
			 
			-- 'beqz' Instruction (OP-CODE = 0x04)
			tb_IR_IN <= X"10200014"; 
			WAIT FOR 2 ns;			
			assert tb_CU_OUT = "111010011101001100"
                report "Output mismatch: expected 111010011101001100 but actual Output is: " & to_string(tb_CU_OUT);
    
			-- 'bnez' Instruction (OP-CODE = 0x05)
			tb_IR_IN <= X"14200020"; 
			WAIT FOR 2 ns;	
            assert tb_CU_OUT = "111010011100001100"
                report "Output mismatch: expected 111010011100001100 but actual Output is: " & to_string(tb_CU_OUT);

    	
			-- 'addi' Instruction (OP-CODE = 0x08)
			tb_IR_IN <= X"20410005"; 
			WAIT FOR 2 ns;			
			assert tb_CU_OUT = "101010111000000111"
                report "Output mismatch: expected 101010111000000111 but actual Output is: " & to_string(tb_CU_OUT);
			
			-- 'subi' Instruction (OP-CODE = 0x0a)
			tb_IR_IN <= X"28410005"; 
			WAIT FOR 2 ns;				
			assert tb_CU_OUT = "101010111000000111"
                report "Output mismatch: expected 101010111000000111 but actual Output is: " & to_string(tb_CU_OUT);
				
			-- 'andi' Instruction (OP-CODE = 0x0c)
			tb_IR_IN <= X"30410004"; 
			WAIT FOR 2 ns;				
			assert tb_CU_OUT = "101010111000000111"
                report "Output mismatch: expected 101010111000000111 but actual Output is: " & to_string(tb_CU_OUT);
			
			-- 'ori' Instruction (OP-CODE = 0x0d)
			tb_IR_IN <= X"34410004"; 
			WAIT FOR 2 ns;					
			assert tb_CU_OUT = "101010111000000111"
                report "Output mismatch: expected 101010111000000111 but actual Output is: " & to_string(tb_CU_OUT);
			
			-- 'xori' Instruction (OP-CODE = 0x0e)
			tb_IR_IN <= X"38410004"; 
			WAIT FOR 2 ns;			
			assert tb_CU_OUT = "101010111000000111"
                report "Output mismatch: expected 101010111000000111 but actual Output is: " & to_string(tb_CU_OUT);
				
			-- 'slli' Instruction (OP-CODE = 0x14)
			tb_IR_IN <= X"50410004"; 
			WAIT FOR 2 ns;			
			assert tb_CU_OUT = "101010111000000111"
                report "Output mismatch: expected 101010111000000111 but actual Output is: " & to_string(tb_CU_OUT);
				
			-- 'nop' Instruction (OP-CODE = 0x15)
			tb_IR_IN <= X"54000000"; 
			WAIT FOR 2 ns;			
			assert tb_CU_OUT = "000000000000000100"
                report "Output mismatch: expected 000000000000000100 but actual Output is: " & to_string(tb_CU_OUT);
				
			-- 'srli' Instruction (OP-CODE = 0x16)
			tb_IR_IN <= X"58410004"; 
			WAIT FOR 2 ns;				
			assert tb_CU_OUT = "101010111000000111"
                report "Output mismatch: expected 101010111000000111 but actual Output is: " & to_string(tb_CU_OUT);
			
			-- 'snei' Instruction (OP-CODE = 0x19)
			tb_IR_IN <= X"64410004"; 
			WAIT FOR 2 ns;			
			assert tb_CU_OUT = "101010111000000111"
                report "Output mismatch: expected 101010111000000111 but actual Output is: " & to_string(tb_CU_OUT);
				
			-- 'slei' Instruction (OP-CODE = 0x1c)
			tb_IR_IN <= X"70410004"; 
			WAIT FOR 2 ns;		
			assert tb_CU_OUT = "101010111000000111"
                report "Output mismatch: expected 101010111000000111 but actual Output is: " & to_string(tb_CU_OUT);
								
			-- 'sgei' Instruction (OP-CODE = 0x1d)
			tb_IR_IN <= X"74410004"; 
			WAIT FOR 2 ns;		
			assert tb_CU_OUT = "101010111000000111"
                report "Output mismatch: expected 101010111000000111 but actual Output is: " & to_string(tb_CU_OUT);
								
			-- 'lw' Instruction (OP-CODE = 0x23)
			tb_IR_IN <= X"8c410004"; 
			WAIT FOR 2 ns;			
			assert tb_CU_OUT = "101010111000010101"
                report "Output mismatch: expected 101010111000010101 but actual Output is: " & to_string(tb_CU_OUT);
							
			-- 'sw' Instruction (OP-CODE = 0x2b) 
			tb_IR_IN <= X"ac220014"; 
			WAIT FOR 2 ns;					
			assert tb_CU_OUT = "101110111000100100"
                report "Output mismatch: expected 101111011000100100 but actual Output is: " & to_string(tb_CU_OUT);
					
			-- R-Type Instruction (OP-CODE = 0x00)
			tb_IR_IN <= X"00430804"; 			               		
			WAIT FOR 2 ns; 
			assert tb_CU_OUT = "101100101000000111"
                report "Output mismatch: expected 101100101000000111 but actual Output is: " & to_string(tb_CU_OUT);
            WAIT; 
		end process;
		


end TB_CU_Bhe;
