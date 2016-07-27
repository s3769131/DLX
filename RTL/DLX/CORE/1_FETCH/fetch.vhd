library ieee;
use ieee.std_logic_1164.all;

entity FETCH is
  port (
    FTC_IRAM_IN   : in  std_logic_vector(31 downto 0);  --! Data in from instr. mem
    FTC_PC        : out std_logic_vector(31 downto 0);
    FTC_ALU_OUT   : in  std_logic_vector(31 downto 0);
    FTC_NPC       : out std_logic_vector(31 downto 0);
    FTC_IR        : out std_logic_vector(31 downto 0);
    FTC_ENABLE_PC : in std_logic; --! Signal coming from the CU. Stop the update of the program counter if the memory requires more time to deliver the data instruction
    FTC_ZERO      : in std_logic;
    FTC_CLK       : in std_logic;
    FTC_RST       : in std_logic
  );
end entity FETCH;

architecture STR of FETCH is

  component REGISTER is
    generic(
  		RGS_NBIT: integer := 4
  	);
  	port(
  		RGS_D	 :	in	std_logic_vector(RGS_NBIT-1 downto 0);
  		CLK 	 :	in	std_logic;
      RGS_EN :  in  std_logic;  --! Active high
  		RST 	 :	in	std_logic;
  		RGS_Q	 :	out	std_logic_vector(RGS_NBIT-1 downto 0)
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

signal s_NPC       : std_logic_vector(31 downto 0); --! Signal containing the new program counter
signal s_PC        : std_logic_vector(31 downto 0); --! Signal containing the current program counter
signal s_IR        : std_logic_vector(31 downto 0);
signal s_adder_out : std_logic_vector(31 downto 0);

begin
  ADDER : ALU_carry_lookahead_adder
    generic map (
      ALU_CLA_NBIT => 32
    )
    port map(
       ALU_CLA_op1     => s_PC,
       ALU_CLA_op2     => "000000000000000000000000000000100",
       ALU_CLA_add     => '0',
       ALU_CLA_res     => s_adder_out,
       ALU_CLA_cout    => open,
       ALU_CLA_ovflow  => open
    );

  MUX : mux_2to1
    generic map(
      MUX_2to1_NBIT => 32
    )
    port map(
      MUX_2to1_in0  => s_adder_out,
      MUX_2to1_in1  => FTC_ALU_OUT,
      MUX_2to1_sel  => FTC_ZERO,
      MUX_2to1_out  => s_NPC
  );

  PC : REGISTER
    generic map(
      RGS_NBIT => 32
    )
    port(
      RGS_D	 => s_NPC,
      CLK 	 => CLK,
      RGS_EN => FTC_ENABLE_PC,
      RST 	 => RST,
      RGS_Q	 => s_PC
    );

  s_IR    <= FTC_IRAM_IN;
  FTC_IR  <= s_IR;
  FTC_PC  <= s_PC;
  FTC_NPC <= s_NPC;

end architecture STR;
