library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-- Instruction memory for DLX
-- Memory filled by a process which reads from a file
entity IRAM is
  generic (
            RAM_DEPTH : integer := 48;
            I_SIZE : integer := 32);
  port (
         nRst      : in  std_logic;
         Addr      : in  std_logic_vector(I_SIZE-1 downto 0);
         Dout      : out std_logic_vector(I_SIZE-1 downto 0)
       );

end IRAM;

architecture IRam_Bhe of IRAM is
  -- IRAM Signal
  type RAMtype is array (0 to RAM_DEPTH-1) of std_logic_vector(I_SIZE-1 downto 0);
  signal IRAM_mem : RAMtype;

  -- 1 when the process has finished loading firmware into the IRAM
  signal FIRMWARE_LOADED : std_logic := '0';

  -- 1 when IRAM is ready to work
  signal IRAM_READY : std_logic := '0';

begin  -- IRam_Bhe

  IRAM_READY <= '1' when (nRst = '1' and FIRMWARE_LOADED = '1' and (not Is_X(Addr)))
                else '0';

  Dout <= IRAM_mem(to_integer(unsigned(Addr))) when IRAM_READY = '1'
          else (others => 'X');

  -- NOTE: Improved basic process, also refills missing NOPs that compiler strips away.
  -- purpose: This process is in charge of filling the Instruction RAM with the firmware
  -- type   : combinational
  -- inputs : Rst
  -- outputs: IRAM_mem
  FILL_MEM_P: process (nRst)

    -- Assembly file related constants
    file asm_fp : text;
    constant FILENAME_ASM_BASIC : string := "/home/dockeruser/DLX/DLX_PRO/programs/test.asm";   -- modified by script
    constant FILENAME_ASM_BASIC_LENGTH : integer := 14;          -- modified by script
    variable asm_line : line;
    variable asm_string : string(1 to 3);
    type type_nop_array is array(natural range 0 to FILENAME_ASM_BASIC_LENGTH-1) of std_logic;
    variable NopsArray : type_nop_array;

    -- Memory file related constants
    file mem_fp: text;
    constant FILENAME_MEM_BASIC : string := "/home/dockeruser/DLX/DLX_PRO/programs/test.bin.mem"; -- modified by script
    constant FILENAME_MEM_BASIC_LENGTH : integer := 6;                       -- modified by script
    variable file_line : line;
    variable tmp_data_u : std_logic_vector(I_SIZE-1 downto 0);

    variable mem_file_index : integer := 0;
    variable iram_index : integer := 0;
    variable nop_array_index : integer := 0;

  begin  -- process FILL_MEM_P
    if (nRst = '0') then

      file_open(asm_fp, FILENAME_ASM_BASIC, READ_MODE);
      LOOP_AsmFile: for i in 0 to FILENAME_ASM_BASIC_LENGTH-1 loop

        readline(asm_fp, asm_line);

        -- Skip comments and empty lines in the ASM program
        if asm_line.all'length = 0 or asm_line.all(1) = '#' then
          next LOOP_AsmFile; -- continue;
        end if;

        -- hread(asm_line, asm_data);
        asm_string := asm_line.all(1 to 3);

        -- if NOP encountered, set element to 1
        if asm_string = "nop" or asm_string = "NOP" then
          NopsArray(i) := '1';
        end if;

      end loop LOOP_AsmFile;
      file_close(asm_fp);


      file_open(mem_fp, FILENAME_MEM_BASIC, READ_MODE);
      LOOP_BasicFillMem: for l in 0 to FILENAME_MEM_BASIC_LENGTH-1 loop

        -- Read the line
        readline(mem_fp, file_line);

        -- Handle non-empty lines (both non-NOP instructions and single NOPs)
        if file_line.all'length /= 0 then
          -- Convert into data
          hread(file_line, tmp_data_u);
          -- Insert
          IRAM_mem(iram_index) <= tmp_data_u;
          -- Increment indexes
          mem_file_index := mem_file_index + 1;
          iram_index := iram_index + 1;
          nop_array_index := nop_array_index + 1;

        -- Handle empty lines: insert the streak of NOPs into IRAM
        else
          -- Insert NOP streak
          while nop_array_index < FILENAME_ASM_BASIC_LENGTH and
                NOPsArray(nop_array_index) = '1' loop

            IRAM_mem(iram_index) <= X"54000000";
            iram_index := iram_index + 1;
            nop_array_index := nop_array_index + 1;
          end loop;

          mem_file_index := mem_file_index + 1;
        end if;

      end loop LOOP_BasicFillMem;
      file_close(mem_fp);

      -- When firmware is loaded into IRAM, start outputting values (avoid metavalues)
      FIRMWARE_LOADED <= '1';
    end if;

  end process FILL_MEM_P;

end IRam_Bhe;


