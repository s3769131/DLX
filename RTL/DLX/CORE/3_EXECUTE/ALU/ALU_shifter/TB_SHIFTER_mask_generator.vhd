library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

entity TB_SHF_mask_generator is
end TB_SHF_mask_generator;

architecture TEST of TB_SHF_mask_generator is

   component SHF_mask_generator is
      generic(
         SHF_MG_NBIT   :  integer  := 32;
         SHF_MG_GRAN   :  integer  := 4);
      port(
         SHF_MG_operand       :  in    std_logic_vector(SHF_MG_NBIT-1 downto 0);
         SHF_MG_left_right    :  in    std_logic;
         SHF_MG_logic_arith   :  in    std_logic;
         SHF_MG_masks_out     :  out   std_logic_vector((SHF_MG_NBIT/SHF_MG_GRAN)*(SHF_MG_NBIT+SHF_MG_GRAN)-1 downto 0)
      );
   end component;

   constant c_SHF_MG_NBIT  :  integer  := 32;
   constant c_SHF_MG_GRAN  :  integer  := 4;

   signal s_SHF_MG_operand       :  std_logic_vector(c_SHF_MG_NBIT-1 downto 0)   := (others => '0');
   signal s_SHF_MG_left_right    :  std_logic                                    := '0';
   signal s_SHF_MG_logic_arith   :  std_logic                                    := '0';
   signal s_SHF_MG_masks_out     :  std_logic_vector((c_SHF_MG_NBIT/c_SHF_MG_GRAN)*(c_SHF_MG_NBIT+c_SHF_MG_GRAN)-1 downto 0) := (others => '0');

begin

   UUT : SHF_mask_generator
      generic map(
         SHF_MG_NBIT => c_SHF_MG_NBIT,
         SHF_MG_GRAN => c_SHF_MG_GRAN
      )
      port map(
         SHF_MG_operand       => s_SHF_MG_operand,
         SHF_MG_left_right    => s_SHF_MG_left_right,
         SHF_MG_logic_arith   => s_SHF_MG_logic_arith,
         SHF_MG_masks_out     => s_SHF_MG_masks_out);

   INPUT_STIMULI_PROCESS : process
   begin
      s_SHF_MG_operand     <= x"6d3a30f3";
      s_SHF_MG_left_right  <= '0';
      s_SHF_MG_logic_arith <= '1';
      wait for 1 ns;
      s_SHF_MG_left_right  <= '0';
      s_SHF_MG_logic_arith <= '0';
      wait for 1 ns;
      s_SHF_MG_left_right  <= '1';
      s_SHF_MG_logic_arith <= '1';
      wait for 1 ns;
      s_SHF_MG_left_right  <= '1';
      s_SHF_MG_logic_arith <= '0';
      wait for 1 ns;

      s_SHF_MG_operand     <= x"8d3a30f3";
      s_SHF_MG_left_right  <= '0';
      s_SHF_MG_logic_arith <= '1';
      wait for 1 ns;
      s_SHF_MG_left_right  <= '0';
      s_SHF_MG_logic_arith <= '0';
      wait for 1 ns;
      s_SHF_MG_left_right  <= '1';
      s_SHF_MG_logic_arith <= '1';
      wait for 1 ns;
      s_SHF_MG_left_right  <= '1';
      s_SHF_MG_logic_arith <= '0';
      wait;
   end process;

end TEST;
