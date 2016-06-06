library ieee;
use ieee.std_logic_1164.all;
use work.DLX_pkg.all;

entity testbench_P4_adder is
end entity testbench_P4_adder;

architecture TEST of testbench_P4_adder is

  component P4_adder is
    generic(
      P4_NBIT   : integer := 32;
      P4_CSTEP : integer := 4);
    port(
      P4_operand_A :      in   std_logic_vector(P4_NBIT downto 1);
      P4_operand_B :      in   std_logic_vector(P4_NBIT downto 1);
      P4_carry_in  :      in   std_logic;
      P4_result    :      out  std_logic_vector(P4_NBIT downto 1);
      P4_carry_out :      out  std_logic);
  end component P4_adder;

  -- input signals for 16-bit adders
  signal s_adder_N16_op1 : std_logic_vector(15 downto 0) := (others => '0');
  signal s_adder_N16_op2 : std_logic_vector(15 downto 0) := (others => '0');
  signal s_adder_N16_cin : std_logic := '0';
  -- output signals for 16-bit adders, for carry generated every 2, 4 or 8 bits
  signal s_adder_N16_C2_res  : std_logic_vector(15 downto 0) := (others => '0');
  signal s_adder_N16_C2_cout : std_logic := '0';
  signal s_adder_N16_C4_res  : std_logic_vector(15 downto 0) := (others => '0');
  signal s_adder_N16_C4_cout : std_logic := '0';
  signal s_adder_N16_C8_res  : std_logic_vector(15 downto 0) := (others => '0');
  signal s_adder_N16_C8_cout : std_logic := '0';

  -- input signals for 32-bit adders
  signal s_adder_N32_op1 : std_logic_vector(31 downto 0) := (others => '0');
  signal s_adder_N32_op2 : std_logic_vector(31 downto 0) := (others => '0');
  signal s_adder_N32_cin : std_logic := '0';
  -- output signals for 32-bit adders, for carry generated every 2, 4 or 8 bits
  signal s_adder_N32_C2_res  : std_logic_vector(31 downto 0) := (others => '0');
  signal s_adder_N32_C2_cout : std_logic := '0';
  signal s_adder_N32_C4_res  : std_logic_vector(31 downto 0) := (others => '0');
  signal s_adder_N32_C4_cout : std_logic := '0';
  signal s_adder_N32_C8_res  : std_logic_vector(31 downto 0) := (others => '0');
  signal s_adder_N32_C8_cout : std_logic := '0';

  -- input signals for 64-bit adders
  signal s_adder_N64_op1 : std_logic_vector(63 downto 0) := (others => '0');
  signal s_adder_N64_op2 : std_logic_vector(63 downto 0) := (others => '0');
  signal s_adder_N64_cin : std_logic := '0';
  -- output signals for 64-bit adders, for carry generated every 2, 4 or 8 bits
  signal s_adder_N64_C2_res  : std_logic_vector(63 downto 0) := (others => '0');
  signal s_adder_N64_C2_cout : std_logic := '0';
  signal s_adder_N64_C4_res  : std_logic_vector(63 downto 0) := (others => '0');
  signal s_adder_N64_C4_cout : std_logic := '0';
  signal s_adder_N64_C8_res  : std_logic_vector(63 downto 0) := (others => '0');
  signal s_adder_N64_C8_cout : std_logic := '0';

