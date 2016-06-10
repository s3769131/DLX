library ieee;
use ieee.std_logic_1164;

entity FETCH is
  port (
    FTC_IRAM_IN  : in  std_logic_vector(31 downto 0);  --! Data in from instr. mem
    FTC_PC       : out std_logic_vector(31 downto 0);
    FTC_ALU_OUT  : in  std_logic_vector(31 downto 0);
    FTC_NPC      : out std_logic_vector(31 downto 0);
    FTC_IR       : out std_logic_vector(31 downto 0);
    FTC_IRAM_RDY : in std_logic;
    FTC_ZERO     : in std_logic;
    FTC_CLK      : in std_logic;
    FTC_RST      : in std_logic
  );
end entity FETCH;

architecture STR of FETCH is
  component REGISTER is
    generic(
  		RGS_NBIT: integer := 4
  	);
  	port(
  		RGS_D	:	in	std_logic_vector(RGS_NBIT-1 downto 0);
  		CLK 	:	in	std_logic;
  		RST 	:	in	std_logic;
  		RGS_Q	:	out	std_logic_vector(RGS_NBIT-1 downto 0)
  	);
  end component REGISTER;

  component mux_2to1 is
    generic (
        MUX_2to1_NBIT :  integer  := 4);
    port (
        MUX_2to1_in0  :  in  std_logic_vector(MUX_2to1_NBIT-1 downto 0);
        MUX_2to1_in1  :  in  std_logic_vector(MUX_2to1_NBIT-1 downto 0);
        MUX_2to1_sel  :  in  std_logic;
        MUX_2to1_out  :  out std_logic_vector(MUX_2to1_NBIT-1 downto 0)
    );
  end component mux_2to1;

  component ALU_carry_lookahead_adder is
     generic(
        ALU_CLA_NBIT    :  integer  := 16);   --!   parallelism of the operands.
     port(
        ALU_CLA_op1     :  in    std_logic_vector(ALU_CLA_NBIT-1 downto 0);  --!   first operand of the sum.
        ALU_CLA_op2     :  in    std_logic_vector(ALU_CLA_NBIT-1 downto 0);  --!   second operand of the sum.
        ALU_CLA_add     :  in    std_logic;                                  --!   carries.
        ALU_CLA_res     :  out   std_logic_vector(ALU_CLA_NBIT-1 downto 0);  --!   result of the operation.
        ALU_CLA_cout    :  out   std_logic;                                  --!   carry out of the overall operation.
        ALU_CLA_ovflow  :  out   std_logic);                                 --!   report if an overflow is detected.
  end component ALU_carry_lookahead_adder;

signal

begin
  ADDER : ALU_carry_lookahead_adder
    generic map (
      ALU_CLA_NBIT => 32
    )
    port map(
       ALU_CLA_op1     => ,
       ALU_CLA_op2     => "000000000000000000000000000000100",
       ALU_CLA_add     => '0',
       ALU_CLA_res     => ,
       ALU_CLA_cout    => open,
       ALU_CLA_ovflow  => open)
    ;
  MUX : mux_2to1
    generic map(
      MUX_2to1_NBIT => 32
    )
    port map(
      MUX_2to1_in0  => ,
      MUX_2to1_in1  => ,
      MUX_2to1_sel  => FTC_ZERO,
      MUX_2to1_out  =>
  );
  PC : REGISTER
  generic map(
    RGS_NBIT => 32
  )
  port(
    RGS_D	=> ,
    CLK 	=> ,
    RST 	=> ,
    RGS_Q	=>
  );
end architecture STR;
