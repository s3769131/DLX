library ieee;
use ieee.std_logic_1164.all;
use work.CU_pkg.all;

package FETCH_pkg is

    constant    FETCH_CTRL_SELECT_NPC          :   std_logic_vector(1 downto 0)    :=  "00";
    constant    FETCH_CTRL_SELECT_BTB_TARGET   :   std_logic_vector(1 downto 0)    :=  "01";
    constant    FETCH_CTRL_SELECT_ALU_OUT      :   std_logic_vector(1 downto 0)    :=  "10";

end FETCH_pkg;

package body FETCH_pkg is

end FETCH_pkg;
