library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

entity ALU_control is
   port(
      ALU_CTRL_command  :  in    std_logic_vector(5 downto 0);
      ALU_CTRL_shf_lr   :  out   std_logic;
      ALU_CTRL_shf_la   :  out   std_logic;
      ALU_CTRL_add_sub  :  out   std_logic;
      ALU_CTRL_comp_sel :  out   std_logic_vector(1 downto 0);
      ALU_CTRL_res_sel  :  out   std_logic_vector(1 downto 0);
      ALU_CTRL_log_func :  out   std_logic_vector(3 downto 0));
end ALU_control;

architecture dflow of ALU_control is
begin

   ALU_CTRL_res_sel  <= ALU_CTRL_command(1 downto 0);
   ALU_CTRL_log_func <= ALU_CTRL_command(5 downto 2);
   ALU_CTRL_comp_sel <= ALU_CTRL_command(4 downto 3);
   ALU_CTRL_add_sub  <= ((not ALU_CTRL_command(0)) and ALU_CTRL_command(1)) or ALU_CTRL_command(2);
   ALU_CTRL_shf_lr   <= ALU_CTRL_command(4);
   ALU_CTRL_shf_la   <= ALU_CTRL_command(5);

end dflow;

configuration CFG_ALU_CONTROL_DFLOW of ALU_control is
   for dflow
   end for;
end CFG_ALU_CONTROL_DFLOW;
