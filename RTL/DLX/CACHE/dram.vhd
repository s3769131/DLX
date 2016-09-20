library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.MEM_pkg.all;

entity DRAM is
  generic(
    DRAM_FILEPATH_DUMP : string;
    DRAM_FILEPATH_INIT : string;
    DRAM_WORDSIZE      : integer := 32;
    DRAM_ENTRIES       : positive;
    DRAM_DUMPTIME      : time    := 1 us
  );
  port(
    DRAM_CLK          : in    std_logic;
    DRAM_RST          : in    std_logic;
    DRAM_ADDRESS      : in    std_logic_vector(log2ceil(DRAM_ENTRIES) - 1 downto 0);
    DRAM_ENABLE       : in    std_logic;
    DRAM_READNOTWRITE : in    std_logic;
    DRAM_DATA_READY   : out   std_logic;
    DRAM_INOUT_DATA   : inout std_logic_vector(DRAM_WORDSIZE - 1 downto 0)
  );
end entity DRAM;

architecture BHV of DRAM is
  signal DRAM : MEMORY_TYPE(DRAM_ENTRIES * DRAM_WORDSIZE / 8 - 1 downto 0, 7 downto 0) := initilize_mem_from_file(DRAM_ENTRIES, DRAM_WORDSIZE, DRAM_FILEPATH_INIT);

  signal tmp_data                  : std_logic_vector(DRAM_WORDSIZE - 1 downto 0);
  signal int_data_ready, mem_ready : std_logic;

begin
  --write_process
  WR_PROCESS : process(DRAM_CLK, DRAM_RST, DRAM, DRAM_ADDRESS, DRAM_ENABLE, DRAM_INOUT_DATA, DRAM_READNOTWRITE)
  begin                                 -- process
    if DRAM_RST = '0' then              -- asynchronous reset (active low)
      -- for index in 0 to DRAM_ENTRIES * DRAM_WORDSIZE / 8 - 1 loop
      --   for i in 0 to 7 loop
      --     DRAM(index, i) <= '0';
      --   end loop;
      -- end loop;

      int_data_ready <= '0';
      mem_ready      <= '0';

    -- elsif DRAM_CLK'event and DRAM_CLK = '1' then -- rising clock edge
    elsif (DRAM_ENABLE = '1') then
      if (DRAM_READNOTWRITE = '0') then
        --for i in 0 to DRAM_WORDSIZE - 1 loop
        --  DRAM(to_integer(unsigned(DRAM_ADDRESS)), i) <= DRAM_INOUT_DATA(i);
        --end loop;

        for i in 0 to (DRAM_WORDSIZE / 8) - 1 loop
          for j in 0 to 7 loop
            DRAM(to_integer(unsigned(DRAM_ADDRESS) + i), j) <= DRAM_INOUT_DATA(i * 8 + j); --to_integer(unsigned(ROM_ADDRESS)
          end loop;
        end loop;
        mem_ready <= '1';

      elsif (DRAM_READNOTWRITE = '1') then
        for i in 0 to (DRAM_WORDSIZE / 8) - 1 loop
          for j in 0 to 7 loop
            tmp_data(i * 8 + j) <= DRAM(to_integer(unsigned(DRAM_ADDRESS) + i), j); --to_integer(unsigned(ROM_ADDRESS)
          end loop;
        end loop;

        int_data_ready <= '1';
      end if;
    else
      mem_ready      <= '0';
      int_data_ready <= '0';
    end if;

  end process;
  DRAM_INOUT_DATA <= tmp_data when (DRAM_READNOTWRITE = '1') else (others => 'Z'); -- to cache
  DRAM_DATA_READY <= int_data_ready or mem_ready; --delay add

  process
  begin
    wait for DRAM_DUMPTIME;
    rewrite_contenent(DRAM, DRAM_ENTRIES, DRAM_WORDSIZE, DRAM_FILEPATH_DUMP); -- refresh the file
  end process;
end architecture BHV;

configuration CFG_DRAM_BHV of DRAM is
  for BHV
  end for;
end configuration CFG_DRAM_BHV;


