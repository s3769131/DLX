library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

--!   \brief   Generates the propagate and generate signals for an interval of bits.
--!
--!   This entity models the network that generates the propagate and generate signals for
--!   a number of bits equal to the carry step value implemented by the look-ahead logic.
entity CLA_upper_network_element is
   generic(
      CLA_UNE_N   :   integer :=  4);  --!   the carry step, i.e. every how many bit a carry is computed.
   port(
      CLA_UNE_p_in   :  in    std_logic_vector(CLA_UNE_N-1 downto 0);   --!   propagate signals from the pg network.
      CLA_UNE_g_in   :  in    std_logic_vector(CLA_UNE_N-1 downto 0);   --!   generate signals from the pg network.
      CLA_UNE_p_out  :  out   std_logic;                                --!   propagate bit to the lower network.
      CLA_UNE_g_out  :  out   std_logic                                 --!   generate bit to the lower network.
      );
end CLA_upper_network_element;

architecture structural of CLA_upper_network_element is

   component general_generate_propagate is
      port(
         GP_Pik   :  in    std_logic;
         GP_Gik   :  in    std_logic;
         GP_Pk_1j :  in    std_logic;
         GP_Gk_1j :  in    std_logic;
         GP_Pij   :  out   std_logic;
         GP_Gij   :  out   std_logic);
   end component;

   type std_logic_matrix is array (CLA_UNE_N-1 downto 0) of std_logic_vector(CLA_UNE_N-1 downto 0);

   constant N_LEVEL  :  integer  := log2ceil(CLA_UNE_N);

   signal P_matrix   :  std_logic_matrix  := (others => (others => '0'));
   signal G_matrix   :  std_logic_matrix  := (others => (others => '0'));

begin

   CLA_UNE_BINDING_GEN : for i in CLA_UNE_N-1 downto 0 generate
      P_matrix(i)(i) <= CLA_UNE_p_in(i);
      G_matrix(i)(i) <= CLA_UNE_g_in(i);
   end generate;

   CLA_UNE_GEN_LEVEL : for l in N_LEVEL-1 downto 0 generate
      CLA_UNE_GEN_ELEMENT : for e in CLA_UNE_N/(2**(N_LEVEL-l)) downto 1 generate
         GGP: general_generate_propagate
            port map (
               GP_Pik   => P_matrix(e*(2**(N_LEVEL-l))-1)((2*e-1)*2**(N_LEVEL-1-l)),
               GP_Gik   => G_matrix(e*(2**(N_LEVEL-l))-1)((2*e-1)*2**(N_LEVEL-1-l)),
               GP_Pk_1j => P_matrix((2*e-1)*2**(N_LEVEL-1-l)-1)((2**(N_LEVEL-l))*(e-1)),
               GP_Gk_1j => G_matrix((2*e-1)*2**(N_LEVEL-1-l)-1)((2**(N_LEVEL-l))*(e-1)),
               GP_Pij   => P_matrix(e*(2**(N_LEVEL-l))-1)((2**(N_LEVEL-l))*(e-1)),
               GP_Gij   => G_matrix(e*(2**(N_LEVEL-l))-1)((2**(N_LEVEL-l))*(e-1))
            );
      end generate;
   end generate;

   CLA_UNE_p_out <= P_matrix(CLA_UNE_N-1)(0);
   CLA_UNE_g_out <= G_matrix(CLA_UNE_N-1)(0);

end structural;

configuration CFG_CLA_UNE_STR of CLA_upper_network_element is
   for structural
      for CLA_UNE_BINDING_GEN
      end for;
      for CLA_UNE_GEN_LEVEL
         for CLA_UNE_GEN_ELEMENT
         end for;
      end for;
   end for;
end configuration CFG_CLA_UNE_STR;
