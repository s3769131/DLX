library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.REGF_pkg.all;

entity REGF_multiplexer is
    generic(
        MUX_NBIT    :   integer :=  4;
        MUX_NSEL    :   integer :=  3);
    port(
        MUX_inputs  :   in  std_logic_vector(2**MUX_NSEL * MUX_NBIT - 1 downto 0);
        MUX_select  :   in  std_logic_vector(MUX_NSEL-1 downto 0);
        MUX_output  :   out std_logic_vector(MUX_NBIT-1 downto 0));
end REGF_multiplexer;

architecture dflow of REGF_multiplexer is
signal tmp_bus : bus_array (2**MUX_NSEL - 1 downto 0, MUX_NBIT - 1 downto 0);
begin
  TRANSLATION_ROW : for i in 0 to 2**MUX_NSEL - 1 generate
    TRANSLATTION_COL : for j in 0 to MUX_NBIT - 1 generate
      tmp_bus(i, j) <= MUX_inputs (i * (MUX_NBIT) + j);
    end generate;
  end generate;

MUX_GEN : for i in 0 to MUX_NBIT-1 generate
   MUX_output(i) <= tmp_bus(to_integer(unsigned(MUX_select)), i);
 end generate;
end dflow;

configuration CFG_REGF_MULTIPLEXER_DFLOW of REGF_multiplexer is
    for dflow
    end for;
end CFG_REGF_MULTIPLEXER_DFLOW;
