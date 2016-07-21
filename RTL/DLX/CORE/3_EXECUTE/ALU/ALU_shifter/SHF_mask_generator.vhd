library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;


--!   \brief   Generates the masks for the shifter.
--!
--!   This entity models the network that generates all the masks needed for performing the shift of the
--!   operand. For left shifting, the SHF_MG_left_right signal has to be 0, while a right shift is performed
--!   otherwise. For performing a logical shift the SHF_MG_logic_arith signal has to be driven to 0; if it is
--!   driven to 1 an arithmetic shift is performed.
entity SHF_mask_generator is
   generic(
      SHF_MG_NBIT   :  integer  := 32; --!   parallelism of the operand.
      SHF_MG_GRAN   :  integer  := 4); --!   granularity of shift.
   port(
      SHF_MG_operand       :  in    std_logic_vector(SHF_MG_NBIT-1 downto 0);
      SHF_MG_left_right    :  in    std_logic;
      SHF_MG_logic_arith   :  in    std_logic;
      SHF_MG_masks_out     :  out   std_logic_vector((SHF_MG_NBIT/SHF_MG_GRAN)*(SHF_MG_NBIT+SHF_MG_GRAN)-1 downto 0)
   );
end SHF_mask_generator;

architecture str of SHF_mask_generator is

   component mux_2to1 is
      generic (
         MUX_2to1_NBIT :  integer  := 4);
      port (
         MUX_2to1_in0  :  in    std_logic_vector(MUX_2to1_NBIT-1 downto 0);
         MUX_2to1_in1  :  in    std_logic_vector(MUX_2to1_NBIT-1 downto 0);
         MUX_2to1_sel  :  in    std_logic;
         MUX_2to1_out  :  out   std_logic_vector(MUX_2to1_NBIT-1 downto 0));
   end component;

   constant N_BLOCK              :  integer  := SHF_MG_NBIT/SHF_MG_GRAN;
   constant FINEGRAIN_SHIFT_NBIT :  integer  := log2ceil(SHF_MG_GRAN);
   constant COARSE_SHIFT_NBIT    :  integer  := log2ceil(SHF_MG_NBIT)-FINEGRAIN_SHIFT_NBIT;

   type std_logic_matrix is array (N_BLOCK downto 1) of std_logic_vector(SHF_MG_NBIT+SHF_MG_GRAN-1 downto 0);

   signal tmp_masks_out       :  std_logic_matrix;
   signal sign_extendend_msb  :  std_logic_vector(SHF_MG_GRAN-1 downto 0);

