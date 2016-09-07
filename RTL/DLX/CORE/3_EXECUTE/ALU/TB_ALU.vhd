library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.DLX_pkg.all;

entity TB_ALU is
end TB_ALU;

architecture TEST of TB_ALU is

    component ALU is
        generic(
            ALU_NBIT :  integer  := 32);
        port(
            ALU_command    :  in    std_logic_vector(5 downto 0);
            ALU_operand1   :  in    std_logic_vector(ALU_NBIT-1 downto 0);
            ALU_operand2   :  in    std_logic_vector(ALU_NBIT-1 downto 0);
            ALU_result     :  out   std_logic_vector(ALU_NBIT-1 downto 0));
    end component;

    constant c_ALU_NBIT  :  integer  := 32;

    signal s_ALU_command    :  std_logic_vector(5 downto 0);
    signal s_ALU_operand1   :  std_logic_vector(c_ALU_NBIT-1 downto 0);
    signal s_ALU_operand2   :  std_logic_vector(c_ALU_NBIT-1 downto 0);
    signal s_ALU_result     :  std_logic_vector(c_ALU_NBIT-1 downto 0);

begin

    UUT : ALU
        generic map(
            ALU_NBIT    => c_ALU_NBIT)
        port map(
            ALU_command    => s_ALU_command,
            ALU_operand1   => s_ALU_operand1,
            ALU_operand2   => s_ALU_operand2,
            ALU_result     => s_ALU_result);

    INPUT_STIMULI_PROCESS : process
    begin
        s_ALU_operand1 <= x"00231ac3";
        s_ALU_operand2 <= x"f209401d";

        ALU_COMMANDS : for i in 0 to 63 loop
            s_ALU_command   <=  std_logic_vector(to_unsigned(i,6));
            wait for 1 ns;
        end loop;
        wait;
    end process;

end TEST;
