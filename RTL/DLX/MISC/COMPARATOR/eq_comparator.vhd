library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity EQ_COMPARATOR is
  generic(
    COMP_NBIT : integer := 32
    );
  port(
    COMP_A   : in  std_logic_vector (COMP_NBIT - 1 downto 0);
    COMP_B   : in  std_logic_vector (COMP_NBIT - 1 downto 0);
    COMP_RES : out std_logic
    );
end entity EQ_COMPARATOR;

architecture STR of EQ_COMPARATOR is
  signal s_partial_eq : std_logic_vector (COMP_NBIT - 1 downto 0);
begin
  s_partial_eq <= COMP_A xnor COMP_B;
  COMP_RES     <= and_reduce(s_partial_eq);
end architecture STR;

configuration CFG_EQ_COMPARATOR_STR of EQ_COMPARATOR is
  for STR
  end for;
end configuration CFG_EQ_COMPARATOR_STR;
