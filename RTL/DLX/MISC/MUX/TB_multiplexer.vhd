library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_multiplexer is
end TB_multiplexer;

architecture TEST of TB_multiplexer is

    component multiplexer is
        generic(
            MUX_NBIT    :   integer :=  4;
            MUX_NSEL    :   integer :=  3);
        port(
            MUX_inputs  :   in  std_logic_vector(MUX_NBIT*(2**MUX_NSEL)-1 downto 0);
            MUX_select  :   in  std_logic_vector(MUX_NSEL-1 downto 0);
            MUX_output  :   out std_logic_vector(MUX_NBIT-1 downto 0));
    end component;

    constant c_MUX_NBIT :   integer :=  4;
    constant c_MUX_NSEL :   integer :=  3;

    signal s_MUX_inputs :   std_logic_vector(c_MUX_NBIT*(2**c_MUX_NSEL)-1 downto 0);
    signal s_MUX_select :   std_logic_vector(c_MUX_NSEL-1 downto 0);
    signal s_MUX_output :   std_logic_vector(c_MUX_NBIT-1 downto 0);

begin

    UUT : multiplexer
        generic map(
            MUX_NBIT    =>  c_MUX_NBIT,
            MUX_NSEL    =>  c_MUX_NSEL)
        port map(
            MUX_inputs  =>  s_MUX_inputs,
            MUX_select  =>  s_MUX_select,
            MUX_output  =>  s_MUX_output);

    INPUT_STIMULI_PROCESS : process
    begin
        s_MUX_inputs    <=  "0111"&"0110"&"0101"&"0100"&"0011"&"0010"&"0001"&"0000";
        s_MUX_select    <=  (others => '0');

        for i in 0 to 2**c_MUX_NSEL-1 loop
            wait for 1 ns;
            s_MUX_select    <=  std_logic_vector(to_unsigned(i,c_MUX_NSEL));
        end loop;
        wait;
    end process;

end TEST;
