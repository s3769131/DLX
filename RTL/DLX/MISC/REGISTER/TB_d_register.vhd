library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_d_register is
end TB_d_register;

architecture TEST of TB_d_register is

    component d_register is
        generic(
            REG_NBIT    :   integer :=  8);
        port(
            REG_clk         :   in  std_logic;
            REG_rst         :   in  std_logic;
            REG_clr         :   in  std_logic;
            REG_enable      :   in  std_logic;
            REG_data_in     :   in  std_logic_vector(REG_NBIT-1 downto 0);
            REG_data_out    :   out std_logic_vector(REG_NBIT-1 downto 0));
    end component;

    constant c_REG_NBIT :   integer :=  4;

    signal  s_REG_clk       :   std_logic                               :=  '0';
    signal  s_REG_rst       :   std_logic                               :=  '0';
    signal  s_REG_clr       :   std_logic                               :=  '0';
    signal  s_REG_enable    :   std_logic                               :=  '0';
    signal  s_REG_data_in   :   std_logic_vector(c_REG_NBIT-1 downto 0) :=  (others => '0');
    signal  s_REG_data_out  :   std_logic_vector(c_REG_NBIT-1 downto 0) :=  (others => '0');

begin

    UUT : d_register
        generic map(
            REG_NBIT    =>  c_REG_NBIT)
        port map(
            REG_clk         =>  s_REG_clk,
            REG_rst         =>  s_REG_rst,
            REG_clr         =>  s_REG_clr,
            REG_enable      =>  s_REG_enable,
            REG_data_in     =>  s_REG_data_in,
            REG_data_out    =>  s_REG_data_out);

    CLOCK_PROCESS : process
    begin
        s_REG_clk   <=  '0';
        wait for 1 ns;
        s_REG_clk   <=  '1';
        wait for 1 ns;
    end process;

    INPUT_STIMULI_PROCESS : process
    begin
        s_REG_rst       <= '0';
        s_REG_clr       <= '0';
        s_REG_enable    <= '0';
        s_REG_data_in   <= (others => '0');
        wait for 2.5 ns;

        s_REG_rst       <= '1';
        s_REG_data_in   <=  x"f";
        wait for 1 ns;
        s_REG_enable    <= '1';
        wait for 1 ns;
        s_REG_data_in   <=  x"a";
        wait;
    end process;

end TEST;
