library ieee;
use ieee.std_logic_1164.all;
use work.DLX_pkg.all;

entity P4_carry_generator is
  generic(
    P4_CG_N     : integer := 32;
    P4_CG_CSTEP : integer := 4);
  port(
    P4_CG_op1  : in  std_logic_vector(P4_CG_N downto 1);
    P4_CG_op2  : in  std_logic_vector(P4_CG_N downto 1);
    P4_CG_cin  : in  std_logic;
    P4_CG_cout : out std_logic_vector(P4_CG_N / P4_CG_CSTEP downto 1));
end P4_carry_generator;

architecture structural of P4_carry_generator is
  component general_generate is
    port(
      G_Pik   : in  std_logic;
      G_Gik   : in  std_logic;
      G_Gk_1j : in  std_logic;
      G_Gij   : out std_logic);
  end component;

  component general_propagate is
    port(
      GP_Pik   : in  std_logic;
      GP_Gik   : in  std_logic;
      GP_Pk_1j : in  std_logic;
      GP_Gk_1j : in  std_logic;
      GP_Pij   : out std_logic;
      GP_Gij   : out std_logic);
  end component;

  type std_logic_matrix is array (P4_CG_N downto 1) of std_logic_vector(P4_CG_N downto 1);

  constant alpha : integer := (P4_CG_N / P4_CG_CSTEP);

  signal P_matrix : std_logic_matrix := (others => (others => '0'));
  signal G_matrix : std_logic_matrix := (others => (others => '0'));

