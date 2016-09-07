library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.DLX_pkg.all;

entity TB_fetch is
end TB_fetch;

architecture TEST of TB_fetch is

    component fetch is
        generic (
            FETCH_PC_NBIT   :   integer :=  32;
            FETCH_IR_NBIT   :   integer :=  32);
        port (
            FETCH_clk                   :   in  std_logic;
            FETCH_rst                   :   in  std_logic;
            FETCH_pc_enable             :   in  std_logic;
            FETCH_pc_clear              :   in  std_logic;
            FETCH_btb_prediction_in     :   in  std_logic;
            FETCH_btb_target_in         :   in  std_logic_vector(FETCH_PC_NBIT-1 downto 0);
            FETCH_alu_out               :   in  std_logic_vector(FETCH_PC_NBIT-1 downto 0);
            FETCH_ir_in                 :   in  std_logic_vector(FETCH_IR_NBIT-1 downto 0);
            FETCH_ir_out                :   out std_logic_vector(FETCH_IR_NBIT-1 downto 0);
            FETCH_pc                    :   out std_logic_vector(FETCH_PC_NBIT-1 downto 0);
            FETCH_npc                   :   out std_logic_vector(FETCH_PC_NBIT-1 downto 0);
            FETCH_btb_prediction_out    :   out std_logic;
            FETCH_btb_target_out        :   out std_logic_vector(FETCH_PC_NBIT-1 downto 0));
    end component;

    constant c_FETCH_PC_NBIT    :   integer :=  8;
    constant c_FETCH_IR_NBIT    :   integer :=  8;

    signal s_FETCH_clk                   :  std_logic;
    signal s_FETCH_rst                   :  std_logic;
    signal s_FETCH_pc_enable             :  std_logic;
    signal s_FETCH_pc_clear              :  std_logic;
    signal s_FETCH_btb_prediction_in     :  std_logic;
    signal s_FETCH_btb_target_in         :  std_logic_vector(c_FETCH_PC_NBIT-1 downto 0);
    signal s_FETCH_alu_out               :  std_logic_vector(c_FETCH_PC_NBIT-1 downto 0);
    signal s_FETCH_ir_in                 :  std_logic_vector(c_FETCH_IR_NBIT-1 downto 0);
    signal s_FETCH_ir_out                :  std_logic_vector(c_FETCH_IR_NBIT-1 downto 0);
    signal s_FETCH_pc                    :  std_logic_vector(c_FETCH_PC_NBIT-1 downto 0);
    signal s_FETCH_npc                   :  std_logic_vector(c_FETCH_PC_NBIT-1 downto 0);
    signal s_FETCH_btb_prediction_out    :  std_logic;
    signal s_FETCH_btb_target_out        :  std_logic_vector(c_FETCH_PC_NBIT-1 downto 0);

begin

    UUT : fetch
        generic map(
            FETCH_PC_NBIT   =>  c_FETCH_PC_NBIT,
            FETCH_IR_NBIT   =>  c_FETCH_IR_NBIT)
        port map(
            FETCH_clk                   =>  s_FETCH_clk,
            FETCH_rst                   =>  s_FETCH_rst,
            FETCH_pc_enable             =>  s_FETCH_pc_enable,
            FETCH_pc_clear              =>  s_FETCH_pc_clear,
            FETCH_btb_prediction_in     =>  s_FETCH_btb_prediction_in,
            FETCH_btb_target_in         =>  s_FETCH_btb_target_in,
            FETCH_alu_out               =>  s_FETCH_alu_out,
            FETCH_ir_in                 =>  s_FETCH_ir_in,
            FETCH_ir_out                =>  s_FETCH_ir_out,
            FETCH_pc                    =>  s_FETCH_pc,
            FETCH_npc                   =>  s_FETCH_npc,
            FETCH_btb_prediction_out    =>  s_FETCH_btb_prediction_out,
            FETCH_btb_target_out        =>  s_FETCH_btb_target_out);

    CLOCK_PROCESS : process
    begin
        s_FETCH_clk  <= '0';
        wait for 1 ns;
        s_FETCH_clk  <= '1';
        wait for 1 ns;
    end process;

    INPUT_STIMULI_PROCESS : process
    begin
        s_FETCH_rst                 <=  '0';
        s_FETCH_pc_enable           <=  '1';
        s_FETCH_pc_clear            <=  '0';
        s_FETCH_ir_in               <=  (others => '0');
        s_FETCH_btb_prediction_in   <=  '1';
        s_FETCH_btb_target_in       <=  x"ff";
        s_FETCH_alu_out             <=  x"aa";
        wait;
    end process;
end TEST;
