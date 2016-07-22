library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.REGF_pkg.all;

entity bit_multiplexer is
    generic(
        BIT_MUX_NSEL    :   integer :=  3);
    port(
        BIT_MUX_inputs  :   in  std_logic_vector(2**BIT_MUX_NSEL - 1 downto 0);
        BIT_MUX_select  :   in  std_logic_vector(BIT_MUX_NSEL-1 downto 0);
        BIT_MUX_output  :   out std_logic);
end bit_multiplexer;

architecture dflow of bit_multiplexer is
begin

   BIT_MUX_output <= BIT_MUX_inputs(to_integer(unsigned(BIT_MUX_select)));

end dflow;

configuration CFG_BIT_MULTIPLEXER_DFLOW of bit_multiplexer is
    for dflow
    end for;
end CFG_BIT_MULTIPLEXER_DFLOW;
