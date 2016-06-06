library ieee;
use ieee.std_logic_1164.all;

entity carry_select_adder is
   generic(
      CSA_NBIT   :  integer  := 4);
   port(
      CSA_op1  :  in    std_logic_vector(CSA_NBIT-1 downto 0);
      CSA_op2  :  in    std_logic_vector(CSA_NBIT-1 downto 0);
      CSA_cin  :  in    std_logic;
      CSA_res  :  out   std_logic_vector(CSA_NBIT-1 downto 0);
      CSA_cout :  out   std_logic);
end carry_select_adder;

architecture str of carry_select_adder is

   component ripple_carry_adder is
      generic(
         RCA_NBIT : integer   := 4);
      port(
         RCA_op1  :  in    std_logic_vector(RCA_NBIT-1 downto 0);
         RCA_op2  :  in    std_logic_vector(RCA_NBIT-1 downto 0);
         RCA_cin  :  in    std_logic;
         RCA_res  :  out   std_logic_vector(RCA_NBIT-1 downto 0);
         RCA_cout :  out   std_logic);
   end component;

   component bit_mux_2to1 is
      port(
         BIT_MUX_2to1_in0  :  in    std_logic;
         BIT_MUX_2to1_in1  :  in    std_logic;
         BIT_MUX_2to1_sel  :  in    std_logic;
         BIT_MUX_2to1_out  :  out   std_logic);
   end component;

   component mux_2to1 is
      generic (
         MUX_2to1_NBIT :  integer  := 4);
      port (
         MUX_2to1_in0  :  in    std_logic_vector(MUX_2to1_NBIT-1 downto 0);
         MUX_2to1_in1  :  in    std_logic_vector(MUX_2to1_NBIT-1 downto 0);
         MUX_2to1_sel  :  in    std_logic;
         MUX_2to1_out  :  out   std_logic_vector(MUX_2to1_NBIT-1 downto 0));
   end component;

  signal sum_rca_0   :  std_logic_vector(CSA_NBIT-1 downto 0);
  signal sum_rca_1   :  std_logic_vector(CSA_NBIT-1 downto 0);
  signal cout_rca_0  :  std_logic;
  signal cout_rca_1  :  std_logic;

begin

   RCA_0 : ripple_carry_adder
      generic map(
         RCA_NBIT => CSA_NBIT)
      port map(
         RCA_op1  => CSA_OP1,
         RCA_op2  => CSA_OP2,
         RCA_cin  => '0',
         RCA_res  => sum_rca_0,
         RCA_cout => cout_rca_0);

   RCA_1 : ripple_carry_adder
      generic map(
         RCA_NBIT => CSA_NBIT)
      port map(
         RCA_op1  => CSA_op1,
         RCA_op2  => CSA_op2,
         RCA_cin  => '1',
         RCA_res  => sum_rca_1,
         RCA_cout => cout_rca_1);

   CARRY_MUX : bit_mux_2to1
      port map(
         BIT_MUX_2to1_in0  => cout_rca_0,
         BIT_MUX_2to1_in1  => cout_rca_1,
         BIT_MUX_2to1_sel  => CSA_cin,
         BIT_MUX_2to1_out  => CSA_cout
      );

   SUM_MUX : mux_2to1
      generic map(
         MUX_2to1_NBIT  => CSA_NBIT)
      port map(
         MUX_2to1_in0   => sum_rca_0,
         MUX_2to1_in1   => sum_rca_1,
         MUX_2to1_sel   => CSA_cin,
         MUX_2to1_out   => CSA_res);

end str;

configuration CFG_CARRY_SELECT_ADDER_STR of carry_select_adder is
   for str
      for RCA_0 : ripple_carry_adder
         use configuration work.CFG_RIPPLE_CARRY_ADDER_STR;
      end for;
      for RCA_1 : ripple_carry_adder
         use configuration work.CFG_RIPPLE_CARRY_ADDER_STR;
      end for;
      for CARRY_MUX : bit_mux_2to1
         use configuration work.CFG_BIT_MUX_2to1_BHV;
      end for;
      for SUM_MUX : mux_2to1
         use configuration work.CFG_MUX_2to1_BHV;
      end for;
   end for;
end configuration CFG_CARRY_SELECT_ADDER_STR;
