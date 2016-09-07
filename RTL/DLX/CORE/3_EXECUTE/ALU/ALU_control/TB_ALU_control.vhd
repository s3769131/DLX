library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ALU_pkg.all;

entity TB_ALU_control is
end TB_ALU_control;

architecture TEST of TB_ALU_control is

    component ALU_control is
        port(
            ALU_CTRL_command  :  in    std_logic_vector(5 downto 0);
            ALU_CTRL_shf_lr   :  out   std_logic;
            ALU_CTRL_shf_la   :  out   std_logic;
            ALU_CTRL_add_sub  :  out   std_logic;
            ALU_CTRL_comp_sel :  out   std_logic_vector(2 downto 0);
            ALU_CTRL_res_sel  :  out   std_logic_vector(1 downto 0);
            ALU_CTRL_log_func :  out   std_logic_vector(3 downto 0));
    end component;

    signal s_ALU_CTRL_command  :  std_logic_vector(5 downto 0)  := (others => '0');
    signal s_ALU_CTRL_shf_lr   :  std_logic                     := '0';
    signal s_ALU_CTRL_shf_la   :  std_logic                     := '0';
    signal s_ALU_CTRL_add_sub  :  std_logic                     := '0';
    signal s_ALU_CTRL_comp_sel :  std_logic_vector(2 downto 0)  := (others => '0');
    signal s_ALU_CTRL_res_sel  :  std_logic_vector(1 downto 0)  := (others => '0');
    signal s_ALU_CTRL_log_func :  std_logic_vector(3 downto 0)  := (others => '0');

begin

    UUT : ALU_control
        port map(
            ALU_CTRL_command  => s_ALU_CTRL_command,
            ALU_CTRL_shf_lr   => s_ALU_CTRL_shf_lr,
            ALU_CTRL_shf_la   => s_ALU_CTRL_shf_la,
            ALU_CTRL_add_sub  => s_ALU_CTRL_add_sub,
            ALU_CTRL_comp_sel => s_ALU_CTRL_comp_sel,
            ALU_CTRL_res_sel  => s_ALU_CTRL_res_sel,
            ALU_CTRL_log_func => s_ALU_CTRL_log_func);

    INPUT_STIMULI_PROCESS : process
    begin
        ALU_COMMANDS : for i in 0 to 63 loop
            s_ALU_CTRL_command   <=  std_logic_vector(to_unsigned(i,6));
            wait for 1 ns;
        end loop;
        wait;
   end process;

end TEST;
