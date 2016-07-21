library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_REGF_decoder is
end TB_REGF_decoder;

architecture TEST of TB_REGF_decoder is

    component REGF_decoder is
        generic(
            DEC_NBIT    :   integer :=  5);
        port(
            DEC_address :   in  std_logic_vector(DEC_NBIT-1 downto 0);
            DEC_enable  :   in  std_logic;
            DEC_output  :   out std_logic_vector(2**DEC_NBIT-1 downto 0));
    end component;

    constant c_DEC_NBIT :   integer :=  3;

    signal s_DEC_address    :   std_logic_vector(c_DEC_NBIT-1 downto 0);
    signal s_DEC_enable     :   std_logic;
    signal s_DEC_output     :   std_logic_vector(2**c_DEC_NBIT-1 downto 0);

begin

    UUT : REGF_decoder
        generic map(
            DEC_NBIT    =>  c_DEC_NBIT)
        port map(
            DEC_address =>  s_DEC_address,
            DEC_enable  =>  s_DEC_enable,
            DEC_output  =>  s_DEC_output);

    INPUT_STIMULI_PROCESS : process
    begin
        s_DEC_address   <= (others => '0');

        s_DEC_enable    <= '0';
        for i in 0 to 2**c_DEC_NBIT-1 loop
            s_DEC_address   <=  std_logic_vector(to_unsigned(i,c_DEC_NBIT));
            wait for 1 ns;
        end loop;

        s_DEC_enable    <= '1';
        for i in 0 to 2**c_DEC_NBIT-1 loop
            s_DEC_address   <=  std_logic_vector(to_unsigned(i,c_DEC_NBIT));
            wait for 1 ns;
        end loop;
        wait;
    end process;

end TEST;
