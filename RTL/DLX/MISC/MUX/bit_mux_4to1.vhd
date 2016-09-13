library ieee;
use ieee.std_logic_1164.all;

entity bit_mux_4to1 is
  port(
    BIT_MUX_4to1_in0 : in  std_logic;
    BIT_MUX_4to1_in1 : in  std_logic;
    BIT_MUX_4to1_in2 : in  std_logic;
    BIT_MUX_4to1_in3 : in  std_logic;
    BIT_MUX_4to1_sel : in  std_logic_vector(1 downto 0);
    BIT_MUX_4to1_out : out std_logic);
end entity bit_mux_4to1;

architecture bhv of bit_mux_4to1 is
  component bit_mux_2to1
    port(
      BIT_MUX_2to1_in0 : in  std_logic;
      BIT_MUX_2to1_in1 : in  std_logic;
      BIT_MUX_2to1_sel : in  std_logic;
      BIT_MUX_2to1_out : out std_logic
    );
  end component bit_mux_2to1;

  signal s_top : std_logic;
  signal s_bot : std_logic;

begin
  TOP_MUX : bit_mux_2to1
    port map(
      BIT_MUX_2to1_in0 => BIT_MUX_4to1_in0,
      BIT_MUX_2to1_in1 => BIT_MUX_4to1_in1,
      BIT_MUX_2to1_sel => BIT_MUX_4to1_sel(0),
      BIT_MUX_2to1_out => s_top
    );

  BOT_MUX : bit_mux_2to1
    port map(
      BIT_MUX_2to1_in0 => BIT_MUX_4to1_in2,
      BIT_MUX_2to1_in1 => BIT_MUX_4to1_in3,
      BIT_MUX_2to1_sel => BIT_MUX_4to1_sel(0),
      BIT_MUX_2to1_out => s_bot
    );

  FINAL_MUX : bit_mux_2to1
    port map(
      BIT_MUX_2to1_in0 => s_top,
      BIT_MUX_2to1_in1 => s_bot,
      BIT_MUX_2to1_sel => BIT_MUX_4to1_sel(1),
      BIT_MUX_2to1_out => BIT_MUX_4to1_out
    );

-- MAIN : process(BIT_MUX_4to1_in0, BIT_MUX_4to1_in1, BIT_MUX_4to1_in2, BIT_MUX_4to1_in3, BIT_MUX_4to1_sel)
-- begin
--    if BIT_MUX_4to1_sel = "00" then
--       BIT_MUX_4to1_out  <= BIT_MUX_4to1_in0;
--    elsif BIT_MUX_4to1_sel = "01" then
--       BIT_MUX_4to1_out  <= BIT_MUX_4to1_in1;
--    elsif BIT_MUX_4to1_sel = "10" then
--       BIT_MUX_4to1_out  <= BIT_MUX_4to1_in2;
--    elsif BIT_MUX_4to1_sel = "11" then
--       BIT_MUX_4to1_out  <= BIT_MUX_4to1_in3;
--    end if;
-- end process;

end architecture bhv;

configuration CFG_BIT_MUX_4to1_BHV of bit_mux_4to1 is
  for bhv
    for all : bit_mux_2to1
      use configuration work.CFG_BIT_MUX_2to1_BHV;
    end for;
  end for;
end configuration CFG_BIT_MUX_4to1_BHV;
