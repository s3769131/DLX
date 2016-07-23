library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity TFF is
  port (
    FF_T   : in  std_logic;             -- toggle input
    FF_CLK : in  std_logic;             -- clock input
    FF_RST : in  std_logic;             -- reset signal
    FF_Q   : out std_logic;             -- positive output
    FF_NQ  : out std_logic);            -- negative output
end entity TFF;

architecture BHV of TFF is
  signal s_internal : std_logic := '0';       -- internal data signal
begin  -- architecture BHV
  MAIN : process (FF_CLK, FF_RST) is
  begin  -- process MAIN
    if FF_RST = '0' then                -- asynchronous reset (active low)
      s_internal <= '0';
    elsif FF_CLK'event and FF_CLK = '1' then  -- rising clock edge
      if FF_T = '1' then
        s_internal <= not s_internal;
      end if;
    end if;
  end process MAIN;
  FF_Q  <= s_internal;
  FF_NQ <= not s_internal;

end architecture BHV;

configuration CGF_TFF_BHV of T_FF is
  for BHV
  end for;
end configuration CGF_TFF_BHV;
