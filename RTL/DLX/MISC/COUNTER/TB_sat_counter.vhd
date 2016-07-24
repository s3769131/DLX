library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_sat_counter is
end entity TB_sat_counter;

architecture TEST of TB_sat_counter is
  component sat_counter
    generic(SAT_NBIT : integer := 4);
    port(
      SAT_CLK : in  std_logic;
      SAT_RST : in  std_logic;
      SAT_EN  : in  std_logic;
      SAT_UP  : in  std_logic;
      SAT_OUT : out std_logic_vector(SAT_NBIT - 1 downto 0)
    );
  end component sat_counter;
 constant c_NBIT : integer := 4;
  constant c_tck  : time    := 1 ns;

  signal s_EN  : std_logic := '0';
  signal s_UP  : std_logic := '0';
  signal s_CLK : std_logic := '0';
  signal s_RST : std_logic := '0';

  signal s_OUT : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
   
begin
 UUT : sat_counter
   generic map(
     SAT_NBIT => c_NBIT)
   port map(
     SAT_CLK => s_CLK,
     SAT_RST => s_RST,
     SAT_EN  => S_EN,
     SAT_UP  => S_UP,
     SAT_OUT => S_OUT);
  
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
    wait for 10 ns;
    s_UP <= '0';
    wait;
  end process STIM;
end architecture TEST;
