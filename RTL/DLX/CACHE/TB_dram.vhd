library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MEM_pkg.all;

entity TB_dram is
end entity TB_dram;

architecture RTL of TB_dram is
  component DRAM
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
  end component DRAM;

  constant c_FILEPATH_DUMP : string   := "./dram_dump.hex";
  constant c_FILEPATH_INIT : string   := "./dram_init.hex";
  constant c_WORDSIZE      : integer  := 32;
  constant c_ENTRIES       : positive := 2 ** 16;
  constant c_DUMPTIME      : time     := 1 us;

  signal s_CLK          : std_logic := '0';
  signal s_RST          : std_logic := '1';
  signal s_ADDRESS      : std_logic_vector(log2ceil(c_ENTRIES) - 1 downto 0);
  signal s_ENABLE       : std_logic := '0';
  signal s_READNOTWRITE : std_logic := '0';

  signal s_DATA_READY : std_logic;
  signal s_INOUT_DATA : std_logic_vector(c_WORDSIZE - 1 downto 0);

begin
  UUT : component DRAM
    generic map(
      DRAM_FILEPATH_DUMP => c_FILEPATH_DUMP,
      DRAM_FILEPATH_INIT => c_FILEPATH_INIT,
      DRAM_WORDSIZE      => c_WORDSIZE,
      DRAM_ENTRIES       => c_ENTRIES,
      DRAM_DUMPTIME      => c_DUMPTIME
      )
    port map(
      DRAM_CLK          => s_CLK,
      DRAM_RST          => s_RST,
      DRAM_ADDRESS      => s_ADDRESS,
      DRAM_ENABLE       => s_ENABLE,
      DRAM_READNOTWRITE => s_READNOTWRITE,
      DRAM_DATA_READY   => s_DATA_READY,
      DRAM_INOUT_DATA   => s_INOUT_DATA
      );

  CLK_PROC : process
  begin
    wait for 0.5 ns;
    s_CLK <= not s_CLK;
  end process;

  STIM : process
  begin
    wait for 0.5 ns;
    s_RST <= '0';
    for i in 0 to c_ENTRIES - 1 loop
      s_ENABLE       <= '1';
      s_ADDRESS      <= std_logic_vector(to_unsigned(i, log2ceil(c_ENTRIES)));
      s_INOUT_DATA   <= std_logic_vector(to_unsigned(i, c_WORDSIZE));
      s_READNOTWRITE <= '0';
      wait for 1 ns;
    end loop;
    wait;
  end process;

end architecture RTL;
