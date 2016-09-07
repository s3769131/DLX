library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.DLX_pkg.all;

entity TB_btb is
end TB_btb;

architecture TEST of TB_btb is

    component btb is
        generic(
            BTB_NENTRY      :   integer :=  8;
            BTB_TARGET_NBIT :   integer :=  8;
            BTB_BHT_NBIT    :   integer :=  2);
        port(
            BTB_clk                 :   in  std_logic;
            BTB_rst                 :   in  std_logic;
            BTB_enable              :   in  std_logic;
            BTB_wrong_target        :   in  std_logic;
            BTB_wrong_prediction    :   in  std_logic;
            BTB_addr_write          :   in  std_logic_vector(log2ceil(BTB_NENTRY)-1 downto 0);
            BTB_target_write        :   in  std_logic_vector(BTB_TARGET_NBIT-1 downto 0);
            BTB_addr_read           :   in  std_logic_vector(log2ceil(BTB_NENTRY)-1 downto 0);
            BTB_prediction          :   out std_logic;
            BTB_target_prediction   :   out std_logic_vector(BTB_TARGET_NBIT-1 downto 0));
    end component;

    constant c_BTB_NENTRY       :   integer :=  4;
    constant c_BTB_TARGET_NBIT  :   integer :=  4;
    constant c_BTB_BHT_NBIT     :   integer :=  2;

    signal s_BTB_clk                :   std_logic                                               :=  '0';
    signal s_BTB_rst                :   std_logic                                               :=  '0';
    signal s_BTB_enable             :   std_logic                                               :=  '0';
    signal s_BTB_wrong_target       :   std_logic                                               :=  '0';
    signal s_BTB_wrong_prediction   :   std_logic                                               :=  '0';
    signal s_BTB_addr_write         :   std_logic_vector(log2ceil(c_BTB_NENTRY)-1 downto 0)     :=  (others => '0');
    signal s_BTB_target_write       :   std_logic_vector(c_BTB_TARGET_NBIT-1 downto 0)          :=  (others => '0');
    signal s_BTB_addr_read          :   std_logic_vector(log2ceil(c_BTB_NENTRY)-1 downto 0)     :=  (others => '0');
    signal s_BTB_prediction         :   std_logic                                               :=  '0';
    signal s_BTB_target_prediction  :   std_logic_vector(c_BTB_TARGET_NBIT-1 downto 0)          :=  (others => '0');

begin

    UUT : btb
        generic map(
            BTB_NENTRY      =>  c_BTB_NENTRY,
            BTB_TARGET_NBIT =>  c_BTB_TARGET_NBIT,
            BTB_BHT_NBIT    =>  c_BTB_BHT_NBIT)
        port map(
            BTB_clk                 =>  s_BTB_clk,
            BTB_rst                 =>  s_BTB_rst,
            BTB_enable              =>  s_BTB_enable,
            BTB_wrong_target        =>  s_BTB_wrong_target,
            BTB_wrong_prediction    =>  s_BTB_wrong_prediction,
            BTB_addr_write          =>  s_BTB_addr_write,
            BTB_target_write        =>  s_BTB_target_write,
            BTB_addr_read           =>  s_BTB_addr_read,
            BTB_prediction          =>  s_BTB_prediction,
            BTB_target_prediction   =>  s_BTB_target_prediction);

    CLOCK_PROCESS : process
    begin
        CLK_LOOP : for i in 0 to 50 loop
            s_BTB_clk   <=  '0';
            wait for 1 ns;
            s_BTB_clk   <=  '1';
            wait for 1 ns;
        end loop;
        wait;
    end process;

    INPUT_STIMULI_PROCESS : process
    begin
        s_BTB_rst               <=  '0';
        s_BTB_enable            <=  '0';
        s_BTB_wrong_target      <=  '0';
        s_BTB_wrong_prediction  <=  '0';
        wait for 2 ns;
        s_BTB_rst       <=  '1';
        s_BTB_enable    <=  '1';
        wait for 2 ns;
        LOAD_VALUES : for i in 0 to c_BTB_NENTRY-1 loop
            s_BTB_addr_write    <=  std_logic_vector(to_unsigned(i,log2ceil(c_BTB_NENTRY)));
            s_BTB_target_write  <=  std_logic_vector(to_unsigned(i,c_BTB_TARGET_NBIT));
            wait for 2 ns;
        end loop;
        s_BTB_enable    <=  '0';
        READ_VALUES : for i in 0 to c_BTB_NENTRY-1 loop
            s_BTB_addr_read  <=  std_logic_vector(to_unsigned(i,log2ceil(c_BTB_NENTRY)));
            wait for 2 ns;
        end loop;
        s_BTB_enable        <=  '1';
        s_BTB_addr_read     <=  std_logic_vector(to_unsigned(3,log2ceil(c_BTB_NENTRY)));
        s_BTB_wrong_target  <=  '1';
        s_BTB_addr_write    <=  std_logic_vector(to_unsigned(3,log2ceil(c_BTB_NENTRY)));
        s_BTB_target_write  <=  std_logic_vector(to_unsigned(10,c_BTB_TARGET_NBIT));
        wait for 2 ns;
        s_BTB_wrong_prediction  <=  '1';
        s_BTB_wrong_target      <=  '0';
        wait for 4 ns;
        s_BTB_wrong_prediction  <=  '0';
        s_BTB_wrong_target      <=  '0';
        s_BTB_enable            <=  '0';
        wait;
    end process;

end TEST;
