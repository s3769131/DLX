library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

package bus_array is
  --type bus_array is array(2*Mbit-1 downto 0) of std_logic_vector(Nbit+Mbit-1 downto 0);
  type bus_array is array(natural range <>) of std_logic_vector(Nbit+Mbit-1 downto 0);
  --type bus_array2 is array(natural range <>) of std_logic_vector(Nbit+Mbit downto 0);
end package;
