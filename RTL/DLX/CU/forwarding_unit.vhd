library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forwarding_unit is
  port(
    FU_EXMEM_IR2016 : in  std_logic_vector(3 downto 0);
    FU_EXMEM_IR1511 : in  std_logic_vector(3 downto 0);
    FU_MEMWB_IR2016 : in  std_logic_vector(3 downto 0);
    FU_MEMWB_IR1511 : in  std_logic_vector(3 downto 0);
    FU_IDEX_IR1006  : in  std_logic_vector(3 downto 0);
    FU_IDEX_IR1511  : in  std_logic_vector(3 downto 0);
    FU_IT_SOURCE    : in  std_logic_vector(1 downto 0);
    
    FU_TOP_ALU      : out std_logic_vector(1 downto 0);
    FU_BOT_ALU      : out std_logic_vector(1 downto 0)
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

  signal s_comp_result : std_logic_vector(9 downto 0);

begin
  COMP0 : EQ_COMPARATOR
    generic map(
      COMP_NBIT => 4
    )
    port map(
      COMP_A   => FU_EXMEM_IR2016,
      COMP_B   => FU_IDEX_IR1006,
      COMP_RES => s_comp_result(0)
    );

  COMP1 : EQ_COMPARATOR
    generic map(
      COMP_NBIT => 4
    )
    port map(
      COMP_A   => FU_EXMEM_IR2016,
      COMP_B   => FU_IDEX_IR1511,
      COMP_RES => s_comp_result(1)
    );

  COMP2 : EQ_COMPARATOR
    generic map(
      COMP_NBIT => 4
    )
    port map(
      COMP_A   => FU_MEMWB_IR2016,
      COMP_B   => FU_IDEX_IR1006,
      COMP_RES => s_comp_result(2)
    );

  COMP3 : EQ_COMPARATOR
    generic map(
      COMP_NBIT => 4
    )
    port map(
      COMP_A   => FU_MEMWB_IR2016,
      COMP_B   => FU_IDEX_IR1511,
      COMP_RES => s_comp_result(3)
    );

  COMP4 : EQ_COMPARATOR
    generic map(
      COMP_NBIT => 4
    )
    port map(
      COMP_A   => FU_EXMEM_IR1511,
      COMP_B   => FU_IDEX_IR1006,
      COMP_RES => s_comp_result(4)
    );

  COMP5 : EQ_COMPARATOR
    generic map(
      COMP_NBIT => 4
    )
    port map(
      COMP_A   => FU_EXMEM_IR1511,
      COMP_B   => FU_IDEX_IR1511,
      COMP_RES => s_comp_result(5)
    );

  COMP6 : EQ_COMPARATOR
    generic map(
      COMP_NBIT => 4
    )
    port map(
      COMP_A   => FU_MEMWB_IR1511,
      COMP_B   => FU_IDEX_IR1006,
      COMP_RES => s_comp_result(6)
    );

  COMP7 : EQ_COMPARATOR
    generic map(
      COMP_NBIT => 4
    )
    port map(
      COMP_A   => FU_MEMWB_IR1511,
      COMP_B   => FU_IDEX_IR1511,
      COMP_RES => s_comp_result(7)
    );

  COMP8 : EQ_COMPARATOR
    generic map(
      COMP_NBIT => 4
    )
    port map(
      COMP_A   => FU_MEMWB_IR1511,
      COMP_B   => FU_IDEX_IR1006,
      COMP_RES => s_comp_result(8)
    );

  COMP9 : EQ_COMPARATOR
    generic map(
      COMP_NBIT => 4
    )
    port map(
      COMP_A   => FU_MEMWB_IR1511,
      COMP_B   => FU_IDEX_IR1511,
      COMP_RES => s_comp_result(9)
    );

  ALU_TOP_FORWARD : process(s_comp_result, FU_IT_SOURCE)
    variable v_comp_result : integer;
  begin
    v_comp_result := to_integer(unsigned(s_comp_result));
    case v_comp_result is
      when 1 | 16 =>
        FU_TOP_ALU <= "01";
      when 4 =>
        FU_TOP_ALU <= "10";

      when 320  =>
        if FU_IT_SOURCE = "10" then
          FU_TOP_ALU <= "10";
        else
          if FU_IT_SOURCE = "01" then
            FU_TOP_ALU <= "11";
          end if;
        end if;
      when others => FU_TOP_ALU <= "00";
    end case;
  end process ALU_TOP_FORWARD;

  ALU_BOT_FORWARD : process(s_comp_result, FU_IT_SOURCE)
    variable v_comp_result : integer;
  begin
    v_comp_result := to_integer(unsigned(s_comp_result));
    case v_comp_result is
      when 2 | 32 =>
        FU_BOT_ALU <= "01";
      when 8 =>
        FU_BOT_ALU <= "10";

      when 640 =>
        if FU_IT_SOURCE = "10" then
          FU_BOT_ALU <= "10";
        else
          if FU_IT_SOURCE = "01" then
            FU_BOT_ALU <= "11";
          end if;
        end if;
        
      when others => FU_BOT_ALU <= "00";
    end case;
  end process ALU_BOT_FORWARD;



end architecture STR;
