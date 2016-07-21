library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.REGF_pkg.all;

entity TB_REGF_register_file is
end TB_REGF_register_file;

architecture TEST of TB_REGF_register_file is

    component REGF_register_file is
        generic(
            REGF_NBIT   :   integer :=  4;
            REGF_NREG   :   integer :=  8);
        port(
            REGF_clk        :   in  std_logic;
            REGF_rst        :   in  std_logic;
            REGF_write_en   :   in  std_logic;
            REGF_write_addr :   in  std_logic_vector(log2ceil(REGF_NREG)-1 downto 0);
            REGF_write_data :   in  std_logic_vector(REGF_NBIT-1 downto 0);
            REGF_read_addr1 :   in  std_logic_vector(log2ceil(REGF_NREG)-1 downto 0);
            REGF_read_addr2 :   in  std_logic_vector(log2ceil(REGF_NREG)-1 downto 0);
            REGF_read_out1  :   out std_logic_vector(REGF_NBIT-1 downto 0);
            REGF_read_out2  :   out std_logic_vector(REGF_NBIT-1 downto 0));
    end component;

    constant c_REGF_NBIT    :   integer :=  4;
    constant c_REGF_NREG    :   integer :=  8;

    signal s_REGF_clk           :   std_logic                                           :=  '0';
    signal s_REGF_rst           :   std_logic                                           :=  '0';
    signal s_REGF_write_en      :   std_logic                                           :=  '0';
    signal s_REGF_write_addr    :   std_logic_vector(log2ceil(c_REGF_NREG)-1 downto 0)  :=  (others => '0');
    signal s_REGF_write_data    :   std_logic_vector(c_REGF_NBIT-1 downto 0)            :=  (others => '0');
    signal s_REGF_read_addr1    :   std_logic_vector(log2ceil(c_REGF_NREG)-1 downto 0)  :=  (others => '0');
    signal s_REGF_read_addr2    :   std_logic_vector(log2ceil(c_REGF_NREG)-1 downto 0)  :=  (others => '0');
    signal s_REGF_read_out1     :   std_logic_vector(c_REGF_NBIT-1 downto 0)            :=  (others => '0');
    signal s_REGF_read_out2     :   std_logic_vector(c_REGF_NBIT-1 downto 0)            :=  (others => '0');

begin

    UUT : REGF_register_file
        generic map(
            REGF_NBIT   =>  c_REGF_NBIT,
            REGF_NREG   =>  c_REGF_NREG)
        port map(
            REGF_clk        =>  s_REGF_clk,
            REGF_rst        =>  s_REGF_rst,
            REGF_write_en   =>  s_REGF_write_en,
            REGF_write_addr =>  s_REGF_write_addr,
            REGF_write_data =>  s_REGF_write_data,
            REGF_read_addr1 =>  s_REGF_read_addr1,
            REGF_read_addr2 =>  s_REGF_read_addr2,
            REGF_read_out1  =>  s_REGF_read_out1,
            REGF_read_out2  =>  s_REGF_read_out2);

    CLOCK_PROCESS : process
    begin
        s_REGF_clk  <= '0';
        wait for 1 ns;
        s_REGF_clk  <= '1';
        wait for 1 ns;
    end process;

    INPUT_STIMULI_PROCESS : process
    begin
        s_REGF_rst  <= '0';
        wait for 1 ns;
        s_REGF_rst  <= '1';
        wait for 2 ns;
        LOAD_VALUES : for i in 0 to c_REGF_NREG-1 loop
            s_REGF_write_en <=  '1';
            s_REGF_write_data   <=  std_logic_vector(to_unsigned(i+3,c_REGF_NBIT));
            s_REGF_write_addr   <=  std_logic_vector(to_unsigned(i,c_REGF_NBIT));
            wait for 2 ns;
        end loop;

        s_REGF_write_en <= '0';

        wait for 2 ns;
        READ_VALUES : for i in 0 to c_REGF_NREG-1 loop
            s_REGF_read_addr1   <=  std_logic_vector(to_unsigned(i,c_REGF_NBIT));
            s_REGF_read_addr2   <=  std_logic_vector(to_unsigned(i+1,c_REGF_NBIT));
            wait for 2 ns;
        end loop;

        wait for 2 ns;
        s_REGF_rst  <=  '0';

        wait for 4 ns;
        CHECK_RESET : for i in 0 to c_REGF_NREG-1 loop
            s_REGF_read_addr1   <=  std_logic_vector(to_unsigned(i,c_REGF_NBIT));
            wait for 2 ns;
        end loop;
        wait;
    end process;
end TEST;
