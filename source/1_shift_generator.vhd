library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.bus_array.all;
--type bus_array is array(natural range <>) of std_logic_vector;


entity SHIFT_GENERATOR is
  generic( N : integer := 32;   --! Number of bits of the first operand
           M : integer := 32); --! Number of bits of the second operand
  port (A : in std_logic_vector(N-1 downto 0);
        Z : out bus_array(2*M-1 downto 0));
end entity;

architecture BHV of SHIFT_GENERATOR is
signal bus_s : bus_array(2*M-1 downto 0) := (others => (others => '0'));

begin
  bus_s(0)(A'range)  <= A(N-1 downto 0);
  bus_s(1)  <= std_logic_vector(unsigned(not(bus_s(0))) + 1);

  GENLOOP: for i in 1 to (M-1) generate --m-1
    bus_s(2*i)   <= bus_s(2*(i-1))(N+M-2 downto 0) & '0';
    bus_s(2*i+1) <= bus_s(2*(i)-1)(N+M-2 downto 0) & '0';
    --bus_s(2*i)   <= bus_s(2*(i-1))(N+M-2 downto 0) & '0';
    --bus_s(2*i+1) <= bus_s(2*i)(N+M-2 downto 0) & '0'; --std_logic_vector(unsigned(not bus_s(2*i)) + 1);
  end generate;

  Z <= bus_s;

end architecture;
