library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity TB_ud_counter is
end entity TB_ud_counter;

architecture TEST of TB_ud_counter is
  component UD_COUNTER
    generic(
      UDC_NBIT : integer := 4);
    port(
      UDC_EN  : in  std_logic;
      UDC_UP  : in  std_logic;
      UDC_CLK : in  std_logic;
      UDC_RST : in  std_logic;
      UDC_OUT : out std_logic_vector(UDC_NBIT - 1 downto 0));
  end component UD_COUNTER;

  constant c_NBIT : integer := 3;
  constant c_tck  : time    := 1 ns;

  signal s_EN  : std_logic := '0';
  signal s_UP  : std_logic := '0';
  signal s_CLK : std_logic := '0';
  signal s_RST : std_logic := '0';

  signal s_OUT : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');

begin
  UUT : component UD_COUNTER
    generic map(
      UDC_NBIT => c_NBIT)
    port map(
      UDC_EN  => s_EN,
      UDC_UP  => s_UP,
      UDC_CLK => s_CLK,
      UDC_RST => s_RST,
      UDC_OUT => s_OUT);

  CLOCK : process
  begin
    wait for c_tck / 2;
    s_CLK <= not s_CLK;
  end process CLOCK;

  STIM : process
  begin
    wait for 1.1 ns;
    s_RST <= '1';
    s_EN  <= '1';
    s_UP  <= '1';
    wait for 4 ns;
    s_EN <= '0';
    wait for 1 ns;
    s_EN <= '1';
    s_UP <= '0';
    
    wait;
  end process STIM;
end architecture TEST;

