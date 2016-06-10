library ieee;
use ieee.std_logic_1164.all;

entity mux_4to1 is
   generic (
      MUX_4to1_NBIT :  integer  := 4);
   port (
      MUX_4to1_in0  :  in    std_logic_vector(MUX_4to1_NBIT-1 downto 0);
      MUX_4to1_in1  :  in    std_logic_vector(MUX_4to1_NBIT-1 downto 0);
      MUX_4to1_in2  :  in    std_logic_vector(MUX_4to1_NBIT-1 downto 0);
      MUX_4to1_in3  :  in    std_logic_vector(MUX_4to1_NBIT-1 downto 0);
      MUX_4to1_sel  :  in    std_logic_vector(1 downto 0);
      MUX_4to1_out  :  out   std_logic_vector(MUX_4to1_NBIT-1 downto 0));
end mux_4to1;

architecture bhv of mux_4to1 is
begin

   MAIN : process(MUX_4to1_in0, MUX_4to1_in1, MUX_4to1_in2, MUX_4to1_in3, MUX_4to1_sel)
   begin
      if MUX_4to1_sel = "00" then
         MUX_4to1_out  <= MUX_4to1_in0;
      elsif MUX_4to1_sel = "01" then
         MUX_4to1_out  <= MUX_4to1_in1;
      elsif MUX_4to1_sel = "10" then
         MUX_4to1_out  <= MUX_4to1_in2;
      elsif MUX_4to1_sel = "11" then
         MUX_4to1_out  <= MUX_4to1_in3;
      end if;
   end process;

end architecture bhv;

configuration CFG_MUX_4to1_BHV of mux_4to1 is
   for bhv
   end for;
end configuration CFG_MUX_4to1_BHV;
