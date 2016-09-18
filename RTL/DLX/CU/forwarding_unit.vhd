library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CU_pkg.all;

entity forwarding_unit is
  generic(
    FW_IR_NBIT : positive := 32
  );
  port(
    FW_IDEX_IR  : in  std_logic_vector(FW_IR_NBIT - 1 downto 0);
    FW_EXMEM_IR : in  std_logic_vector(FW_IR_NBIT - 1 downto 0);
    FW_MEMWB_IR : in  std_logic_vector(FW_IR_NBIT - 1 downto 0);
    -- FU_IT_SOURCE : in  std_logic_vector(1 downto 0);
    FW_TOP_ALU  : out std_logic_vector(1 downto 0);
    FW_BOT_ALU  : out std_logic_vector(1 downto 0)
  );
end entity forwarding_unit;

architecture STR of forwarding_unit is
  component EQ_COMPARATOR
    generic(COMP_NBIT : integer := 32);
    port(
      COMP_A   : in  std_logic_vector(COMP_NBIT - 1 downto 0);
      COMP_B   : in  std_logic_vector(COMP_NBIT - 1 downto 0);
      COMP_RES : out std_logic
    );
  end component EQ_COMPARATOR;

  component instruction_type_decoder
    generic(ITD_IR_NBIT : positive := 32);
    port(
      ITD_IR : in  std_logic_vector(ITD_IR_NBIT - 1 downto 0);
      ITD_IT : out std_logic_vector(1 downto 0)
    );
  end component instruction_type_decoder;

  constant SOURCE_NO   : std_logic_vector(1 downto 0) := "00";
  constant SOURCE_ALU1 : std_logic_vector(1 downto 0) := "01";
  constant SOURCE_ALU2 : std_logic_vector(1 downto 0) := "10";
  constant SOURCE_MEM  : std_logic_vector(1 downto 0) := "11";

  signal s_EXMEM_IR_rt : std_logic_vector(4 downto 0);
  signal s_EXMEM_IR_rd : std_logic_vector(4 downto 0);

  signal s_MEMWB_IR_rt : std_logic_vector(4 downto 0);
  signal s_MEMWB_IR_rd : std_logic_vector(4 downto 0);

  signal s_IDEX_IR_rt : std_logic_vector(4 downto 0);
  signal s_IDEX_IR_rd : std_logic_vector(4 downto 0);
  signal s_IDEX_IR_rs : std_logic_vector(4 downto 0);

  signal s_comp_result : std_logic_vector(9 downto 0);

  signal s_it_IDEX  : std_logic_vector(1 downto 0);
  signal s_it_EXMEM : std_logic_vector(1 downto 0);
  signal s_it_MEMWB : std_logic_vector(1 downto 0);

