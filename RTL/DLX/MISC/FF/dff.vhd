library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dff is
  port(
    FF_D   : in  std_logic;
    FF_CLK : in  std_logic;
    FF_RST : in  std_logic;
    FF_Q   : out std_logic;
    FF_NQ  : out std_logic);
end entity dff;

architecture BHV of dff is
  signal internal_data : std_logic := '0';
begin
  MAIN_DFF : process(FF_RST, FF_CLK)
  begin
    if FF_RST = '0' then
      internal_data <= '0';
    else
      if FF_CLK'event and FF_CLK = '1' then
        internal_data <= FF_D;
      end if;
    end if;
  end process MAIN_DFF;
  
  FF_Q  <= internal_data;
  FF_NQ  <= not internal_data;
end architecture BHV;

