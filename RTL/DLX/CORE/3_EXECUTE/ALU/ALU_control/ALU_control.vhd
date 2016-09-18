library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

entity ALU_control is
  port(
    ALU_CTRL_command   : in  std_logic_vector(5 downto 0);
    ALU_CTRL_shf_lr    : out std_logic;
    ALU_CTRL_shf_la    : out std_logic;
    ALU_CTRL_add_sub   : out std_logic;
    ALU_CTRL_comp_sign : out std_logic;
    ALU_CTRL_res_sel   : out std_logic_vector(1 downto 0);
    ALU_CTRL_comp_sel  : out std_logic_vector(2 downto 0);
    ALU_CTRL_log_func  : out std_logic_vector(3 downto 0));
end ALU_control;

architecture bhv of ALU_control is
  signal s_control_00 : std_logic_vector(12 downto 0);
  signal s_control_01 : std_logic_vector(12 downto 0);
  signal s_control_10 : std_logic_vector(12 downto 0);
  signal s_control_11 : std_logic_vector(12 downto 0);
  signal s_out        : std_logic_vector(12 downto 0);

  component mux_4to1
    generic(MUX_4to1_NBIT : integer := 4);
    port(
      MUX_4to1_in0 : in  std_logic_vector(MUX_4to1_NBIT - 1 downto 0);
      MUX_4to1_in1 : in  std_logic_vector(MUX_4to1_NBIT - 1 downto 0);
      MUX_4to1_in2 : in  std_logic_vector(MUX_4to1_NBIT - 1 downto 0);
      MUX_4to1_in3 : in  std_logic_vector(MUX_4to1_NBIT - 1 downto 0);
      MUX_4to1_sel : in  std_logic_vector(1 downto 0);
      MUX_4to1_out : out std_logic_vector(MUX_4to1_NBIT - 1 downto 0)
    );
  end component mux_4to1;

begin
  -- ORIGINAL FROM EMA
   MAIN : process(ALU_CTRL_command)
    begin
        if ALU_CTRL_command(5 downto 4) = "00" then
            ALU_CTRL_res_sel    <=  "00";
            ALU_CTRL_shf_lr     <=  ALU_CTRL_command(3);
            ALU_CTRL_shf_la     <=  ALU_CTRL_command(2);
        elsif ALU_CTRL_command(5 downto 4) = "01" then
            ALU_CTRL_res_sel    <=  "01";
            ALU_CTRL_add_sub    <=  ALU_CTRL_command(3);
        elsif ALU_CTRL_command(5 downto 4) = "10" then
            ALU_CTRL_res_sel    <=  "10";
            ALU_CTRL_comp_sel   <=  ALU_CTRL_command(3 downto 1);
            ALU_CTRL_comp_sign  <=  ALU_CTRL_command(0);
        elsif ALU_CTRL_command(5 downto 4) = "11" then
            ALU_CTRL_res_sel    <=  "11";
            ALU_CTRL_log_func   <=  ALU_CTRL_command(3 downto 0);
        end if;
    end process;


  -- MODIFIED BY SIMO (STILL SEQUENTIAL)
  --MAIN : process(ALU_CTRL_command)
  --begin
  --  if ALU_CTRL_command(5 downto 4) = "00" then
  --    ALU_CTRL_shf_lr  <= ALU_CTRL_command(3);
  --    ALU_CTRL_shf_la  <= ALU_CTRL_command(2);
  --    ALU_CTRL_add_sub   <= '0';
  --    ALU_CTRL_comp_sign <= '0';
  --    ALU_CTRL_res_sel <= "00";
  --    ALU_CTRL_comp_sel  <= (others => '0');
  --    ALU_CTRL_log_func  <= (others => '0');
  --
  --
  --  elsif ALU_CTRL_command(5 downto 4) = "01" then
  --    ALU_CTRL_shf_lr    <= '0';
  --    ALU_CTRL_shf_la    <= '0';
  --    ALU_CTRL_add_sub <= ALU_CTRL_command(3);
  --    ALU_CTRL_comp_sign <= '0';
  --    ALU_CTRL_res_sel <= "01";
  --    ALU_CTRL_comp_sel  <= (others => '0');
  --    ALU_CTRL_log_func <= (others => '0');
  --
  --
  --
  --  elsif ALU_CTRL_command(5 downto 4) = "10" then
  --    ALU_CTRL_shf_lr   <= '0';
  --    ALU_CTRL_shf_la   <= '0';
  --    ALU_CTRL_add_sub  <= '0';
  --    ALU_CTRL_comp_sign <= ALU_CTRL_command(0);
  --    ALU_CTRL_res_sel   <= "10";
  --    ALU_CTRL_comp_sel  <= ALU_CTRL_command(3 downto 1);
  --    ALU_CTRL_log_func <= (others => '0');
  --
  --
  --  elsif ALU_CTRL_command(5 downto 4) = "11" then
  --    ALU_CTRL_shf_lr    <= '0';
  --    ALU_CTRL_shf_la    <= '0';
  --    ALU_CTRL_add_sub   <= '0';
  --    ALU_CTRL_comp_sign <= '0';
  --    ALU_CTRL_res_sel  <= "11";
  --    ALU_CTRL_comp_sel  <= (others => '0');
  --    ALU_CTRL_log_func <= ALU_CTRL_command(3 downto 0);
  --
  --
  --  end if;
  --end process;
  
  
 -- s_control_00 <= ALU_CTRL_command(3) & ALU_CTRL_command(2) & '0' & '0' & "00" & "000" & "0000";
 -- s_control_01 <= '0' & '0' & ALU_CTRL_command(3) & '0' & "01" & "000" & "0000";
 -- s_control_10 <= '0' & '0' & '0' & ALU_CTRL_command(0) & "10" & ALU_CTRL_command(3 downto 1) & "0000";
 -- s_control_11 <= '0' & '0' & '0' & '0' & "11" & "000" & ALU_CTRL_command(3 downto 0);

 -- MUX : mux_4to1
 --   generic map(
 --     MUX_4to1_NBIT => 13
 --   )
 --   port map(
 --     MUX_4to1_in0 => s_control_00,
 --     MUX_4to1_in1 => s_control_01,
 --     MUX_4to1_in2 => s_control_10,
 --     MUX_4to1_in3 => s_control_11,
 --     MUX_4to1_sel => ALU_CTRL_command(5 downto 4),
 --     MUX_4to1_out => s_out
 --   );
 --
 -- ALU_CTRL_shf_lr    <= s_out(12);
 -- ALU_CTRL_shf_la    <= s_out(11);
 -- ALU_CTRL_add_sub   <= s_out(10);
 -- ALU_CTRL_comp_sign <= s_out(9);
 -- ALU_CTRL_res_sel   <= s_out(8 downto 7);
 -- ALU_CTRL_comp_sel  <= s_out(6 downto 4);
 -- ALU_CTRL_log_func  <= s_out(3 downto 0);

end bhv;

configuration CFG_ALU_CONTROL_BHV of ALU_control is
  for bhv
    for all : mux_4to1
      use configuration work.CFG_MUX_4to1_BHV;
    end for;

  end for;
end CFG_ALU_CONTROL_BHV;