begin
  s_EXMEM_IR_rt <= FW_EXMEM_IR(20 downto 16);
  s_EXMEM_IR_rd <= FW_EXMEM_IR(15 downto 11);

  s_MEMWB_IR_rt <= FW_MEMWB_IR(20 downto 16);
  s_MEMWB_IR_rd <= FW_MEMWB_IR(15 downto 11);

  s_IDEX_IR_rt <= FW_IDEX_IR(20 downto 16);
  s_IDEX_IR_rd <= FW_IDEX_IR(15 downto 11);
  s_IDEX_IR_rs <= FW_IDEX_IR(25 downto 21);

  ITD_IDEX : instruction_type_decoder
    generic map(
      ITD_IR_NBIT => FW_IR_NBIT
    )
    port map(
      ITD_IR => FW_IDEX_IR,
      ITD_IT => s_IT_IDEX
    );

  ITD_EXMEM : instruction_type_decoder
    generic map(
      ITD_IR_NBIT => FW_IR_NBIT
    )
    port map(
      ITD_IR => FW_EXMEM_IR,
      ITD_IT => s_IT_EXMEM
    );

  ITD_MEMWB : instruction_type_decoder
    generic map(
      ITD_IR_NBIT => FW_IR_NBIT
    )
    port map(
      ITD_IR => FW_MEMWB_IR,
      ITD_IT => s_IT_MEMWB
    );

  FW_PROC : process(s_EXMEM_IR_rd, s_EXMEM_IR_rt, s_IDEX_IR_rs, s_IDEX_IR_rt, s_it_EXMEM, s_it_IDEX) is
  begin
    if (s_IDEX_IR_rt = "00000") or (s_IDEX_IR_rs = "00000") then
      FW_TOP_ALU <= SOURCE_NO;
      FW_BOT_ALU <= SOURCE_NO;

    -- Source (EXMEM) is reg-to-reg and Dest is reg-to-reg
    elsif s_it_EXMEM = IT_REG_REG and s_it_IDEX = IT_REG_REG then
      if s_EXMEM_IR_rd = s_IDEX_IR_rs then
        FW_TOP_ALU <= SOURCE_ALU1;
        FW_BOT_ALU <= SOURCE_NO;
      elsif s_EXMEM_IR_rd = s_IDEX_IR_rt then
        FW_TOP_ALU <= SOURCE_NO;
        FW_BOT_ALU <= SOURCE_ALU1;
      else
        FW_TOP_ALU <= SOURCE_NO;
        FW_BOT_ALU <= SOURCE_NO;
      end if;

    -- Source (EXMEM) is reg-to-reg and Dest is immediate
    elsif s_it_EXMEM = IT_REG_REG and (s_it_IDEX = IT_IMM or s_it_IDEX = IT_BR_J) then
      if s_EXMEM_IR_rd = s_IDEX_IR_rs then
        FW_TOP_ALU <= SOURCE_ALU1;
        FW_BOT_ALU <= SOURCE_NO;
      else
        FW_TOP_ALU <= SOURCE_NO;
        FW_BOT_ALU <= SOURCE_NO;
      end if;

    -- Source (EXMEM) is Imm and Dest is reg-to-reg
    elsif s_it_EXMEM = IT_IMM and s_it_IDEX = IT_REG_REG then
      if s_EXMEM_IR_rt = s_IDEX_IR_rs then
        FW_TOP_ALU <= SOURCE_ALU1;
        FW_BOT_ALU <= SOURCE_NO;
      elsif s_EXMEM_IR_rt = s_IDEX_IR_rt then
        FW_TOP_ALU <= SOURCE_NO;
        FW_BOT_ALU <= SOURCE_ALU1;
      else
        FW_TOP_ALU <= SOURCE_NO;
        FW_BOT_ALU <= SOURCE_NO;
      end if;

    -- Source (EXMEM) is Immediate and Dest is immediate
    elsif s_it_EXMEM = IT_IMM and (s_it_IDEX = IT_IMM or s_it_IDEX = IT_BR_J) then
      if s_EXMEM_IR_rt = s_IDEX_IR_rs then
        FW_TOP_ALU <= SOURCE_ALU1;
        FW_BOT_ALU <= SOURCE_NO;
      else
        FW_TOP_ALU <= SOURCE_NO;
        FW_BOT_ALU <= SOURCE_NO;
      end if;
      
      
      
    -- Source (MEMWB) is reg-to-reg and Dest is reg-to-reg
    elsif s_it_MEMWB = IT_REG_REG and s_it_IDEX = IT_REG_REG then
      if s_MEMWB_IR_rd = s_IDEX_IR_rs then
        FW_TOP_ALU <= SOURCE_ALU2;
        FW_BOT_ALU <= SOURCE_NO;
      elsif s_MEMWB_IR_rd = s_IDEX_IR_rt then
        FW_TOP_ALU <= SOURCE_NO;
        FW_BOT_ALU <= SOURCE_ALU2;
      else
        FW_TOP_ALU <= SOURCE_NO;
        FW_BOT_ALU <= SOURCE_NO;
      end if;

    -- Source (MEMWB) is reg-to-reg and Dest is immediate
    elsif s_it_MEMWB = IT_REG_REG and (s_it_IDEX = IT_IMM or s_it_IDEX = IT_BR_J) then
      if s_MEMWB_IR_rd = s_IDEX_IR_rs then
        FW_TOP_ALU <= SOURCE_ALU2;
        FW_BOT_ALU <= SOURCE_NO;
      else
        FW_TOP_ALU <= SOURCE_NO;
        FW_BOT_ALU <= SOURCE_NO;
      end if;

    -- Source (MEMWB) is Imm and Dest is reg-to-reg
    elsif s_it_MEMWB = IT_IMM and s_it_IDEX = IT_REG_REG then
      if s_MEMWB_IR_rt = s_IDEX_IR_rs then
        FW_TOP_ALU <= SOURCE_ALU2;
        FW_BOT_ALU <= SOURCE_NO;
      elsif s_MEMWB_IR_rt = s_IDEX_IR_rt then
        FW_TOP_ALU <= SOURCE_NO;
        FW_BOT_ALU <= SOURCE_ALU2;
      else
        FW_TOP_ALU <= SOURCE_NO;
        FW_BOT_ALU <= SOURCE_NO;
      end if;

    -- Source (MEMWB) is Immediate and Dest is immediate
    elsif s_it_MEMWB = IT_IMM and (s_it_IDEX = IT_IMM or s_it_IDEX = IT_BR_J) then
      if s_MEMWB_IR_rt = s_IDEX_IR_rs then
        FW_TOP_ALU <= SOURCE_ALU2;
        FW_BOT_ALU <= SOURCE_NO;
      else
        FW_TOP_ALU <= SOURCE_NO;
        FW_BOT_ALU <= SOURCE_NO;
      end if;
      
      
      elsif s_it_MEMWB = IT_LD_ST and (s_it_IDEX = IT_IMM or s_it_IDEX = IT_BR_J) then
      if s_MEMWB_IR_rt = s_IDEX_IR_rs then
        FW_TOP_ALU <= SOURCE_MEM;
        FW_BOT_ALU <= SOURCE_NO;    
      else
        FW_TOP_ALU <= SOURCE_NO;
        FW_BOT_ALU <= SOURCE_NO;
      end if;
      
       -- Source (MEMWB) is reg-to-reg and Dest is immediate
    elsif s_it_MEMWB = IT_LD_ST and (s_it_IDEX = IT_REG_REG) then
      if s_MEMWB_IR_rt = s_IDEX_IR_rs then
        FW_TOP_ALU <= SOURCE_MEM;
        FW_BOT_ALU <= SOURCE_NO;
      elsif s_MEMWB_IR_rt = s_IDEX_IR_rt then
        FW_TOP_ALU <= SOURCE_NO;
        FW_BOT_ALU <= SOURCE_MEM;
      else
        FW_TOP_ALU <= SOURCE_NO;
        FW_BOT_ALU <= SOURCE_NO;
      end if;
      
      
        
      
      

    --elsif s_EXMEM_IR_rd = s_IDEX_IR_rs and (s_it_EXMEM = IT_REG_REG or s_it_EXMEM = IT_IMM) and (s_it_IDEX = IT_REG_REG or s_it_IDEX = IT_IMM) then
    --elsif s_EXMEM_IR_rd = s_IDEX_IR_rt and (s_it_EXMEM = IT_REG_REG) and (s_it_IDEX = IT_REG_REG) then
    --  FW_TOP_ALU <= SOURCE_NO;
    --  FW_BOT_ALU <= SOURCE_ALU1;
    else
      FW_TOP_ALU <= SOURCE_NO;
      FW_BOT_ALU <= SOURCE_NO;
    end if;

  end process FW_PROC;

