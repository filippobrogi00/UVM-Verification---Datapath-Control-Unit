-- vhdl-linter-disable type-resolved

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.rf_pkg.all; -- Needed for "log2()" function.

entity gen_register_file is
  generic (
    RF_regBits : integer := 32;
    RF_numRegs : integer := 32
  );
  port (
    -- INPUTS
    CLK     : in    std_logic;
    nRST    : in    std_logic;                                       -- ACTIVE LOW RESET!
    ENABLE  : in    std_logic;
    RD1     : in    std_logic;
    RD2     : in    std_logic;                                       -- Read Enable signals
    ADD_RD1 : in    std_logic_vector(log2(RF_numRegs) - 1 downto 0);
    ADD_RD2 : in    std_logic_vector(log2(RF_numRegs) - 1 downto 0); -- Read Addresses

    -- Write operation
    WR     : in    std_logic;                                       -- Write Enable signal
    ADD_WR : in    std_logic_vector(log2(RF_numRegs) - 1 downto 0); -- Write Address
    DATAIN : in    std_logic_vector(RF_regBits - 1 downto 0);       -- Data to write

    -- OUTPUTS
    OUT1 : out   std_logic_vector(RF_regBits - 1 downto 0);
    OUT2 : out   std_logic_vector(RF_regBits - 1 downto 0)
  );
end entity gen_register_file;

architecture beh of gen_register_file is

  -- Following structures were provided from professor.

  subtype REG_ADDR is natural range 0 to (RF_numRegs - 1); -- using natural type. Indirizzo del registro.

  type   REG_ARRAY is array(REG_ADDR) of std_logic_vector((RF_regBits - 1) downto 0); -- Array of REG_ADDR elements where each element is 64 bits.
  signal REGISTERS : REG_ARRAY;                                                       -- Signal of type REG_ARRAY. This is the Register File.

begin

  ClkProc : process (CLK) is
  begin

    if rising_edge(CLK) then
      -- Reset
      if (nRST = '0') then

        for addr in 0 to (RF_numRegs - 1) loop
          REGISTERS(addr) <= (others => '0');
        end loop;

        OUT1 <= (others => '0');
        OUT2 <= (others => '0');
      end if;

      -- Operation
      -- NOTE: Disable coverage because ENABLE hardwired to 1
      -- coverage off bsc
      if ((ENABLE = '1') and (nRST = '1')) then
        -- coverage on bsc
        -- Write
        -- NOTE: Writing to R0 not allowed in DLX architecture!
        if ((WR = '1') and (unsigned(ADD_WR) /= 0)) then
          REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN;
        end if;

        -- Read from port 1
        -- NOTE: Disable coverage since RD1, RD2 hardwired to 1
        -- coverage off cbs
        if (RD1 = '1') then
          OUT1 <= REGISTERS(to_integer(unsigned(ADD_RD1)));
        end if;

        -- Read from port 2
        if (RD2 = '1') then
          OUT2 <= REGISTERS(to_integer(unsigned(ADD_RD2)));
        end if;
      -- coverage on cbs
      end if;

    end if;

  end process ClkProc;

end architecture beh;
