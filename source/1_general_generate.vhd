library ieee;
use ieee.std_logic_1164.all;

--! GENERAL_GENERATE
--  models a general generate unit, used in the generation of the sparse tree
--  carry generator. The unit is described with a data flow style.
entity general_generate is
  port(
    G_Pik	:	in	std_logic;
    G_Gik	:	in	std_logic;
    G_Gk_1j	:	in	std_logic;
    G_Gij	:	out	std_logic);
end general_generate;

architecture dflow of general_generate is
begin	
  G_Gij <= G_Gik or (G_Pik and G_Gk_1j);
end dflow;

configuration CFG_GENERAL_GENERATE_DFLOW of general_generate is
  for dflow
  end for;
end configuration CFG_GENERAL_GENERATE_DFLOW;
