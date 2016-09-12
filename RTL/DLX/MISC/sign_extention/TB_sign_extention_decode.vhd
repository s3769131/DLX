library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.DLX_pkg.all;

entity TB_sign_extention_decode is
end TB_sign_extention_decode;

architecture TEST of TB_sign_extention_decode is

    component sign_extention_decode
      generic(
        SIGN_EXT_IN_NBIT  : integer := 16;
        SIGN_EXT_OUT_NBIT : integer := 32
      );
      port(
        SIGN_EXT_signed : in  std_logic;
        SIGN_EXT_input  : in  std_logic_vector(SIGN_EXT_IN_NBIT - 1 downto 0);
        SIGN_EXT_output : out std_logic_vector(SIGN_EXT_OUT_NBIT - 1 downto 0)
      );
    end component sign_extention_decode;

    constant c_SIGN_EXT_IN_NBIT     :   integer :=  4;
    constant c_SIGN_EXT_OUT_NBIT    :   integer :=  8;

    signal s_SIGN_EXT_signed    :   std_logic                               :=  '0';
    signal s_SIGN_EXT_input     :   std_logic_vector(c_SIGN_EXT_IN_NBIT - 1  downto 0)    :=  (others => '0');
    signal s_SIGN_EXT_output    :   std_logic_vector(c_SIGN_EXT_OUT_NBIT - 1 downto 0)   :=  (others => '0');

begin

    UUT : sign_extention_decode
        generic map(
            SIGN_EXT_IN_NBIT    =>  c_SIGN_EXT_IN_NBIT,
            SIGN_EXT_OUT_NBIT   =>  c_SIGN_EXT_OUT_NBIT)
        port map(
            SIGN_EXT_signed     =>  s_SIGN_EXT_signed,
            SIGN_EXT_input      =>  s_SIGN_EXT_input,
            SIGN_EXT_output     =>  s_SIGN_EXT_output);

    INPUT_STIMULI_PROCESS : process
    begin
        s_SIGN_EXT_input    <=  x"5";
        s_SIGN_EXT_signed   <=  '0';
        wait for 1 ns;
        s_SIGN_EXT_signed   <=  '1';
        wait for 1 ns;

        s_SIGN_EXT_input    <=  x"a";
        s_SIGN_EXT_signed   <=  '0';
        wait for 1 ns;
        s_SIGN_EXT_signed   <=  '1';
        wait;
    end process;
end TEST;
