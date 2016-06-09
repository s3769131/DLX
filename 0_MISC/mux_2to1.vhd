library ieee;
use ieee.std_logic_1164.all;

entity mux_2to1 is
   generic (
      MUX_2to1_NBIT :  integer  := 4);
   port (
      MUX_2to1_in0  :  in    std_logic_vector(MUX_2to1_NBIT-1 downto 0);
      MUX_2to1_in1  :  in    std_logic_vector(MUX_2to1_NBIT-1 downto 0);
      MUX_2to1_sel  :  in    std_logic;
      MUX_2to1_out  :  out   std_logic_vector(MUX_2to1_NBIT-1 downto 0));
end entity mux_2to1;

architecture bhv of mux_2to1 is
begin

   MAIN : process(MUX_2to1_in0, MUX_2to1_in1, MUX_2to1_sel)
   begin
      if MUX_2to1_sel = '0' then
         MUX_2to1_out  <= MUX_2to1_in0;
      elsif MUX_2to1_sel = '1' then
         MUX_2to1_out  <= MUX_2to1_in1;
      end if;
   end process;

end architecture bhv;

configuration CFG_MUX_2to1_BHV of mux_2to1 is
   for bhv
   end for;
end configuration CFG_MUX_2to1_BHV;
