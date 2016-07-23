library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_COMPARATOR is
end entity TB_COMPARATOR;

architecture TEST of TB_COMPARATOR is
  component EQ_COMPARATOR is
    generic (
      COMP_NBIT : integer); 
    port (
      COMP_A   : in  std_logic_vector (COMP_NBIT - 1 downto 0);
      COMP_B   : in  std_logic_vector (COMP_NBIT - 1 downto 0);
      COMP_RES : out std_logic); 
  end component;

  constant c_COMP_NBIT : integer := 2;

  signal s_COMP_A   : std_logic_vector (c_COMP_NBIT - 1 downto 0) := (others => '0');
  signal s_COMP_B   : std_logic_vector (c_COMP_NBIT - 1 downto 0) := (others => '0');
  signal s_COMP_RES : std_logic                                   := '0';

begin
  UUT : EQ_COMPARATOR
    generic map(
      COMP_NBIT => c_COMP_NBIT
      )
    port map(
      COMP_A   => s_COMP_A,
      COMP_B   => s_COMP_B,
      COMP_RES => s_COMP_RES
      );


  -- purpose: Stimulation process for test
  STIM : process is
  begin  -- process STIM
    for i in 0 to 2**c_COMP_NBIT - 1 loop
      for j in 0 to 2**c_COMP_NBIT - 1 loop
        s_COMP_A <= std_logic_vector(to_unsigned(i, c_COMP_NBIT));
        s_COMP_B <= std_logic_vector(to_unsigned(j, c_COMP_NBIT));
        wait for 1 ns;
      end loop;  -- j
    end loop;  -- i
    wait;
  end process STIM;
end architecture;









