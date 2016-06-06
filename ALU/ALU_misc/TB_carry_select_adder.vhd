library ieee;
use ieee.std_logic_1164.all;

entity TB_carry_select_adder is
end TB_carry_select_adder;

architecture TEST of TB_carry_select_adder is

   component carry_select_adder is
      generic(
         CSA_NBIT   :  integer  := 4);
      port(
         CSA_op1  :  in    std_logic_vector(CSA_NBIT-1 downto 0);
         CSA_op2  :  in    std_logic_vector(CSA_NBIT-1 downto 0);
         CSA_cin  :  in    std_logic;
         CSA_res  :  out   std_logic_vector(CSA_NBIT-1 downto 0);
         CSA_cout :  out   std_logic);
   end component;

   constant c_CSA_NBIT  :  integer  := 8;

   signal s_CSA_op1  :  std_logic_vector(c_CSA_NBIT-1 downto 0)   := (others => '0');
   signal s_CSA_op2  :  std_logic_vector(c_CSA_NBIT-1 downto 0)   := (others => '0');
   signal s_CSA_cin  :  std_logic                                 := '0';
   signal s_CSA_res  :  std_logic_vector(c_CSA_NBIT-1 downto 0)   := (others => '0');
   signal s_CSA_cout :  std_logic                                 := '0';

begin

      UUT : carry_select_adder
         generic map(
            CSA_NBIT => c_CSA_NBIT
         )
         port map(
            CSA_op1  => s_CSA_op1,
            CSA_op2  => s_CSA_op2,
            CSA_cin  => s_CSA_cin,
            CSA_res  => s_CSA_res,
            CSA_cout => s_CSA_cout
         );

      INPUT_STIMULI_PROCESS : process
      begin
         s_CSA_op1   <= x"00";
         s_CSA_op2   <= x"00";
         s_CSA_cin   <= '0';
         wait for 1 ns;
         s_CSA_cin   <= '1';
         wait for 1 ns;
         s_CSA_op1   <= x"ff";
         s_CSA_op2   <= x"ff";
         s_CSA_cin   <= '0';
         wait for 1 ns;
         s_CSA_cin   <= '1';
         wait for 1 ns;
         s_CSA_op1   <= x"ff";
         s_CSA_op2   <= x"00";
         s_CSA_cin   <= '0';
         wait for 1 ns;
         s_CSA_cin   <= '1';
         wait for 1 ns;
         s_CSA_op1   <= x"45";
         s_CSA_op2   <= x"f1";
         s_CSA_cin   <= '0';
         wait for 1 ns;
         s_CSA_cin   <= '1';
         wait;
      end process;

end TEST;