begin

  UUT_ADDER_N16_C2: P4_adder
    generic map (
      P4_NBIT  => 16,
      P4_CSTEP => 2)
    port map (
      P4_operand_A => s_adder_N16_op1,
      P4_operand_B => s_adder_N16_op2,
      P4_carry_in  => s_adder_N16_cin,
      P4_result    => s_adder_N16_C2_res,
      P4_carry_out => s_adder_N16_C2_cout);
  
  UUT_ADDER_N16_C4: P4_adder
    generic map (
      P4_NBIT  => 16,
      P4_CSTEP => 4)
    port map (
      P4_operand_A => s_adder_N16_op1,
      P4_operand_B => s_adder_N16_op2,
      P4_carry_in  => s_adder_N16_cin,
      P4_result    => s_adder_N16_C4_res,
      P4_carry_out => s_adder_N16_C4_cout);

  UUT_ADDER_N16_C8: P4_adder
    generic map (
      P4_NBIT  => 16,
      P4_CSTEP => 8)
    port map (
      P4_operand_A => s_adder_N16_op1,
      P4_operand_B => s_adder_N16_op2,
      P4_carry_in  => s_adder_N16_cin,
      P4_result    => s_adder_N16_C8_res,
      P4_carry_out => s_adder_N16_C8_cout);
  
  UUT_ADDER_N32_C2: P4_adder
    generic map (
      P4_NBIT  => 32,
      P4_CSTEP => 2)
    port map (
      P4_operand_A => s_adder_N32_op1,
      P4_operand_B => s_adder_N32_op2,
      P4_carry_in  => s_adder_N32_cin,
      P4_result    => s_adder_N32_C2_res,
      P4_carry_out => s_adder_N32_C2_cout);
  
  UUT_ADDER_N32_C4: P4_adder
    generic map (
      P4_NBIT  => 32,
      P4_CSTEP => 4)
    port map (
      P4_operand_A => s_adder_N32_op1,
      P4_operand_B => s_adder_N32_op2,
      P4_carry_in  => s_adder_N32_cin,
      P4_result    => s_adder_N32_C4_res,
      P4_carry_out => s_adder_N32_C4_cout);

  UUT_ADDER_N32_C8: P4_adder
    generic map (
      P4_NBIT  => 32,
      P4_CSTEP => 8)
    port map (
      P4_operand_A => s_adder_N32_op1,
      P4_operand_B => s_adder_N32_op2,
      P4_carry_in  => s_adder_N32_cin,
      P4_result    => s_adder_N32_C8_res,
      P4_carry_out => s_adder_N32_C8_cout);
  
  UUT_ADDER_N64_C2: P4_adder
    generic map (
      P4_NBIT  => 64,
      P4_CSTEP => 2)
    port map (
      P4_operand_A => s_adder_N64_op1,
      P4_operand_B => s_adder_N64_op2,
      P4_carry_in  => s_adder_N64_cin,
      P4_result    => s_adder_N64_C2_res,
      P4_carry_out => s_adder_N64_C2_cout);
  
  UUT_ADDER_N64_C4: P4_adder
    generic map (
      P4_NBIT  => 64,
      P4_CSTEP => 4)
    port map (
      P4_operand_A => s_adder_N64_op1,
      P4_operand_B => s_adder_N64_op2,
      P4_carry_in  => s_adder_N64_cin,
      P4_result    => s_adder_N64_C4_res,
      P4_carry_out => s_adder_N64_C4_cout);

  UUT_ADDER_N64_C8: P4_adder
    generic map (
      P4_NBIT  => 64,
      P4_CSTEP => 8)
    port map (
      P4_operand_A => s_adder_N64_op1,
      P4_operand_B => s_adder_N64_op2,
      P4_carry_in  => s_adder_N64_cin,
      P4_result    => s_adder_N64_C8_res,
      P4_carry_out => s_adder_N64_C8_cout);

  -- purpose: process in charge of applying test stimuli for 16-bit adders
  -- type   : combinational
  INPUT_PROCESS_N16: process is
  begin
    s_adder_N16_op1 <= x"FFFF";
    s_adder_N16_op2 <= x"0001";
    s_adder_N16_cin <= '0';
    wait for 10 ns;
    s_adder_N16_cin <= '1';
    wait for 10 ns;
    s_adder_N16_op1 <= x"FFFF";
    s_adder_N16_op2 <= x"FFFF";
    s_adder_N16_cin <= '0';
    wait for 10 ns;
    s_adder_N16_cin <= '1';
    wait for 10 ns;
    s_adder_N16_op1 <= x"04F2";
    s_adder_N16_op2 <= x"3210";
    s_adder_N16_cin <= '0';
    wait for 10 ns;
    s_adder_N16_cin <= '1';
    wait;    
  end process INPUT_PROCESS_N16;

  -- purpose: process in charge of applying test stimuli for 32-bit adders
  -- type   : combinational
  INPUT_PROCESS_N32: process is
  begin
    s_adder_N32_op1 <= x"FFFFFFFF";
    s_adder_N32_op2 <= x"00000001";
    s_adder_N32_cin <= '0';
    wait for 10 ns;
    s_adder_N32_cin <= '1';
    wait for 10 ns;
    s_adder_N32_op1 <= x"FFFFFFFF";
    s_adder_N32_op2 <= x"FFFFFFFF";
    s_adder_N32_cin <= '0';
    wait for 10 ns;
    s_adder_N32_cin <= '1';
    wait for 10 ns;
    s_adder_N32_op1 <= x"04F20312";
    s_adder_N32_op2 <= x"3210003A";
    s_adder_N32_cin <= '0';
    wait for 10 ns;
    s_adder_N32_cin <= '1';
    wait;    
  end process INPUT_PROCESS_N32;

  -- purpose: process in charge of applying test stimuli for 64-bit adders
  -- type   : combinational
  INPUT_PROCESS_N64: process is
  begin
    s_adder_N64_op1 <= x"FFFFFFFFFFFFFFFF";
    s_adder_N64_op2 <= x"0000000000000001";
    s_adder_N64_cin <= '0';
    wait for 10 ns;
    s_adder_N64_cin <= '1';
    wait for 10 ns;
    s_adder_N64_op1 <= x"FFFFFFFFFFFFFFFF";
    s_adder_N64_op2 <= x"FFFFFFFFFFFFFFFF";
    s_adder_N64_cin <= '0';
    wait for 10 ns;
    s_adder_N64_cin <= '1';
    wait for 10 ns;
    s_adder_N64_op1 <= x"04F20A0B0E0C0002";
    s_adder_N64_op2 <= x"3210023468723877";
    s_adder_N64_cin <= '0';
    wait for 10 ns;
    s_adder_N64_cin <= '1';
    wait;    
  end process INPUT_PROCESS_N64;

end architecture TEST;