-- COMP0 : EQ_COMPARATOR
--   generic map(
--     COMP_NBIT => 5
--   )
--   port map(
--     COMP_A   => s_EXMEM_IR_rd,
--     COMP_B   => s_IDEX_IR_rt,
--     COMP_RES => s_comp_result(0)
--   );
-- ---
-- COMP1 : EQ_COMPARATOR
--   generic map(
--     COMP_NBIT => 5
--   )
--   port map(
--     COMP_A   => s_EXMEM_IR_rd,
--     COMP_B   => s_IDEX_IR_rd,
--     COMP_RES => s_comp_result(1)
--   );
--
-- COMP2 : EQ_COMPARATOR
--   generic map(
--     COMP_NBIT => 5
--   )
--   port map(
--     COMP_A   => s_MEMWB_IR_rd,
--     COMP_B   => s_IDEX_IR_rt,
--     COMP_RES => s_comp_result(2)
--   );
--
-- COMP3 : EQ_COMPARATOR
--   generic map(
--     COMP_NBIT => 5
--   )
--   port map(
--     COMP_A   => s_MEMWB_IR_rd,
--     COMP_B   => s_IDEX_IR_rd,
--     COMP_RES => s_comp_result(3)
--   );
--
-- COMP4 : EQ_COMPARATOR
--   generic map(
--     COMP_NBIT => 5
--   )
--   port map(
--     COMP_A   => s_EXMEM_IR_rt,
--     COMP_B   => s_IDEX_IR_rt,
--     COMP_RES => s_comp_result(4)
--   );
--
-- COMP5 : EQ_COMPARATOR
--   generic map(
--     COMP_NBIT => 5
--   )
--   port map(
--     COMP_A   => s_EXMEM_IR_rt,
--     COMP_B   => s_IDEX_IR_rd,
--     COMP_RES => s_comp_result(5)
--   );
--
-- COMP6 : EQ_COMPARATOR
--   generic map(
--     COMP_NBIT => 5
--   )
--   port map(
--     COMP_A   => s_MEMWB_IR_rt,
--     COMP_B   => s_IDEX_IR_rt,
--     COMP_RES => s_comp_result(6)
--   );
--
-- COMP7 : EQ_COMPARATOR
--   generic map(
--     COMP_NBIT => 5
--   )
--   port map(
--     COMP_A   => s_MEMWB_IR_rt,
--     COMP_B   => s_IDEX_IR_rd,
--     COMP_RES => s_comp_result(7)
--   );
--
-- COMP8 : EQ_COMPARATOR
--   generic map(
--     COMP_NBIT => 5
--   )
--   port map(
--     COMP_A   => s_MEMWB_IR_rt,
--     COMP_B   => s_IDEX_IR_rt,
--     COMP_RES => s_comp_result(8)
--   );
--
-- COMP9 : EQ_COMPARATOR
--   generic map(
--     COMP_NBIT => 5
--   )
--   port map(
--     COMP_A   => s_MEMWB_IR_rt,
--     COMP_B   => s_IDEX_IR_rd,
--     COMP_RES => s_comp_result(9)
--   );
--
-- FW : process(s_it_EXMEM, s_comp_result, s_it_IDEX, s_it_MEMWB, s_IDEX_IR_rt, s_IDEX_IR_rd) is
-- begin
--   if (s_IDEX_IR_rt = "00000") or (s_IDEX_IR_rd = "00000") then
--     FW_TOP_ALU <= SOURCE_NO;
--     FW_BOT_ALU <= SOURCE_NO;
--
--   elsif s_comp_result(0) = '1' and (s_it_EXMEM = IT_REG_REG) then
--     FW_TOP_ALU <= SOURCE_ALU1;
--     FW_BOT_ALU <= SOURCE_NO;
--
--   elsif s_comp_result(1) = '1' and (s_it_EXMEM = IT_REG_REG) and (s_it_IDEX = IT_REG_REG) then
--     FW_TOP_ALU <= SOURCE_NO;
--     FW_BOT_ALU <= SOURCE_ALU1;
--
--   elsif s_comp_result(2) = '1' and (s_it_MEMWB = IT_REG_REG) then
--     FW_TOP_ALU <= SOURCE_ALU2;
--     FW_BOT_ALU <= SOURCE_NO;
--
--   elsif s_comp_result(3) = '1' and (s_it_MEMWB = IT_REG_REG) and (s_it_IDEX = IT_REG_REG) then
--     FW_TOP_ALU <= SOURCE_NO;
--     FW_BOT_ALU <= SOURCE_ALU2;
--
--   elsif s_comp_result(4) = '1' and (s_it_EXMEM = IT_IMM) then
--     FW_TOP_ALU <= SOURCE_ALU1;
--     FW_BOT_ALU <= SOURCE_NO;
--
--   elsif s_comp_result(5) = '1' and (s_it_EXMEM = IT_IMM) and (s_it_IDEX = IT_REG_REG) then
--     FW_TOP_ALU <= SOURCE_NO;
--     FW_BOT_ALU <= SOURCE_ALU1;
--
--   elsif s_comp_result(6) = '1' and (s_it_MEMWB = IT_IMM) then
--     FW_TOP_ALU <= SOURCE_ALU2;
--     FW_BOT_ALU <= SOURCE_NO;
--
--   elsif s_comp_result(7) = '1' and (s_it_MEMWB = IT_IMM) and (s_it_IDEX = IT_REG_REG) then
--     FW_TOP_ALU <= SOURCE_NO;
--     FW_BOT_ALU <= SOURCE_ALU2;
--
--   elsif s_comp_result(8) = '1' and (s_it_MEMWB = IT_LD_ST) then
--     FW_TOP_ALU <= SOURCE_MEM;
--     FW_BOT_ALU <= SOURCE_NO;
--
--   elsif s_comp_result(9) = '1' and (s_it_MEMWB = IT_LD_ST) and (s_it_IDEX = IT_REG_REG) then
--     FW_TOP_ALU <= SOURCE_NO;
--     FW_BOT_ALU <= SOURCE_MEM;
--   else
--     FW_TOP_ALU <= SOURCE_NO;
--     FW_BOT_ALU <= SOURCE_NO;
--   end if;
-- end process FW;

