library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_forwarding_unit is
end entity TB_forwarding_unit;

architecture TEST of TB_forwarding_unit is
  component forwarding_unit
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
  end component forwarding_unit;

  signal s_EXMEM_IR2016 : std_logic_vector(3 downto 0) := (others => '0');
  signal s_EXMEM_IR1511 : std_logic_vector(3 downto 0) := (others => '0');
  signal s_MEMWB_IR2016 : std_logic_vector(3 downto 0) := (others => '0');
  signal s_MEMWB_IR1511 : std_logic_vector(3 downto 0) := (others => '0');
  signal s_IDEX_IR1006  : std_logic_vector(3 downto 0) := (others => '0');
  signal s_IDEX_IR1511  : std_logic_vector(3 downto 0) := (others => '0');
  signal s_IT_SOURCE    : std_logic_vector(1 downto 0) := (others => '0');
  signal s_TOP_ALU      : std_logic_vector(1 downto 0) := (others => '0');
  signal s_BOT_ALU      : std_logic_vector(1 downto 0) := (others => '0');

  constant c_fake_reg : std_logic_vector(3 downto 0) := "0101";

begin
  UUT : forwarding_unit
    port map(
      FU_EXMEM_IR2016 => s_EXMEM_IR2016,
      FU_EXMEM_IR1511 => s_EXMEM_IR1511,
      FU_MEMWB_IR2016 => s_MEMWB_IR2016,
      FU_MEMWB_IR1511 => s_MEMWB_IR1511,
      FU_IDEX_IR1006  => s_IDEX_IR1006,
      FU_IDEX_IR1511  => s_IDEX_IR1511,
      FU_IT_SOURCE    => s_IT_SOURCE,
      FU_TOP_ALU      => s_TOP_ALU,
      FU_BOT_ALU      => s_BOT_ALU
    );

  STIM : process is
  begin
    wait for 1 ns;
    --- CASE NO FORW ---
    s_EXMEM_IR2016 <= "0000";
    s_EXMEM_IR1511 <= "0001";
    s_MEMWB_IR2016 <= "0010";
    s_MEMWB_IR1511 <= "0011";
    
    s_IDEX_IR1006  <= "0100";
    s_IDEX_IR1511  <= "0101";
    
    s_IT_SOURCE    <= "00";
    
    wait for 1 ns;
    
    --- CASE 0 ---
    s_EXMEM_IR2016 <= c_fake_reg;
    s_EXMEM_IR1511 <= "0001";
    s_MEMWB_IR2016 <= "0010";
    s_MEMWB_IR1511 <= "0011";
    
    s_IDEX_IR1006  <= c_fake_reg;
    s_IDEX_IR1511  <= "0101";
    
    s_IT_SOURCE    <= "00";
 
 wait for 1 ns;
 --- CASE 1 ---
  s_EXMEM_IR2016 <= c_fake_reg;
    s_EXMEM_IR1511 <= "0001";
    s_MEMWB_IR2016 <= "0010";
    s_MEMWB_IR1511 <= "0011";
    
    s_IDEX_IR1006  <= "0100";
    s_IDEX_IR1511  <= c_fake_reg;
    
    s_IT_SOURCE    <= "00";
 
    wait;
 
  end process STIM;

end architecture TEST;