begin

   SIGN_EXT_MS_GEN : for i in SHF_MG_GRAN-1 downto 0 generate
      sign_extendend_msb(i)   <= SHF_MG_operand(SHF_MG_NBIT-1) and SHF_MG_logic_arith;
   end generate;

   FIRST_HALF_GEN : for m in 1 to N_BLOCK/2 generate
      FIRST_HALF_ELEM_GEN : for e in 1 to N_BLOCK+1 generate
         FIRST_SECTION : if e >= 1 and e <= m generate
            MUX : mux_2to1
               generic map(
                  MUX_2to1_NBIT  => SHF_MG_GRAN)
               port map(
                  MUX_2to1_in0   => (others => '0'),
                  MUX_2to1_in1   => SHF_MG_operand((e+m-1)*SHF_MG_GRAN-1 downto (e+m-2)*SHF_MG_GRAN),
                  MUX_2to1_sel   => SHF_MG_left_right,
                  MUX_2to1_out   => tmp_masks_out(m)(SHF_MG_GRAN*e-1 downto SHF_MG_GRAN*(e-1)));
         end generate;
         SECOND_SECTION : if e > N_BLOCK+1-m and e <= N_BLOCK+1 generate
            MUX : mux_2to1
               generic map(
                  MUX_2to1_NBIT  => SHF_MG_GRAN)
               port map(
                  MUX_2to1_in0   => SHF_MG_operand((e-m)*SHF_MG_GRAN-1 downto (e-m-1)*SHF_MG_GRAN),
                  MUX_2to1_in1   => sign_extendend_msb,
                  MUX_2to1_sel   => SHF_MG_left_right,
                  MUX_2to1_out   => tmp_masks_out(m)(SHF_MG_GRAN*e-1 downto SHF_MG_GRAN*(e-1)));
         end generate;
         THIRD_SECTION : if e <= N_BLOCK+1-m and e >= 1+m generate
            MUX : mux_2to1
               generic map(
                  MUX_2to1_NBIT  => SHF_MG_GRAN)
               port map(
                  MUX_2to1_in0   => SHF_MG_operand((e-m)*SHF_MG_GRAN-1 downto (e-m-1)*SHF_MG_GRAN),
                  MUX_2to1_in1   => SHF_MG_operand((e+m-1)*SHF_MG_GRAN-1 downto (e+m-2)*SHF_MG_GRAN),
                  MUX_2to1_sel   => SHF_MG_left_right,
                  MUX_2to1_out   => tmp_masks_out(m)(SHF_MG_GRAN*e-1 downto SHF_MG_GRAN*(e-1)));
         end generate;
      end generate;
   end generate;

   SECOND_HALF_GEN : for m in N_BLOCK/2+1 to N_BLOCK generate
      SECOND_HALF_ELEM_GEN : for e in 1 to N_BLOCK+1 generate
         FIRST_SECTION : if e >= 1 and e <= N_BLOCK+1-m generate
            MUX : mux_2to1
               generic map(
                  MUX_2to1_NBIT  => SHF_MG_GRAN)
               port map(
                  MUX_2to1_in0   => (others => '0'),
                  MUX_2to1_in1   => SHF_MG_operand((e+m-1)*SHF_MG_GRAN-1 downto (e+m-2)*SHF_MG_GRAN),
                  MUX_2to1_sel   => SHF_MG_left_right,
                  MUX_2to1_out   => tmp_masks_out(m)(SHF_MG_GRAN*e-1 downto SHF_MG_GRAN*(e-1)));
         end generate;
         SECOND_SECTION : if e > N_BLOCK+1-m and e <= m generate
            MUX : mux_2to1
               generic map(
                  MUX_2to1_NBIT  => SHF_MG_GRAN)
               port map(
                  MUX_2to1_in0   => (others => '0'),
                  MUX_2to1_in1   => sign_extendend_msb,
                  MUX_2to1_sel   => SHF_MG_left_right,
                  MUX_2to1_out   => tmp_masks_out(m)(SHF_MG_GRAN*e-1 downto SHF_MG_GRAN*(e-1)));
         end generate;
         THIRD_SECTION : if e > m and e <= N_BLOCK+1 generate
            MUX : mux_2to1
               generic map(
                  MUX_2to1_NBIT  => SHF_MG_GRAN)
               port map(
                  MUX_2to1_in0   => SHF_MG_operand((e-m)*SHF_MG_GRAN-1 downto (e-m-1)*SHF_MG_GRAN),
                  MUX_2to1_in1   => sign_extendend_msb,
                  MUX_2to1_sel   => SHF_MG_left_right,
                  MUX_2to1_out   => tmp_masks_out(m)(SHF_MG_GRAN*e-1 downto SHF_MG_GRAN*(e-1)));
         end generate;
      end generate;
   end generate;

   ROUTE_MATRIX_TO_OUT : for i in 1 to N_BLOCK generate
      SHF_MG_masks_out(i*(SHF_MG_NBIT+SHF_MG_GRAN)-1 downto (i-1)*(SHF_MG_NBIT+SHF_MG_GRAN))   <= tmp_masks_out(i);
   end generate;

end str;

configuration CFG_SHF_MASK_GENERATOR_STR of SHF_mask_generator is
   for str
      for SIGN_EXT_MS_GEN
      end for;
      for FIRST_HALF_GEN
         for FIRST_HALF_ELEM_GEN
            for FIRST_SECTION
               for MUX : mux_2to1
                  use configuration work.CFG_MUX_2to1_BHV;
               end for;
            end for;
            for SECOND_SECTION
               for MUX : mux_2to1
                  use configuration work.CFG_MUX_2to1_BHV;
               end for;
            end for;
            for THIRD_SECTION
               for MUX : mux_2to1
                  use configuration work.CFG_MUX_2to1_BHV;
               end for;
            end for;
         end for;
      end for;
      for SECOND_HALF_GEN
         for SECOND_HALF_ELEM_GEN
            for FIRST_SECTION
               for MUX : mux_2to1
                  use configuration work.CFG_MUX_2to1_BHV;
               end for;
            end for;
            for SECOND_SECTION
               for MUX : mux_2to1
                  use configuration work.CFG_MUX_2to1_BHV;
               end for;
            end for;
            for THIRD_SECTION
               for MUX : mux_2to1
                  use configuration work.CFG_MUX_2to1_BHV;
               end for;
            end for;
         end for;
      end for;
   end for;
end configuration CFG_SHF_MASK_GENERATOR_STR;