begin
  PG_NETWORK_GEN : for a in P4_CG_N downto 1 generate
    PG_NETWORK_GEN_CIN : if a = 1 generate
      G_matrix(a)(a) <= (P4_CG_op1(a) and P4_CG_op2(a)) or ((P4_CG_op1(a) or P4_CG_op2(a)) and P4_CG_cin);
    end generate;
    PG_NETWORK_GEN_notCIN : if a /= 1 generate
      P_matrix(a)(a) <= P4_CG_op1(a) or P4_CG_op2(a);
      G_matrix(a)(a) <= P4_CG_op1(a) and P4_CG_op2(a);
    end generate;
  end generate;

  CARRY_GEN_GEN_LEVEL : for l in 1 to log2ceil(P4_CG_N) generate
    CARRY_GEN_GEN_CLINE : for t in P4_CG_N / (2 ** l) downto 1 generate
      CARRY_GEN_GEN_GG : if (t - 1) * (2 ** l) + 1 = 1 generate
        GG : general_generate
          port map(
            G_Pik   => P_matrix(t * (2 ** l))(1 + (2 * t - 1) * (2 ** (l - 1))),
            G_Gik   => G_matrix(t * (2 ** l))(1 + (2 * t - 1) * (2 ** (l - 1))),
            G_Gk_1j => G_matrix((2 * t - 1) * (2 ** (l - 1)))((t - 1) * (2 ** l) + 1),
            G_Gij   => G_matrix(t * (2 ** l))((t - 1) * (2 ** l) + 1));
      end generate CARRY_GEN_GEN_GG;
      CARRY_GEN_GEN_GP : if (t - 1) * (2 ** l) + 1 /= 1 generate
        GP : general_propagate
          port map(
            GP_Pik   => P_matrix(t * (2 ** l))(1 + (2 * t - 1) * (2 ** (l - 1))),
            GP_Gik   => G_matrix(t * (2 ** l))(1 + (2 * t - 1) * (2 ** (l - 1))),
            GP_Pk_1j => P_matrix((2 * t - 1) * (2 ** (l - 1)))((t - 1) * (2 ** l) + 1),
            GP_Gk_1j => G_matrix((2 * t - 1) * (2 ** (l - 1)))((t - 1) * (2 ** l) + 1),
            GP_Pij   => P_matrix(t * (2 ** l))((t - 1) * (2 ** l) + 1),
            GP_Gij   => G_matrix(t * (2 ** l))((t - 1) * (2 ** l) + 1));
      end generate CARRY_GEN_GEN_GP;

      CARRY_GEN_SHF_TREE : if l > log2ceil(2 * P4_CG_CSTEP) generate
        CARRY_GEN_CLINE_SHF : for s in 1 to (2 ** (l - 1)) / (P4_CG_CSTEP) - 1 generate
          CARRY_GEN_GEN_GG : if (t - 1) * (2 ** l) + 1 = 1 generate
            GG : general_generate
              port map(
                G_Pik   => P_matrix(t * (2 ** l) - s * P4_CG_CSTEP)(1 + (2 * t - 1) * (2 ** (l - 1))),
                G_Gik   => G_matrix(t * (2 ** l) - s * P4_CG_CSTEP)(1 + (2 * t - 1) * (2 ** (l - 1))),
                G_Gk_1j => G_matrix((2 * t - 1) * (2 ** (l - 1)))((t - 1) * (2 ** l) + 1),
                G_Gij   => G_matrix(t * (2 ** l) - s * P4_CG_CSTEP)((t - 1) * (2 ** l) + 1));
          end generate CARRY_GEN_GEN_GG;
          CARRY_GEN_GEN_GP : if (t - 1) * (2 ** l) + 1 /= 1 generate
            GP : general_propagate
              port map(
                GP_Pik   => P_matrix(t * (2 ** l) - s * P4_CG_CSTEP)(1 + (2 * t - 1) * (2 ** (l - 1))),
                GP_Gik   => G_matrix(t * (2 ** l) - s * P4_CG_CSTEP)(1 + (2 * t - 1) * (2 ** (l - 1))),
                GP_Pk_1j => P_matrix((2 * t - 1) * (2 ** (l - 1)))((t - 1) * (2 ** l) + 1),
                GP_Gk_1j => G_matrix((2 * t - 1) * (2 ** (l - 1)))((t - 1) * (2 ** l) + 1),
                GP_Pij   => P_matrix(t * (2 ** l) - s * P4_CG_CSTEP)((t - 1) * (2 ** l) + 1),
                GP_Gij   => G_matrix(t * (2 ** l) - s * P4_CG_CSTEP)((t - 1) * (2 ** l) + 1));
          end generate CARRY_GEN_GEN_GP;
        end generate CARRY_GEN_CLINE_SHF;
      end generate CARRY_GEN_SHF_TREE;
    end generate CARRY_GEN_GEN_CLINE;
  end generate CARRY_GEN_GEN_LEVEL;

  OUTPUT_GEN : for i in alpha downto 1 generate
    P4_CG_cout(i) <= G_matrix(i * P4_CG_CSTEP)(1);
  end generate;

end structural;


--configuration CFG_P4_CARRY_GENERATOR_STR of P4_carry_generator is
--  for structural
--    for PG_NETWORK_GEN
--      for PG_NETWORK_GEN_CIN
--      end for;
--      for PG_NETWORK_GEN_notCIN
--      end for;
--    end for;
--    for CARRY_GEN_GEN_LEVEL
--      for CARRY_GEN_GEN_CLINE
--        for CARRY_GEN_GEN_GG
--          for all : general_generate
--            use configuration work.CFG_GENERAL_GENERATE_DFLOW;
--          end for;
--        end for;
--        for CARRY_GEN_GEN_GP
--          for all : general_propagate
--            use configuration work.CFG_GENERAL_PROPAGATE_DFLOW;
--          end for;
--        end for;
--        for CARRY_GEN_SHF_TREE
--          for CARRY_GEN_CLINE_SHF
--            for CARRY_GEN_GEN_GG
--              for all : general_generate
--                use configuration work.CFG_GENERAL_GENERATE_DFLOW;
--              end for;
--            end for;
--            for CARRY_GEN_GEN_GP
--              for all : general_propagate
--                use configuration work.CFG_GENERAL_PROPAGATE_DFLOW;
--              end for;
--            end for;
--          end for;
--        end for;
--      end for;
--    end for;
--  end for;
--end configuration CFG_P4_CARRY_GENERATOR_STR;
