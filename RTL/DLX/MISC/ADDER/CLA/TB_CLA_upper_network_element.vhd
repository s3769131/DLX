library ieee;
use ieee.std_logic_1164.all;
use work.DLX_pkg.all;

entity TB_CLA_upper_network_element is
end TB_CLA_upper_network_element;

architecture TEST of TB_CLA_upper_network_element is

    component CLA_upper_network_element is
        generic(
            CLA_UNE_N   :   integer :=  4);
        port(
            CLA_UNE_p_in    :   in  std_logic_vector(CLA_UNE_N-1 downto 0);
            CLA_UNE_g_in    :   in  std_logic_vector(CLA_UNE_N-1 downto 0);
            CLA_UNE_p_out   :   out std_logic;
            CLA_UNE_g_out   :   out std_logic);
    end component;

    constant c_CLA_UNE_N :  integer  := 8;

    signal s_CLA_UNE_p_in   :   std_logic_vector(c_CLA_UNE_N-1 downto 0)    := (others => '0');
    signal s_CLA_UNE_g_in   :   std_logic_vector(c_CLA_UNE_N-1 downto 0)    := (others => '0');
    signal s_CLA_UNE_p_out  :   std_logic                                   := '0';
    signal s_CLA_UNE_g_out  :   std_logic                                   := '0';

begin

    UUT : CLA_upper_network_element
        generic map(
            CLA_UNE_N   => c_CLA_UNE_N)
        port map(
            CLA_UNE_p_in   => s_CLA_UNE_p_in,
            CLA_UNE_g_in   => s_CLA_UNE_g_in,
            CLA_UNE_p_out  => s_CLA_UNE_p_out,
            CLA_UNE_g_out  => s_CLA_UNE_g_out);

    INPUT_STIMULI_PROCESS : process
    begin
        s_CLA_UNE_p_in <= x"a9";
        s_CLA_UNE_g_in <= x"3d";
        wait for 1 ns;
        s_CLA_UNE_p_in <= x"ff";
        s_CLA_UNE_g_in <= x"ff";
        wait for 1 ns;
        s_CLA_UNE_p_in <= x"00";
        s_CLA_UNE_g_in <= x"ff";
        wait for 1 ns;
        s_CLA_UNE_p_in <= x"00";
        s_CLA_UNE_g_in <= x"00";
        wait;
    end process;

end TEST;
