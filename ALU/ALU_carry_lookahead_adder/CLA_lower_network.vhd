library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

--!   \brief   Generates the carries, which are the output of the carry look-ahead unit.
--!
--!   This entity models the network that generates the carries which are the output of the
--!   carry look-ahead unit. The lower network can be implemented in various form, here the
--!   Kogge-Stone architecture is chosen.
entity CLA_lower_network is
      generic(
         CLA_LN_N   :   integer :=  4);   --!   numeber of carries generated for the sum.
      port(
         CLA_LN_partial_carry_p  :  in    std_logic_vector(CLA_LN_N-1 downto 0); --!   propagate signals input from the
                                                                                 --!   upper network.
         CLA_LN_partial_carry_g  :  in    std_logic_vector(CLA_LN_N-1 downto 0); --!   generate signals input from the
                                                                                 --!   upper network.
         CLA_LN_final_carries    :  out   std_logic_vector(CLA_LN_N-1 downto 0)  --!   final carries.
      );
end CLA_lower_network;

architecture kogge_stone of CLA_lower_network is

   component general_generate_propagate is
      port(
         GP_Pik   :  in    std_logic;
         GP_Gik   :  in    std_logic;
         GP_Pk_1j :  in    std_logic;
         GP_Gk_1j :  in    std_logic;
         GP_Pij   :  out   std_logic;
         GP_Gij   :  out   std_logic);
   end component;

   type std_logic_matrix is array (CLA_LN_N-1 downto 0) of std_logic_vector(CLA_LN_N-1 downto 0);

   constant N_LEVEL  :  integer  := log2ceil(CLA_LN_N);

   signal P_matrix   :  std_logic_matrix  := (others  => (others  => '0'));
   signal G_matrix   :  std_logic_matrix  := (others  => (others  => '0'));

begin
      CLA_LN_BINDING_GEN : for i in CLA_LN_N-1 downto 0 generate
         P_matrix(i)(i) <= CLA_LN_partial_carry_p(i);
         G_matrix(i)(i) <= CLA_LN_partial_carry_g(i);
      end generate;

      CLA_LN_GEN_LEVEL : for l in N_LEVEL-1 downto 0 generate
         CLA_LN_GEN_ELEMENT : for e in CLA_LN_N-1 downto 2**(N_LEVEL-1-l) generate
            CLA_LN_GEN_CARRY : if e-2**(N_LEVEL-l)+1 <= 0 generate
               GGP: general_generate_propagate
                  port map (
                     GP_Pik   => P_matrix(e)(e-2**(N_LEVEL-1-l)+1),
                     GP_Gik   => G_matrix(e)(e-2**(N_LEVEL-1-l)+1),
                     GP_Pk_1j => P_matrix(e-2**(N_LEVEL-1-l))(0),
                     GP_Gk_1j => G_matrix(e-2**(N_LEVEL-1-l))(0),
                     GP_Pij   => P_matrix(e)(0),
                     GP_Gij   => G_matrix(e)(0)
                     );
            end generate;
            CLA_LN_GEN_OTHER : if e-2**(N_LEVEL-l)+1 > 0 generate
               GGP: general_generate_propagate
                  port map (
                     GP_Pik   => P_matrix(e)(e-2**(N_LEVEL-1-l)+1),
                     GP_Gik   => G_matrix(e)(e-2**(N_LEVEL-1-l)+1),
                     GP_Pk_1j => P_matrix(e-2**(N_LEVEL-1-l))(e-2**(N_LEVEL-l)+1),
                     GP_Gk_1j => G_matrix(e-2**(N_LEVEL-1-l))(e-2**(N_LEVEL-l)+1),
                     GP_Pij   => P_matrix(e)(e-2**(N_LEVEL-l)+1),
                     GP_Gij   => G_matrix(e)(e-2**(N_LEVEL-l)+1)
                     );
            end generate;
         end generate;
      end generate;

      CLA_LN_OUTPUT_GEN : for i in 0 to CLA_LN_N-1 generate
         CLA_LN_final_carries(i) <= G_matrix(i)(0);
      end generate;

end kogge_stone;

configuration CFG_CLA_LN_KOGGE_STONE of CLA_lower_network is
   for kogge_stone
      for CLA_LN_BINDING_GEN
      end for;
      for CLA_LN_GEN_LEVEL
         for CLA_LN_GEN_ELEMENT
            for CLA_LN_GEN_CARRY
               for GGP : general_generate_propagate
                  use configuration work.CFG_GENERAL_GENERATE_PROPAGATE_DFLOW;
               end for;
            end for;
            for CLA_LN_GEN_OTHER
               for GGP : general_generate_propagate
                  use configuration work.CFG_GENERAL_GENERATE_PROPAGATE_DFLOW;
               end for;
            end for;
         end for;
      end for;
      for CLA_LN_OUTPUT_GEN
      end for;
   end for;
end configuration CFG_CLA_LN_KOGGE_STONE;
