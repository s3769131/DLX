library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity TB_TFF is
end entity TB_TFF;

architecture TEST of TB_TFF is
component TFF is
  port (
    FF_T   : in  std_logic;             -- toggle input
    FF_CLK : in  std_logic;             -- clock input
    FF_RST : in  std_logic;             -- reset signal
    FF_Q   : out std_logic;             -- positive output
    FF_NQ  : out std_logic);            -- negative output
end component TFF;
signal s_t     : std_logic := '0';
signal s_clk   : std_logic := '0';
signal s_rst   : std_logic := '0';
signal s_q     : std_logic := '0';
signal s_nq    : std_logic := '0';
constant c_tck : time      := 1 ns;
begin  -- architecture TEST
  UUT : component TFF
    port map (
      FF_T   => s_t,
      FF_CLK => s_clk,
      FF_RST => s_rst,
      FF_Q   => s_q,
      FF_NQ  => s_nq);

  CLOCK_PROC : process is
  begin  -- process CLOCK_PROC
    wait for c_tck/2;
    s_clk <= not s_clk;
  end process CLOCK_PROC;

  STIM : process is
  begin  -- process STIM
    wait for 1.1 ns;
    s_rst <= '1';
    s_t <= '1';
    wait for 3 ns;
    s_t <= '0';
    wait;
  end process STIM;
end architecture TEST;
