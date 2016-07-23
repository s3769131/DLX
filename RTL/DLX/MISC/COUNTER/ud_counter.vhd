library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;


entity UD_COUNTER is
  
  generic (
    UDC_NBIT : integer := 4);           -- number of bits

  port (
    UDC_EN  : in  std_logic;            -- enable counter
    UDC_UP  : in  std_logic;            -- up / not down signal
    UDC_CLK : in  std_logic;            -- clock signal
    UDC_RST : in  std_logic;            -- reset signal (asynch.)
    UDC_OUT : out std_logic_vector(UDC_NBIT - 1 downto 0));  -- out count

end entity UD_COUNTER;

architecture STR of UD_COUNTER is
  
  component TFF is
    port (
      FF_T   : in  std_logic;           -- toggle input
      FF_CLK : in  std_logic;           -- clock input
      FF_RST : in  std_logic;           -- reset signal
      FF_Q   : out std_logic;           -- positive output
      FF_NQ  : out std_logic);          -- negative output
  end component TFF;

  signal s_up   : std_logic := '0';     -- internal 'up' signal
  signal s_down : std_logic := '0';     -- internal 'down' signal

  signal s_q  : std_logic_vector (UDC_NBIT - 1 downto 0) := (others => '0');  -- internal q signal
  signal s_nq : std_logic_vector(UDC_NBIT - 1 downto 0)  := (others => '0');  -- internal 'not q' signal

  signal s_en_inc : std_logic_vector (UDC_NBIT - 1 downto 0) := (others => '0');  -- enable to count up
  signal s_en_dec : std_logic_vector(UDC_NBIT - 1 downto 0)  := (others => '0');  -- enable to count down

  signal s_out : std_logic_vector(UDC_NBIT downto 0) := (others => '0');  --internal out
  
begin  -- architecture STR

  s_out(0) <= UDC_EN;

  s_up   <= UDC_UP;
  s_down <= not UDC_UP;

  MAIN_GEN : for i in 0 to UDC_NBIT - 1 generate
    FF : TFF
      port map(
        FF_T   => s_out(i),
        FF_CLK => UDC_CLK,
        FF_RST => UDC_RST,
        FF_Q   => s_q(i),
        FF_NQ  => s_nq(i));

    s_en_inc(i) <= s_up and s_q(i);
    s_en_dec(i) <= s_down and s_nq(i);

    s_out(i+1) <= s_en_dec(i) or s_en_inc(i);
  end generate MAIN_GEN;

  UDC_OUT <= s_out(UDC_NBIT downto 1);

end architecture STR;

configuration CFG_UD_COUNTER_STR of UD_COUNTER is

  for STR
    for MAIN_GEN
      for FF : TFF
        use configuration work.CFG_TFF_BHV;
      end for;
    end for;
  end for;

end configuration CFG_UD_COUNTER_STR;
