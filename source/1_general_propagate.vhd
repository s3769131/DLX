library ieee;
use ieee.std_logic_1164.all;

--! GENERAL_PROPAGATE
--  models a general propagate block, used in the generation of the sparse tree
--  carry generator unit. It is described with a data flow style.
entity general_propagate is
  port(
    GP_Pik	    :	in	std_logic;
    GP_Gik	    :	in	std_logic;
    GP_Pk_1j	:	in	std_logic;
    GP_Gk_1j	:	in	std_logic;
    GP_Pij      :	out std_logic;
    GP_Gij	    :	out	std_logic);
end general_propagate;

architecture dflow of general_propagate is
begin
  GP_Pij <= GP_Pik and GP_Pk_1j;
  GP_Gij <= GP_Gik or (GP_Pik and GP_Gk_1j);
end dflow;

configuration CFG_GENERAL_PROPAGATE_DFLOW of general_propagate is
  for dflow
  end for;
end configuration CFG_GENERAL_PROPAGATE_DFLOW;
