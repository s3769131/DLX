library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ALU_pkg.all;

entity TB_rom is
end entity TB_rom;

architecture TEST of TB_rom is
  component ROM
    generic(
      ROM_FILE_PATH  : string;
      ROM_ENTRIES    : integer := 128;
      ROM_WORD_SIZE  : integer := 32;
      ROM_DATA_DELAY : natural := 2
      );
    port(
      ROM_CLK        : in  std_logic;
      ROM_RST        : in  std_logic;
      ROM_ADDRESS    : in  std_logic_vector(log2ceil(ROM_ENTRIES) - 1 downto 0);
      ROM_ENABLE     : in  std_logic;
      ROM_DATA_READY : out std_logic;
      ROM_DATA_OUT   : out std_logic_vector(ROM_WORD_SIZE - 1 downto 0)
      );
  end component ROM;
  constant c_FILE_PATH  : string  := "./rom_content.hex";
  constant c_ENTRIES    : integer := 4;
  constant c_WORD_SIZE  : integer := 32;
  constant c_DATA_DELAY : natural := 0;

  signal s_CLK    : std_logic := '0';
  signal s_RST    : std_logic := '0';
  signal s_ENABLE : std_logic := '0';

  signal s_ADDRESS : std_logic_vector(log2ceil(c_ENTRIES) - 1 downto 0) := (others => '0');

  signal s_DATA_READY : std_logic;
  signal s_DATA_OUT   : std_logic_vector(c_WORD_SIZE - 1 downto 0);
  
begin
  UUT : component ROM
    generic map(
      ROM_FILE_PATH  => c_FILE_PATH,
      ROM_ENTRIES    => c_ENTRIES,
      ROM_WORD_SIZE  => c_WORD_SIZE,
      ROM_DATA_DELAY => c_DATA_DELAY
      )
    port map(
      ROM_CLK        => s_CLK,
      ROM_RST        => s_RST,
      ROM_ADDRESS    => s_ADDRESS,
      ROM_ENABLE     => s_ENABLE,
      ROM_DATA_READY => s_DATA_READY,
      ROM_DATA_OUT   => s_DATA_OUT
      );


  CLK_P : process is
  begin  -- process CLK_P
    wait for 1 ns;
    s_CLK <= not s_CLK;
  end process CLK_P;

  STIM : process
  begin
    s_RST <= '1';

    wait for 1.1 ns;

    s_RST     <= '0';
    s_ADDRESS <= "10";
    s_ENABLE  <= '1';

    wait;
  end process STIM;
end architecture TEST;
