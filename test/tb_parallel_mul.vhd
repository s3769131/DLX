library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity TB_PARALLEL_MUL is
end entity;

architecture TEST_PARALLEL_MUL of TB_PARALLEL_MUL is
  component PARALLEL_MUL is
    generic ( N_PM : integer := 32; --! Number of bits of the first operand
              M_PM : integer := 32);--! Number of bits of the second operand
    port ( operandA : in  std_logic_vector(N_PM-1 downto 0);
           operandB : in  std_logic_vector(M_PM-1 downto 0);
           result   : out std_logic_vector(N_PM+M_PM-1 downto 0));
  end component;

  signal A_s : std_logic_vector(Nbit-1 downto 0);
  signal B_s : std_logic_vector(Mbit-1 downto 0);
  signal Y_s : std_logic_vector(Nbit+Mbit-1 downto 0);

begin
  DUT : PARALLEL_MUL
    generic map(Nbit, Mbit)
    port map(A_s, B_s, Y_s);

  STIM : process
  begin
    A_s <= "00000000000000000000000000000010";
    B_s <= "00000000000000000000000000000010";
    wait for 3 ns;
    A_s <= "01011000000000000000000000000000";
    B_s <= "10011000000000000000000000000000";
    wait for 6 ns;
    A_s <= "11111111111111111111111111111111";
    B_s <= "11111111111111111111111111111111";
   --A_s <= "00000010";
   --B_s <= "10011000";
    wait;
  end process;
end architecture;
