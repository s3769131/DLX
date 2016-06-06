library ieee;
use ieee.std_logic_1164.all;

--! CARRY_SELECT_ADDER
--  this is the entity that models a carry select adder, with a parallelism of
--  CSEA_N.
entity CARRY_SELECT_ADDER is
  generic(
    CSEA_N : integer := 4);             -- parallelism of the carry select adder
  port(
    CSEA_OP1  : in  std_logic_vector(CSEA_N - 1 downto 0);
    CSEA_OP2  : in  std_logic_vector(CSEA_N - 1 downto 0);
    CSEA_CIN  : in  std_logic;
    CSEA_RES  : out std_logic_vector(CSEA_N - 1 downto 0);
    CSEA_COUT : out std_logic);
end CARRY_SELECT_ADDER;

architecture STR of CARRY_SELECT_ADDER is
  component RIPPLE_CARRY_ADDER is
    generic(
      RCA_N : integer := 4);
    port(
      RCA_OP1  : in  std_logic_vector(RCA_N - 1 downto 0);
      RCA_OP2  : in  std_logic_vector(RCA_N - 1 downto 0);
      RCA_CIN  : in  std_logic;
      RCA_RES  : out std_logic_vector(RCA_N - 1 downto 0);
      RCA_COUT : out std_logic);
  end component RIPPLE_CARRY_ADDER;

  component BIT_MUX21 is
    port(
      PORT_0   : in  std_logic;         -- first port of the multiplexer.
      PORT_1   : in  std_logic;         -- second port of the multiplexer.
      SEL      : in  std_logic;         -- selection bit.
      PORT_OUT : out std_logic);        -- output port of the multiplexer.
  end component;

  component MUX21 is
    generic(
      MUX21_N : integer := 4);
    port(
      PORT_0   : in  std_logic_vector(MUX21_N - 1 downto 0);
      PORT1    : in  std_logic_vector(MUX21_N - 1 downto 0);
      SEL      : in  std_logic;
      PORT_OUT : out std_logic_vector(MUX21_N - 1 downto 0));
  end component;

  signal sum_rca_0  : std_logic_vector(CSEA_N - 1 downto 0);
  signal sum_rca_1  : std_logic_vector(CSEA_N - 1 downto 0);
  signal cout_rca_0 : std_logic;
  signal cout_rca_1 : std_logic;

begin
  -- first ripple carry adder, which uses '0' as carry input.
  RCA_0 : RIPPLE_CARRY_ADDER
    generic map(
      RCA_N => CSEA_N)
    port map(
      RCA_OP1  => CSEA_OP1,
      RCA_OP2  => CSEA_OP2,
      RCA_CIN  => '0',
      RCA_RES  => sum_rca_0,
      RCA_COUT => cout_rca_0);

  -- second ripple carry adder, which uses a '1' as carry input.
  RCA_1 : RIPPLE_CARRY_ADDER
    generic map(
      RCA_N => CSEA_N)
    port map(
      RCA_OP1  => CSEA_OP1,
      RCA_OP2  => CSEA_OP2,
      RCA_CIN  => '1',
      RCA_RES  => sum_rca_1,
      RCA_COUT => cout_rca_1);

  -- selects the correct carry out for the adder, given the real carry in.
  CARRY_MUX : BIT_MUX21
    port map(
      PORT_0   => cout_rca_0,
      PORT_1   => cout_rca_1,
      SEL      => CSEA_CIN,
      PORT_OUT => CSEA_COUT);

  -- selects the correct result of the addition, given the real carry in.
  SUM_MUX : MUX21
    generic map(
      MUX21_N => CSEA_N)
    port map(
      PORT_0   => sum_rca_0,
      PORT1    => sum_rca_1,
      SEL      => CSEA_CIN,
      PORT_OUT => CSEA_RES);

end STR;

--configuration CFG_CARRY_SELECT_ADDER_STR of carry_select_adder is
--  for structural
--    for RCA_0 : ripple_carry_adder
--      use configuration work.CFG_RIPPLE_CARRY_ADDER_STR;
--    end for;
--    for RCA_1 : ripple_carry_adder
--      use configuration work.CFG_RIPPLE_CARRY_ADDER_STR;
--    end for;
--    for CARRY_MUX : bit_mux2to1
--      use configuration work.CFG_BIT_MUX2TO1_DFLOW;
--    end for;
--    for SUM_MUX : mux2to1
--      use configuration work.CFG_MUX2TO1_STR;
--    end for;
--  end for;    
--end configuration CFG_CARRY_SELECT_ADDER_STR;
