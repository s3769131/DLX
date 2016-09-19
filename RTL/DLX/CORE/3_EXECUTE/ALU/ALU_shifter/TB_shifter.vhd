library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ALU_pkg.all;

entity TB_ALU_shifter is
end TB_ALU_shifter;

architecture TEST of TB_ALU_shifter is

	component shifter is
    	generic(
        	SHIFTER_NBIT  :  integer  := 32);
    	port(
        	SHIFTER_operand     	:  	in  std_logic_vector(SHIFTER_NBIT-1 downto 0);
        	SHIFTER_n_shift     	:  	in  std_logic_vector(SHIFTER_NBIT-1 downto 0);
        	SHIFTER_left_not_right  :  	in  std_logic;
        	SHIFTER_logic_not_arith	:	in  std_logic;
        	SHIFTER_result      	:  	out	std_logic_vector(SHIFTER_NBIT-1 downto 0));
	end component shifter;

   constant c_SHIFTER_NBIT   :  integer  := 32;

   signal s_SHIFTER_operand     	:  std_logic_vector(c_SHIFTER_NBIT-1 downto 0)	:= (others => '0');
   signal s_SHIFTER_n_shift     	:  std_logic_vector(c_SHIFTER_NBIT-1 downto 0)  := (others => '0');
   signal s_SHIFTER_left_not_right  :  std_logic                                    := '0';
   signal s_SHIFTER_logic_not_arith :  std_logic                                    := '0';
   signal s_SHIFTER_result      	:  std_logic_vector(c_SHIFTER_NBIT-1 downto 0)	:= (others => '0');

begin

	UUT : shifter
      	generic map(
         	SHIFTER_NBIT  => c_SHIFTER_NBIT)
      	port map(
         	SHIFTER_operand     	=> s_SHIFTER_operand,
         	SHIFTER_n_shift    		=> s_SHIFTER_n_shift,
         	SHIFTER_left_not_right	=> s_SHIFTER_left_not_right,
         	SHIFTER_logic_not_arith	=> s_SHIFTER_logic_not_arith,
         	SHIFTER_result      	=> s_SHIFTER_result);

   	INPUT_STIMULI_PROCESS : process
   	begin
      	s_SHIFTER_operand      <= x"d4f237ac";

      	s_SHIFTER_left_not_right   <= '0';
      	s_SHIFTER_logic_not_arith  <= '0';
      	for i in 0 to c_SHIFTER_NBIT-1 loop
         	s_SHIFTER_n_shift   <= std_logic_vector(to_unsigned(i,c_SHIFTER_NBIT));
         	wait for 1 ns;
      	end loop;

      	s_SHIFTER_left_not_right   <= '0';
      	s_SHIFTER_logic_not_arith  <= '1';
      	for i in 0 to c_SHIFTER_NBIT-1 loop
         	s_SHIFTER_n_shift   <= std_logic_vector(to_unsigned(i,c_SHIFTER_NBIT));
         	wait for 1 ns;
      	end loop;

      	s_SHIFTER_left_not_right   <= '1';
      	s_SHIFTER_logic_not_arith  <= '0';
      	for i in 0 to c_SHIFTER_NBIT-1 loop
         	s_SHIFTER_n_shift   <= std_logic_vector(to_unsigned(i,c_SHIFTER_NBIT));
         	wait for 1 ns;
      	end loop;

      	s_SHIFTER_left_not_right   <= '1';
      	s_SHIFTER_logic_not_arith  <= '1';
      	for i in 0 to c_SHIFTER_NBIT-1 loop
         	s_SHIFTER_n_shift   <= std_logic_vector(to_unsigned(i,c_SHIFTER_NBIT));
         	wait for 1 ns;
      	end loop;

      	wait;
   	end process;

end TEST;
