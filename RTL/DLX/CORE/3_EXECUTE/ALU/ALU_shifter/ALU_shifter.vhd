library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ALU_pkg.all;

entity ALU_shifter is
  generic(
    ALU_SHIFTER_NBIT : integer := 32);
  port(
    ALU_SHIFTER_operand         : in  std_logic_vector(ALU_SHIFTER_NBIT - 1 downto 0);
    ALU_SHIFTER_n_shift         : in  std_logic_vector((ALU_SHIFTER_NBIT) - 1 downto 0);
    ALU_SHIFTER_left_not_right  : in  std_logic;
    ALU_SHIFTER_logic_not_arith : in  std_logic;
    ALU_SHIFTER_result          : out std_logic_vector(ALU_SHIFTER_NBIT - 1 downto 0));
end entity ALU_shifter;

architecture dflow of ALU_shifter is
  type std_logic_matrix is array (ALU_SHIFTER_NBIT - 1 downto 0) of std_logic_vector(ALU_SHIFTER_NBIT - 1 downto 0);

  component mux_2to1 is
    generic(
      MUX_2to1_NBIT : integer := 4);
    port(
      MUX_2to1_in0 : in  std_logic_vector(MUX_2to1_NBIT - 1 downto 0);
      MUX_2to1_in1 : in  std_logic_vector(MUX_2to1_NBIT - 1 downto 0);
      MUX_2to1_sel : in  std_logic;
      MUX_2to1_out : out std_logic_vector(MUX_2to1_NBIT - 1 downto 0));
  end component mux_2to1;

  signal l_tmp       : std_logic_matrix;
  signal r_tmp       : std_logic_matrix;
  signal left_shift  : std_logic_vector(ALU_SHIFTER_NBIT - 1 downto 0);
  signal right_shift : std_logic_vector(ALU_SHIFTER_NBIT - 1 downto 0);
  signal msb_sign    : std_logic;

begin
  msb_sign <= (not ALU_SHIFTER_logic_not_arith) and ALU_SHIFTER_operand(ALU_SHIFTER_NBIT - 1);

  LEFT_ROW_GEN : for i in ALU_SHIFTER_NBIT - 1 downto 0 generate
    LEFT_COL_GEN : for j in ALU_SHIFTER_NBIT - 1 downto 0 generate
      LEFT_NOT_ZERO_GEN : if j - i >= 0 generate
        l_tmp(i)(j) <= ALU_SHIFTER_operand(j - i);
      end generate;
      LEFT_ZERO_GEN : if j - i < 0 generate
        l_tmp(i)(j) <= '0';
      end generate;
    end generate;
  end generate;

  RIGHT_ROW_GEN : for i in ALU_SHIFTER_NBIT - 1 downto 0 generate
    RIGHT_COL_GEN : for j in ALU_SHIFTER_NBIT - 1 downto 0 generate
      RIGHT_NOT_ZERO_GEN : if i + j <= ALU_SHIFTER_NBIT - 1 generate
        r_tmp(i)(j) <= ALU_SHIFTER_operand(i + j);
      end generate;
      RIGHT_ZERO_GEN : if i + j > ALU_SHIFTER_NBIT - 1 generate
        r_tmp(i)(j) <= msb_sign;
      end generate;
    end generate;
  end generate;

  left_shift  <= l_tmp(to_integer(unsigned(ALU_SHIFTER_n_shift(log2ceil(ALU_SHIFTER_NBIT) - 1 downto 0))));
  right_shift <= r_tmp(to_integer(unsigned(ALU_SHIFTER_n_shift(log2ceil(ALU_SHIFTER_NBIT) - 1 downto 0))));

  RESULT_LEFT_RIGHT_MUX : mux_2to1
    generic map(
      MUX_2to1_NBIT => ALU_SHIFTER_NBIT)
    port map(
      MUX_2to1_in0 => right_shift,
      MUX_2to1_in1 => left_shift,
      MUX_2to1_sel => ALU_SHIFTER_left_not_right,
      MUX_2to1_out => ALU_SHIFTER_result);

end architecture dflow;

configuration CFG_ALU_SHIFTER_DFLOW of ALU_shifter is
  for dflow
    for LEFT_ROW_GEN
      for LEFT_COL_GEN
        for LEFT_NOT_ZERO_GEN
        end for;
        for LEFT_ZERO_GEN
        end for;
      end for;
    end for;
    for RIGHT_ROW_GEN
      for RIGHT_COL_GEN
        for RIGHT_NOT_ZERO_GEN
        end for;
        for RIGHT_ZERO_GEN
        end for;
      end for;
    end for;
    for RESULT_LEFT_RIGHT_MUX : mux_2to1
      use configuration work.CFG_MUX_2to1_BHV;
    end for;
  end for;
end configuration CFG_ALU_SHIFTER_DFLOW;
