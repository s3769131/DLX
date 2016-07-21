library ieee;
use ieee.std_logic_1164.all;

entity TB_ripple_carry_adder is
end TB_ripple_carry_adder;

architecture TEST of TB_ripple_carry_adder is

   component ripple_carry_adder is
      generic(
         RCA_NBIT : integer   := 4);
      port(
         RCA_op1  :  in    std_logic_vector(RCA_NBIT-1 downto 0);
         RCA_op2  :  in    std_logic_vector(RCA_NBIT-1 downto 0);
         RCA_cin  :  in    std_logic;
         RCA_res  :  out   std_logic_vector(RCA_NBIT-1 downto 0);
         RCA_cout :  out   std_logic);
   end component;

   constant c_RCA_NBIT  :  integer  := 8;

   signal s_RCA_op1  :  std_logic_vector(c_RCA_NBIT-1 downto 0)   := (others => '0');
   signal s_RCA_op2  :  std_logic_vector(c_RCA_NBIT-1 downto 0)   := (others => '0');
   signal s_RCA_cin  :  std_logic                                 := '0';
   signal s_RCA_res  :  std_logic_vector(c_RCA_NBIT-1 downto 0)   := (others => '0');
   signal s_RCA_cout :  std_logic                                 := '0';

begin

      UUT : ripple_carry_adder
         generic map(
            RCA_NBIT => c_RCA_NBIT
         )
         port map(
            RCA_op1  => s_RCA_op1,
            RCA_op2  => s_RCA_op2,
            RCA_cin  => s_RCA_cin,
            RCA_res  => s_RCA_res,
            RCA_cout => s_RCA_cout
         );

      INPUT_STIMULI_PROCESS : process
      begin
         s_RCA_op1   <= x"00";
         s_RCA_op2   <= x"00";
         s_RCA_cin   <= '0';
         wait for 1 ns;
         s_RCA_cin   <= '1';
         wait for 1 ns;
         s_RCA_op1   <= x"ff";
         s_RCA_op2   <= x"ff";
         s_RCA_cin   <= '0';
         wait for 1 ns;
         s_RCA_cin   <= '1';
         wait for 1 ns;
         s_RCA_op1   <= x"ff";
         s_RCA_op2   <= x"00";
         s_RCA_cin   <= '0';
         wait for 1 ns;
         s_RCA_cin   <= '1';
         wait for 1 ns;
         s_RCA_op1   <= x"45";
         s_RCA_op2   <= x"f1";
         s_RCA_cin   <= '0';
         wait for 1 ns;
         s_RCA_cin   <= '1';
         wait;
      end process;

end TEST;
