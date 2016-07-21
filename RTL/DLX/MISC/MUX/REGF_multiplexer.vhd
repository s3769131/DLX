library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.REGF_pkg.all;

entity REGF_multiplexer is
    generic(
        MUX_NBIT    :   integer :=  1;
        MUX_NSEL    :   integer :=  2);
    port(
        MUX_inputs  :   in  bus_array(2**MUX_NSEL-1 downto 0, MUX_NBIT-1 downto 0);
        MUX_select  :   in  std_logic_vector(MUX_NSEL-1 downto 0);
        MUX_output  :   out std_logic_vector(MUX_NBIT-1 downto 0));
end REGF_multiplexer;

architecture dflow of REGF_multiplexer is
begin
--    MUX_output  <=
--        MUX_inputs((to_integer(unsigned(MUX_select))+1)*MUX_NBIT-1 downto to_integer(unsigned(MUX_select))*MUX_NBIT);
 
MUX_GEN : for i in 0 to MUX_NBIT-1 generate
   MUX_output(i) <= MUX_inputs(to_integer(unsigned(MUX_select)), i);
 end generate;
end dflow;

configuration CFG_REGF_MULTIPLEXER_DFLOW of REGF_multiplexer is
    for dflow
    end for;
end CFG_REGF_MULTIPLEXER_DFLOW;