--  ALU_TOP_FORWARD : process(s_comp_result, FU_IT_SOURCE)
--    variable v_comp_result : integer;
--  begin
--    v_comp_result := to_integer(unsigned(s_comp_result));
--    case v_comp_result is
--      when 1 | 16 =>
--        FU_TOP_ALU <= "01";
--      when 4 =>
--        FU_TOP_ALU <= "10";
--
--      when 320 =>
--        if FU_IT_SOURCE = "10" then
--          FU_TOP_ALU <= "10";
--        else
--          if FU_IT_SOURCE = "01" then
--            FU_TOP_ALU <= "11";
--          end if;
--        end if;
--      when others => FU_TOP_ALU <= "00";
--    end case;
--  end process ALU_TOP_FORWARD;
--
--  ALU_BOT_FORWARD : process(s_comp_result, FU_IT_SOURCE)
--    variable v_comp_result : integer;
--  begin
--    v_comp_result := to_integer(unsigned(s_comp_result));
--    case v_comp_result is
--      when 2 | 32 =>
--        FU_BOT_ALU <= "01";
--      when 8 =>
--        FU_BOT_ALU <= "10";
--
--      when 640 =>
--        if FU_IT_SOURCE = "10" then
--          FU_BOT_ALU <= "10";
--        else
--          if FU_IT_SOURCE = "01" then
--            FU_BOT_ALU <= "11";
--          end if;
--        end if;
--
--      when others => FU_BOT_ALU <= "00";
--    end case;
--  end process ALU_BOT_FORWARD;


end architecture STR;

configuration CFG_FORWARDING_UNIT_STR of FORWARDING_UNIT is
  for STR
  end for;
end configuration CFG_FORWARDING_UNIT_STR;

