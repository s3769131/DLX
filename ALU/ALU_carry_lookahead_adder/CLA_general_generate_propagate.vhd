library ieee;
use ieee.std_logic_1164.all;

--!   \brief   Generates the propagate and generate signals given other two generate and propagate signals.
--!
--!   This entity models a unit for computing propagate and generate signals given other two
--!   generate and propagate signals. Those could be single bit propagate and generate, or propagate and generate
--!   related to a larger interval of bits. This entity is the basis for the \file CLA_upper_network element and
--!   \file CLA_lower_network entities. The first interval of bits are thos from index i to intex k, the second from
--!   index k-1 to index j.
entity general_generate_propagate is
   port(
      GP_Pik   :  in    std_logic;  --!   propagate signal for the first group of bits.
      GP_Gik   :  in    std_logic;  --!   generate signal for the first group of bits.
      GP_Pk_1j :  in    std_logic;  --!   propagate signal for the second group of bits.
      GP_Gk_1j :  in    std_logic;  --!   generate signal for the second group of bits.
      GP_Pij   :  out   std_logic;  --!   propagate signal related to the group made by the merging of the previous two.
      GP_Gij   :  out   std_logic   --!   generate signal related to the group made by the merging of the previous two.
   );
end general_generate_propagate;

architecture dflow of general_generate_propagate is
begin
   GP_Pij   <= GP_Pik and GP_Pk_1j;
   GP_Gij   <= GP_Gik or (GP_Pik and GP_Gk_1j);
end dflow;

configuration CFG_GENERAL_GENERATE_PROPAGATE_DFLOW of general_generate_propagate is
   for dflow
   end for;
end configuration CFG_GENERAL_GENERATE_PROPAGATE_DFLOW;
