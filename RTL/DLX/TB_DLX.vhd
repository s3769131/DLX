library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.DLX_pkg.all;

entity TB_DLX is
end entity TB_DLX;

architecture TEST of TB_DLX is
  component DLX
    generic(
      DLX_PC_NBIT   : positive := 32;
      DLX_IR_NBIT   : positive := 32;
      DLX_ALU_NBIT  : positive := 32;
      DLX_DATA_NBIT : positive := 32;
      DLX_ADDR_NBIT : positive := 32;
      DLX_RF_NREG   : positive := 32;
      DLX_RF_NBIT   : positive := 32
    );
    port(
      DLX_CLK           : in    std_logic;
      DLX_RST           : in    std_logic;
      ROM_ADDRESS       : out   std_logic_vector(DLX_PC_NBIT - 1 downto 0);
      ROM_EN            : out   std_logic;
      ROM_DATA_READY    : in    std_logic;
      ROM_INTERFACE     : in    std_logic_vector(DLX_IR_NBIT - 1 downto 0);
      DRAM_ADDRESS      : out   std_logic_vector(DLX_ADDR_NBIT - 1 downto 0);
      DRAM_EN           : out   std_logic;
      DRAM_READNOTWRITE : out   std_logic;
      DRAM_DATA_READY   : in    std_logic;
      DRAM_INTERFACE    : inout std_logic_vector(DLX_DATA_NBIT - 1 downto 0)
    );
  end component DLX;

  component ROM
    generic(
      ROM_FILE_PATH : string;
      ROM_ENTRIES   : integer := 128;
      ROM_WORD_SIZE : integer := 32
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

  constant c_PC_NBIT   : positive := 32;
  constant c_IR_NBIT   : positive := 32;
  constant c_ALU_NBIT  : positive := 32;
  constant c_DATA_NBIT : positive := 32;
  constant c_ADDR_NBIT : positive := 32;
  constant c_RF_NREG   : positive := 32;
  constant c_RF_NBIT   : positive := 32;

  constant c_ROM_ENTRIES  : positive := 256;
  constant c_DRAM_ENTRIES : positive := 64;

  signal s_DLX_CLK           : std_logic := '0';
  signal s_DLX_RST           : std_logic;
  signal s_ROM_ADDRESS       : std_logic_vector(c_ADDR_NBIT - 1 downto 0);
  signal s_ROM_EN            : std_logic;
  signal s_ROM_DATA_READY    : std_logic;
  signal s_ROM_INTERFACE     : std_logic_vector(c_DATA_NBIT - 1 downto 0);
  signal s_DRAM_ADDRESS      : std_logic_vector(c_ADDR_NBIT - 1 downto 0);
  signal s_DRAM_READNOTWRITE : std_logic;
  signal s_DRAM_DATA_READY   : std_logic;
  signal s_DRAM_INTERFACE    : std_logic_vector(c_DATA_NBIT - 1 downto 0);
  signal s_DRAM_DLX          : std_logic_vector(c_DATA_NBIT - 1 downto 0);
  signal s_DRAM_EN           : std_logic;

begin
  s_DRAM_ADDRESS(c_ADDR_NBIT - 1 downto log2ceil(c_DRAM_ENTRIES)) <= (others => '0');

  s_ROM_ADDRESS(c_ADDR_NBIT - 1 downto log2ceil(c_ROM_ENTRIES)) <= (others => '0');

  UUT : component DLX
    generic map(
      DLX_PC_NBIT   => c_PC_NBIT,
      DLX_IR_NBIT   => c_IR_NBIT,
      DLX_ALU_NBIT  => c_ALU_NBIT,
      DLX_DATA_NBIT => c_DATA_NBIT,
      DLX_ADDR_NBIT => c_ADDR_NBIT,
      DLX_RF_NREG   => c_RF_NREG,
      DLX_RF_NBIT   => c_RF_NBIT
    )
    port map(
      DLX_CLK           => s_DLX_CLK,
      DLX_RST           => s_DLX_RST,
      ROM_ADDRESS       => s_ROM_ADDRESS,
      ROM_EN            => s_ROM_EN,
      ROM_DATA_READY    => s_ROM_DATA_READY,
      ROM_INTERFACE     => s_ROM_INTERFACE,
      DRAM_ADDRESS      => s_DRAM_ADDRESS,
      DRAM_EN           => s_DRAM_EN,
      DRAM_READNOTWRITE => s_DRAM_READNOTWRITE,
      DRAM_DATA_READY   => s_DRAM_DATA_READY,
      DRAM_INTERFACE    => s_DRAM_DLX
    );

  IROM : ROM
    generic map(
      ROM_FILE_PATH => "./test_programs/store/store_dump.txt",
      ROM_ENTRIES   => c_ROM_ENTRIES,
      ROM_WORD_SIZE => c_DATA_NBIT
    )
    port map(
      ROM_CLK        => s_DLX_CLK,
      ROM_RST        => s_DLX_RST,
      ROM_ADDRESS    => s_ROM_ADDRESS(log2ceil(c_ROM_ENTRIES) - 1 downto 0),
      ROM_ENABLE     => s_ROM_EN,
      ROM_DATA_READY => s_ROM_DATA_READY,
      ROM_DATA_OUT   => s_ROM_INTERFACE
    );

  DDRAM : DRAM
    generic map(
      DRAM_FILEPATH_DUMP => "./dram_dump.hex",
      DRAM_FILEPATH_INIT => "./dram_init.hex",
      DRAM_WORDSIZE      => c_DATA_NBIT,
      DRAM_ENTRIES       => c_DRAM_ENTRIES,
      DRAM_DUMPTIME      => 10 ns
    )
    port map(
      DRAM_CLK          => s_DLX_CLK,
      DRAM_RST          => s_DLX_RST,
      DRAM_ADDRESS      => s_DRAM_ADDRESS(log2ceil(c_DRAM_ENTRIES) - 1 downto 0),
      DRAM_ENABLE       => s_DRAM_EN,
      DRAM_READNOTWRITE => s_DRAM_READNOTWRITE,
      DRAM_DATA_READY   => s_DRAM_DATA_READY,
      DRAM_INOUT_DATA   => s_DRAM_INTERFACE
    );

 s_DRAM_DLX <= s_DRAM_INTERFACE when  s_DRAM_READNOTWRITE = '1' else (others => 'Z');
 s_DRAM_INTERFACE <= s_DRAM_DLX when  s_DRAM_READNOTWRITE = '0' else (others => 'Z');

--  process(s_DRAM_READNOTWRITE, s_DRAM_INTERFACE, s_DRAM_DLX)
--  begin
--    if (s_DRAM_READNOTWRITE = '1') then
--      s_DRAM_DLX       <= s_DRAM_INTERFACE;
--      s_DRAM_INTERFACE <= (others => 'Z');
--   else
--      if (s_DRAM_READNOTWRITE = '0') then
--        s_DRAM_DLX       <= s_DRAM_INTERFACE;
--        s_DRAM_INTERFACE <= s_DRAM_DLX;
--      end if;
--    end if;
--  end process;

  CLK_PROC : process
  begin
    wait for 0.5 ns;
    s_DLX_CLK <= not s_DLX_CLK;
  end process CLK_PROC;

  STIM : process
  begin
    s_DLX_RST <= '0';
    wait for 1 ns;
    s_DLX_RST <= '1';
    wait;
  end process STIM;

end architecture TEST;
