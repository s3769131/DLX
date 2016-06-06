library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

entity TB_CLA_pg_network is
end TB_CLA_pg_network;

architecture TEST of TB_CLA_pg_network is

      component CLA_pg_network
         generic(
            CLA_PGN_N :	integer	:=	32);
         port(
            CLA_PGN_op1	: in  std_logic_vector(CLA_PGN_N-1 downto 0);
            CLA_PGN_op2	: in  std_logic_vector(CLA_PGN_N-1 downto 0);
            CLA_PGN_cin   : in  std_logic;
            CLA_PGN_p     : out std_logic_vector(CLA_PGN_N-1 downto 0);
            CLA_PGN_g     : out std_logic_vector(CLA_PGN_N-1 downto 0));
      end component;

      constant c_CLA_PGN_N :  integer  := 8;

      signal s_CLA_PGN_op1 :  std_logic_vector(c_CLA_PGN_N-1 downto 0)  := (others => '0');
      signal s_CLA_PGN_op2 :  std_logic_vector(c_CLA_PGN_N-1 downto 0)  := (others => '0');
      signal s_CLA_PGN_cin :  std_logic   := '0';
      signal s_CLA_PGN_p   :  std_logic_vector(c_CLA_PGN_N-1 downto 0)  := (others => '0');
      signal s_CLA_PGN_g   :  std_logic_vector(c_CLA_PGN_N-1 downto 0)  := (others => '0');

begin

   UUT : CLA_pg_network
      generic map(
         CLA_PGN_N   => c_CLA_PGN_N
      )
      port map(
         CLA_PGN_op1 => s_CLA_PGN_op1,
         CLA_PGN_op2 => s_CLA_PGN_op2,
         CLA_PGN_cin => s_CLA_PGN_cin,
         CLA_PGN_p   => s_CLA_PGN_p,
         CLA_PGN_g   => s_CLA_PGN_g
      );

   INPUT_STIMULI_PROCESS : process
   begin
      s_CLA_PGN_cin  <= '0';
      s_CLA_PGN_op1  <= x"a9";
      s_CLA_PGN_op2  <= x"3d";
      wait for 1 ns;
      s_CLA_PGN_cin  <= '1';
      wait for 1 ns;
      s_CLA_PGN_cin  <= '0';
      s_CLA_PGN_op1  <= x"ff";
      s_CLA_PGN_op2  <= x"ff";
      wait for 1 ns;
      s_CLA_PGN_cin  <= '1';
      wait for 1 ns;
      s_CLA_PGN_cin  <= '0';
      s_CLA_PGN_op1  <= x"fa";
      s_CLA_PGN_op2  <= x"f1";
      wait for 1 ns;
      s_CLA_PGN_cin  <= '1';
      wait;
   end process;

end TEST;
