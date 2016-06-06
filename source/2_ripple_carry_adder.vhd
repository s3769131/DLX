library ieee;
use ieee.std_logic_1164.all;

--! RIPPLE_CARRY_ADDER
--  models a ripple carry adder with a generic parallelism.
entity RIPPLE_CARRY_ADDER is
  generic(
    RCA_N : integer := 4);
  port(
    RCA_OP1  : in  std_logic_vector(RCA_N - 1 downto 0);
    RCA_OP2  : in  std_logic_vector(RCA_N - 1 downto 0);
    RCA_CIN  : in  std_logic;
    RCA_RES  : out std_logic_vector(RCA_N - 1 downto 0);
    RCA_COUT : out std_logic);
end RIPPLE_CARRY_ADDER;

architecture STR of RIPPLE_CARRY_ADDER is
  component FULL_ADDER is
    port(
      FA_OP1  : in  std_logic;
      FA_OP2  : in  std_logic;
      FA_CIN  : in  std_logic;
      FA_COUT : out std_logic;
      FA_RES  : out std_logic);
  end component FULL_ADDER;

  signal cout_tmp : std_logic_vector(RCA_N - 1 downto 0);

begin
  RIPPLE_GEN : for i in 0 to RCA_N - 1 generate
    FIRST_GEN : if (i = 0) generate
      FIRST_FA : FULL_ADDER
        port map(
          FA_OP1  => RCA_OP1(i),
          FA_OP2  => RCA_OP2(i),
          FA_CIN  => RCA_CIN,
          FA_COUT => cout_tmp(i),
          FA_RES  => RCA_RES(i));
    end generate FIRST_GEN;

    MIDDLE_GEN : if (i > 0) generate
      MIDDLE_FA : FULL_ADDER
        port map(
          FA_OP1  => RCA_OP1(i),
          FA_OP2  => RCA_OP2(i),
          FA_CIN  => cout_tmp(i - 1),
          FA_COUT => cout_tmp(i),
          FA_RES  => RCA_RES(i));
    end generate;
  end generate RIPPLE_GEN;
  RCA_COUT <= cout_tmp(RCA_N - 1);
end STR;

--configuration CFG_RIPPLE_CARRY_ADDER_STR of RIPPLE_CARRY_ADDER is
--  for structural
--    for RIPPLE_GEN
--      for FIRST_GEN
--        for all : full_adder
--          use configuration work.CFG_FULL_ADDER_DFLOW;
--        end for;
--      end for;
--      for MIDDLE_GEN
--        for all : full_adder
--          use configuration work.CFG_FULL_ADDER_DFLOW;
--        end for;
--      end for;
--    end for;
--  end for;
--end configuration CFG_RIPPLE_CARRY_ADDER_STR;

