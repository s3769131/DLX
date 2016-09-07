library ieee;
use ieee.std_logic_1164.all;
use work.DLX_pkg.all;

--!   \brief   Carry look-ahead network.
--!
--!   This entity models the carry look-ahead network for an adder. It takes as input the two operand and the
--!   carry in bit, and produces the carries out, one each CLA_CARRY_STEP positions. This unit is implemented
--!   structurally, and require the following units:
--!   \file CLA_general_generate_propagate.vhd
--!   \file CLA_pg_network.vhd
--!   \file CLA_upper_network_element.vhd
--!   \file CLA_lower_network.vhd
entity CLA_carry_generator is
    generic(
        CLA_CGEN_NBIT       :   integer := 16;   --!   parallelism of the input operands.
        CLA_CGEN_CARRY_STEP :   integer := 4);   --!   step in carries generation.
    port(
        CLA_CGEN_op1    :   in  std_logic_vector(CLA_CGEN_NBIT-1 downto 0);
        CLA_CGEN_op2    :   in  std_logic_vector(CLA_CGEN_NBIT-1 downto 0);
        CLA_CGEN_cin    :   in  std_logic;
        CLA_CGEN_cout   :   out std_logic_vector(CLA_CGEN_NBIT/CLA_CGEN_CARRY_STEP-1 downto 0));
end CLA_carry_generator;

architecture structural of CLA_carry_generator is

    component CLA_pg_network is
        generic(
            CLA_PGN_N   :   integer :=  32);
        port(
            CLA_PGN_op1 :   in  std_logic_vector(CLA_PGN_N-1 downto 0);
            CLA_PGN_op2 :   in  std_logic_vector(CLA_PGN_N-1 downto 0);
            CLA_PGN_cin :   in  std_logic;
            CLA_PGN_p   :   out std_logic_vector(CLA_PGN_N-1 downto 0);
            CLA_PGN_g   :   out std_logic_vector(CLA_PGN_N-1 downto 0));
    end component;

    component CLA_upper_network_element is
        generic(
            CLA_UNE_N   :   integer := 4);
        port(
            CLA_UNE_p_in    :   in  std_logic_vector(CLA_UNE_N-1 downto 0);
            CLA_UNE_g_in    :   in  std_logic_vector(CLA_UNE_N-1 downto 0);
            CLA_UNE_p_out   :   out std_logic;
            CLA_UNE_g_out   :   out std_logic);
    end component;

    component CLA_lower_network is
        generic(
            CLA_LN_N    :   integer :=  4);
        port(
            CLA_LN_partial_carry_p  :   in  std_logic_vector(CLA_LN_N-1 downto 0);
            CLA_LN_partial_carry_g  :   in  std_logic_vector(CLA_LN_N-1 downto 0);
            CLA_LN_final_carries    :   out std_logic_vector(CLA_LN_N-1 downto 0));
    end component;

   constant N_UP_NETWORK    :   integer :=  CLA_CGEN_NBIT/CLA_CGEN_CARRY_STEP;

   signal s_CLA_CGEN_pg_network_p   :   std_logic_vector(CLA_CGEN_NBIT-1 downto 0);
   signal s_CLA_CGEN_pg_network_g   :   std_logic_vector(CLA_CGEN_NBIT-1 downto 0);
   signal s_CLA_CGEN_up_network_p   :   std_logic_vector(N_UP_NETWORK-1 downto 0);
   signal s_CLA_CGEN_up_network_g   :   std_logic_vector(N_UP_NETWORK-1 downto 0);

begin

    CLA_PG_NET : CLA_pg_network
        generic map(
            CLA_PGN_N   =>  CLA_CGEN_NBIT)
        port map(
            CLA_PGN_op1 =>  CLA_CGEN_op1,
            CLA_PGN_op2 =>  CLA_CGEN_op2,
            CLA_PGN_cin =>  CLA_CGEN_cin,
            CLA_PGN_p   =>  s_CLA_CGEN_pg_network_p,
            CLA_PGN_g   =>  s_CLA_CGEN_pg_network_g);

    CLA_UP_NETWORK_GEN : for i in 1 to N_UP_NETWORK generate
        CLA_UPNET_ELEMENT : CLA_upper_network_element
            generic map(
                CLA_UNE_N   => CLA_CGEN_CARRY_STEP)
            port map(
                CLA_UNE_p_in    =>  s_CLA_CGEN_pg_network_p(i*CLA_CGEN_CARRY_STEP-1 downto (i-1)*CLA_CGEN_CARRY_STEP),
                CLA_UNE_g_in    =>  s_CLA_CGEN_pg_network_g(i*CLA_CGEN_CARRY_STEP-1 downto (i-1)*CLA_CGEN_CARRY_STEP),
                CLA_UNE_p_out   =>  s_CLA_CGEN_up_network_p(i-1),
                CLA_UNE_g_out   =>  s_CLA_CGEN_up_network_g(i-1));
   end generate;

    CLA_LOWER_NET : CLA_lower_network
        generic map(
            CLA_LN_N => CLA_CGEN_NBIT/CLA_CGEN_CARRY_STEP)
        port map(
            CLA_LN_partial_carry_p  => s_CLA_CGEN_up_network_p,
            CLA_LN_partial_carry_g  => s_CLA_CGEN_up_network_g,
            CLA_LN_final_carries    => CLA_CGEN_cout);

end structural;

configuration CFG_CLA_CGEN_STR of CLA_carry_generator is
    for structural
        for CLA_PG_NET : CLA_pg_network
            use configuration work.CFG_CLA_PGN_DFLOW;
        end for;
        for CLA_UP_NETWORK_GEN
            for CLA_UPNET_ELEMENT : CLA_upper_network_element
                use configuration work.CFG_CLA_UNE_STR;
            end for;
        end for;
        for CLA_LOWER_NET : CLA_lower_network
            use configuration work.CFG_CLA_LN_KOGGE_STONE;
        end for;
    end for;
end configuration CFG_CLA_CGEN_STR;
