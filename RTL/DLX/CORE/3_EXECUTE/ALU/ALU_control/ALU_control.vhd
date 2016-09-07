library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

entity ALU_control is
    port(
        ALU_CTRL_command    :   in  std_logic_vector(5 downto 0);
        ALU_CTRL_shf_lr     :   out std_logic;
        ALU_CTRL_shf_la     :   out std_logic;
        ALU_CTRL_add_sub    :   out std_logic;
        ALU_CTRL_comp_sel   :   out std_logic_vector(2 downto 0);
        ALU_CTRL_res_sel    :   out std_logic_vector(1 downto 0);
        ALU_CTRL_log_func   :   out std_logic_vector(3 downto 0));
end ALU_control;

architecture bhv of ALU_control is
begin

    MAIN : process(ALU_CTRL_command)
    begin
        if ALU_CTRL_command(5 downto 4) = "00" then
            ALU_CTRL_res_sel    <=  "00";
            ALU_CTRL_shf_lr     <=  ALU_CTRL_command(3);
            ALU_CTRL_shf_la     <=  ALU_CTRL_command(2);
        elsif ALU_CTRL_command(5 downto 4) = "01" then
            ALU_CTRL_res_sel    <=  "01";
            ALU_CTRL_add_sub    <=  ALU_CTRL_command(3);
        elsif ALU_CTRL_command(5 downto 4) = "10" then
            ALU_CTRL_res_sel    <=  "10";
            ALU_CTRL_comp_sel   <=  ALU_CTRL_command(3 downto 1);
        elsif ALU_CTRL_command(5 downto 4) = "11" then
            ALU_CTRL_res_sel    <=  "11";
            ALU_CTRL_log_func   <=  ALU_CTRL_command(3 downto 0);
        end if;
    end process;
end bhv;

configuration CFG_ALU_CONTROL_BHV of ALU_control is
    for bhv
    end for;
end CFG_ALU_CONTROL_BHV;
