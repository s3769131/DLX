library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_bit_multiplexer is
end TB_bit_multiplexer;

architecture TEST of TB_bit_multiplexer is

    component bit_multiplexer is
        generic(
            BIT_MUX_NSEL    :   integer :=  3);
        port(
            BIT_MUX_inputs  :   in  std_logic_vector(2**BIT_MUX_NSEL - 1 downto 0);
            BIT_MUX_select  :   in  std_logic_vector(BIT_MUX_NSEL-1 downto 0);
            BIT_MUX_output  :   out std_logic);
    end component;

    constant c_BIT_MUX_NSEL :   integer :=  3;

    signal s_BIT_MUX_inputs :  std_logic_vector(2**c_BIT_MUX_NSEL - 1 downto 0);
    signal s_BIT_MUX_select :  std_logic_vector(c_BIT_MUX_NSEL-1 downto 0);
    signal s_BIT_MUX_output :  std_logic;

begin

    UUT : bit_multiplexer
        generic map(
            BIT_MUX_NSEL    =>  c_BIT_MUX_NSEL)
        port map(
            BIT_MUX_inputs  =>  s_BIT_MUX_inputs,
            BIT_MUX_select  =>  s_BIT_MUX_select,
            BIT_MUX_output  =>  s_BIT_MUX_output);

    INPUT_STIMULI_PROCESS : process
    begin
        s_BIT_MUX_inputs    <=  "1"&"0"&"1"&"0"&"1"&"0"&"1"&"0";
        s_BIT_MUX_select    <=  (others => '0');

        for i in 0 to 2**c_BIT_MUX_NSEL-1 loop
            wait for 1 ns;
            s_BIT_MUX_select    <=  std_logic_vector(to_unsigned(i,c_BIT_MUX_NSEL));
        end loop;
        wait;
    end process;

end TEST;
