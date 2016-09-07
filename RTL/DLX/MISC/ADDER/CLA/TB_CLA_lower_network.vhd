library ieee;
use ieee.std_logic_1164.all;
use work.DLX_pkg.all;

entity TB_CLA_lower_network is
end TB_CLA_lower_network;

architecture TEST of TB_CLA_lower_network is

    component CLA_lower_network is
        generic(
            CLA_LN_N :  integer :=  4);
        port(
            CLA_LN_partial_carry_p  :  in  std_logic_vector(CLA_LN_N-1 downto 0);
            CLA_LN_partial_carry_g  :  in  std_logic_vector(CLA_LN_N-1 downto 0);
            CLA_LN_final_carries    :  out std_logic_vector(CLA_LN_N-1 downto 0));
    end component;

    constant c_CLA_LN_N  :  integer  := 8;

    signal s_CLA_LN_partial_carry_p  :  std_logic_vector(c_CLA_LN_N-1 downto 0)   := (others => '0');
    signal s_CLA_LN_partial_carry_g  :  std_logic_vector(c_CLA_LN_N-1 downto 0)   := (others => '0');
    signal s_CLA_LN_final_carry      :  std_logic_vector(c_CLA_LN_N-1 downto 0)   := (others => '0');

begin

    UUT : CLA_lower_network
        generic map(
            CLA_LN_N    =>  c_CLA_LN_N)
        port map(
            CLA_LN_partial_carry_p  =>  s_CLA_LN_partial_carry_p,
            CLA_LN_partial_carry_g  =>  s_CLA_LN_partial_carry_g,
            CLA_LN_final_carries    =>  s_CLA_LN_final_carry);

    INPUT_STIMULI_PROCESS : process
    begin
        s_CLA_LN_partial_carry_p <= x"a9";
        s_CLA_LN_partial_carry_g <= x"3d";
        wait for 1 ns;
        s_CLA_LN_partial_carry_p <= x"ff";
        s_CLA_LN_partial_carry_g <= x"ff";
        wait for 1 ns;
        s_CLA_LN_partial_carry_p <= x"00";
        s_CLA_LN_partial_carry_g <= x"ff";
        wait for 1 ns;
        s_CLA_LN_partial_carry_p <= x"00";
        s_CLA_LN_partial_carry_g <= x"00";
        wait;
    end process;

end TEST;
