library ieee;
use ieee.std_logic_1164.all;

entity bit_mux_2to1 is
   port(
      BIT_MUX_2to1_in0  :  in    std_logic;
      BIT_MUX_2to1_in1  :  in    std_logic;
      BIT_MUX_2to1_sel  :  in    std_logic;
      BIT_MUX_2to1_out  :  out   std_logic);
end entity bit_mux_2to1;

architecture bhv of bit_mux_2to1 is
begin

   MAIN : process(BIT_MUX_2to1_in0, BIT_MUX_2to1_in1, BIT_MUX_2to1_sel)
   begin
      if BIT_MUX_2to1_sel = '0' then
         BIT_MUX_2to1_out  <= BIT_MUX_2to1_in0;
      elsif BIT_MUX_2to1_sel = '1' then
         BIT_MUX_2to1_out  <= BIT_MUX_2to1_in1;
      end if;
   end process;

end architecture bhv;

configuration CFG_BIT_MUX_2to1_BHV of bit_mux_2to1 is
   for bhv
   end for;
end configuration CFG_BIT_MUX_2to1_BHV;
