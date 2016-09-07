library ieee;
use ieee.std_logic_1164.all;

entity NPC_selector is
    generic(
        NPC_SEL_IR_NBIT   :   integer :=  32);
    port (
        NPC_SEL_ir          :   in  std_logic_vector(NPC_SEL_IR_NBIT-1 downto 0);
        NPC_SEL_out         :   out std_logic_vector(1 downto 0));
end NPC_selector;

architecture bhv of NPC_selector is

begin
    NPC_SEL_out(1)  <=  '0';
    NPC_SEL_out(0)  <=  '0';
end bhv;

configuration CFG_NPC_SELECTOR_BHV of NPC_selector is
    for bhv
    end for;
end CFG_NPC_SELECTOR_BHV;
