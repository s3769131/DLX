library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity sat_counter is
  generic(
    SAT_NBIT : integer := 4);
  port(
    SAT_CLK : in  std_logic;
    SAT_RST : in  std_logic;
    SAT_EN  : in  std_logic;
    SAT_UP  : in  std_logic;
    SAT_OUT : out std_logic_vector(SAT_NBIT - 1 downto 0));
end entity sat_counter;

architecture STR of sat_counter is
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

  signal s_out        : std_logic_vector(SAT_NBIT - 1 downto 0) := (others => '0');
  signal s_or_red     : std_logic;
  signal s_nand_red   : std_logic;
  signal s_stop_count : std_logic;
begin
  COUNTER : UD_COUNTER
    generic map(
      UDC_NBIT => SAT_NBIT)
    port map(
      UDC_EN  => s_stop_count,
      UDC_UP  => SAT_UP,
      UDC_CLK => SAT_CLK,
      UDC_RST => SAT_RST,
      UDC_OUT => s_out);
  s_or_red     <= or_reduce(s_out);
  s_nand_red   <= not AND_REDUCE(s_out);
  s_stop_count <= SAT_EN and (s_or_red and s_nand_red);

  SAT_OUT <= s_out;
end architecture STR;

configuration CFG_SAT_COUNTER_STR of SAT_COUNTER is
  for STR
    for COUNTER : UD_COUNTER
      use configuration work.CFG_UD_COUNTER_STR;
    end for;
  end for;
end configuration CFG_SAT_COUNTER_STR;

