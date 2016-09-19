library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SHIFTER_pkg.all;

entity shifter is
    generic(
        SHIFTER_NBIT  :  integer  := 32);
    port(
        SHIFTER_operand     	:  	in  std_logic_vector(SHIFTER_NBIT-1 downto 0);
        SHIFTER_n_shift     	:  	in  std_logic_vector(SHIFTER_NBIT-1 downto 0);
        SHIFTER_left_not_right  :  	in  std_logic;
        SHIFTER_logic_not_arith	:	in  std_logic;
        SHIFTER_result      	:  	out	std_logic_vector(SHIFTER_NBIT-1 downto 0));
end entity shifter;

architecture dflow of shifter is
	
	component mux_2to1 is
   		generic (
      		MUX_2to1_NBIT :  integer  := 4);
   		port (
      		MUX_2to1_in0  :  in    std_logic_vector(MUX_2to1_NBIT-1 downto 0);
      		MUX_2to1_in1  :  in    std_logic_vector(MUX_2to1_NBIT-1 downto 0);
      		MUX_2to1_sel  :  in    std_logic;
      		MUX_2to1_out  :  out   std_logic_vector(MUX_2to1_NBIT-1 downto 0));
	end component mux_2to1;
	
	signal l_tmp		:	std_logic_matrix(SHIFTER_NBIT-1 downto 0)(SHIFTER_NBIT-1 downto 0);
	signal r_tmp		:	std_logic_matrix(SHIFTER_NBIT-1 downto 0)(SHIFTER_NBIT-1 downto 0);
	signal left_shift	:	std_logic_vector(SHIFTER_NBIT-1 downto 0);
	signal right_shift	:	std_logic_vector(SHIFTER_NBIT-1 downto 0);
	signal msb_sign		:	std_logic;
	
begin

	msb_sign	<=	(not SHIFTER_logic_not_arith) and SHIFTER_operand(SHIFTER_NBIT-1);
	
	LEFT_ROW_GEN : for i in SHIFTER_NBIT-1 downto 0 generate
		LEFT_COL_GEN : for j in SHIFTER_NBIT-1 downto 0 generate
			LEFT_NOT_ZERO_GEN : if j-i >= 0 generate
				l_tmp(i)(j)	<=	SHIFTER_operand(j-i);
			end generate;
			LEFT_ZERO_GEN : if j-i < 0 generate
				l_tmp(i)(j)	<=	'0';
			end generate;
		end generate;
	end generate;
	
	RIGHT_ROW_GEN : for i in SHIFTER_NBIT-1 downto 0 generate
		RIGHT_COL_GEN : for j in SHIFTER_NBIT-1 downto 0 generate
			RIGHT_NOT_ZERO_GEN : if i+j <= SHIFTER_NBIT-1 generate
				r_tmp(i)(j)	<=	SHIFTER_operand(i+j);
			end generate;
			RIGHT_ZERO_GEN : if i+j > SHIFTER_NBIT-1 generate
				r_tmp(i)(j)	<=	msb_sign;
			end generate;
		end generate;
	end generate;		
	
	left_shift	<=	l_tmp(to_integer(unsigned(SHIFTER_n_shift(log2ceil(SHIFTER_NBIT)-1 downto 0))));
	right_shift	<=	r_tmp(to_integer(unsigned(SHIFTER_n_shift(log2ceil(SHIFTER_NBIT)-1 downto 0))));
	
	RESULT_LEFT_RIGHT_MUX : mux_2to1
		generic map(
			MUX_2to1_NBIT	=>	SHIFTER_NBIT)
		port map(
			MUX_2to1_in0	=>	right_shift,
			MUX_2to1_in1	=>	left_shift,
			MUX_2to1_sel	=>	SHIFTER_left_not_right,
			MUX_2to1_out	=>	SHIFTER_result);
	
end architecture dflow;

configuration CFG_SHIFTER_DFLOW of shifter is
	for dflow
	end for;
end configuration CFG_SHIFTER_DFLOW;