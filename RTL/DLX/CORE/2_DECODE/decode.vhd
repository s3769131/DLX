library ieee;
use ieee.std_logic_1164.all;
use work.DLX_pkg.all;

entity decode is
    generic(
        DECODE_NREG         :   positive    :=  32;
        DECODE_NBIT         :   positive    :=  32;
        DECODE_IR_NBIT      :   positive    :=  32);
    port(
        DECODE_clk              :   in  std_logic;
        DECODE_rst              :   in  std_logic;
        DECODE_sigext_op        :   in  std_logic_vector(1 downto 0);
        DECODE_ir               :   in  std_logic_vector(DECODE_IR_NBIT-1 downto 0);
        DECODE_destination_sel  :   in  std_logic; -- wheather destination is rt od rd
        DECODE_rf_write_en      :   in  std_logic;
        DECODE_rf_data_write    :   in  std_logic_vector(DECODE_NBIT-1 downto 0);
        DECODE_rf_addr_write    :   in  std_logic_vector(log2ceil(DECODE_NREG)-1 downto 0);
        DECODE_rf_read_en_rs    :   in  std_logic;
        DECODE_rf_read_en_rt    :   in  std_logic;
        DECODE_pc_in            :   in  std_logic_vector(DECODE_NBIT-1 downto 0);
        DECODE_npc_in           :   in  std_logic_vector(DECODE_NBIT-1 downto 0);
        DECODE_sigext_out       :   out std_logic_vector(DECODE_NBIT-1 downto 0);
        DECODE_rf_addr_dest     :   out std_logic_vector(log2ceil(DECODE_NREG)-1 downto 0);
        DECODE_rf_data_read1    :   out std_logic_vector(DECODE_NBIT-1 downto 0);
        DECODE_rf_data_read2    :   out std_logic_vector(DECODE_NBIT-1 downto 0);
        DECODE_pc_out           :   out std_logic_vector(DECODE_NBIT-1 downto 0);
        DECODE_npc_out          :   out std_logic_vector(DECODE_NBIT-1 downto 0));
end decode;

architecture str of decode is

    component mux_4to1 is
        generic (
            MUX_4to1_NBIT   :   integer :=  4);
        port (
            MUX_4to1_in0    :   in  std_logic_vector(MUX_4to1_NBIT-1 downto 0);
            MUX_4to1_in1    :   in  std_logic_vector(MUX_4to1_NBIT-1 downto 0);
            MUX_4to1_in2    :   in  std_logic_vector(MUX_4to1_NBIT-1 downto 0);
            MUX_4to1_in3    :   in  std_logic_vector(MUX_4to1_NBIT-1 downto 0);
            MUX_4to1_sel    :   in  std_logic;
            MUX_4to1_out    :   out std_logic_vector(MUX_4to1_NBIT-1 downto 0));
    end component mux_4to1;

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
            REGF_read_en1   :   in  std_logic;
            REGF_read_addr1 :   in  std_logic_vector(log2ceil(REGF_NREG)-1 downto 0);
            REGF_read_en2   :   in  std_logic;
            REGF_read_addr2 :   in  std_logic_vector(log2ceil(REGF_NREG)-1 downto 0);
            REGF_read_out1  :   out std_logic_vector(REGF_NBIT-1 downto 0);
            REGF_read_out2  :   out std_logic_vector(REGF_NBIT-1 downto 0));
    end component;

    component sign_extention_decode is
        generic(
            SIGN_EXT_NBIT   :   positive :=  32);
        port (
            SIGN_EXT_op     :   in  std_logic_vector(1 downto 0);
            SIGN_EXT_input  :   in  std_logic_vector(SIGN_EXT_NBIT-1 downto 0);
            SIGN_EXT_output :   out std_logic_vector(SIGN_EXT_NBIT-1 downto 0));
    end component;

    signal s_rf_addr_rs     :   std_logic_vector(log2ceil(DECODE_NREG)-1 downto 0);
    signal s_rf_addr_rt     :   std_logic_vector(log2ceil(DECODE_NREG)-1 downto 0);
    signal s_rf_addr_rd     :   std_logic_vector(log2ceil(DECODE_NREG)-1 downto 0);

begin

    s_rf_addr_rs    <=  DECODE_ir(25 downto 21);
    s_rf_addr_rt    <=  DECODE_ir(20 downto 16);
    s_rf_addr_rd    <=  DECODE_ir(15 downto 11);
    REGISTER_FILE : REGF_register_file
        generic map(
            REGF_NBIT   =>  DECODE_NBIT,
            REGF_NREG   =>  DECODE_NREG)
        port map(
            REGF_clk        =>  DECODE_clk,
            REGF_rst        =>  DECODE_rst,
            REGF_write_en   =>  DECODE_rf_write_en,
            REGF_write_addr =>  DECODE_rf_addr_write,
            REGF_write_data =>  DECODE_rf_data_write,
            REGF_read_en1   =>  DECODE_rf_read_en_rs,
            REGF_read_addr1 =>  s_rf_addr_rs,
            REGF_read_en2   =>  DECODE_rf_read_en_rt,
            REGF_read_addr2 =>  s_rf_addr_rt,
            REGF_read_out1  =>  DECODE_rf_data_read1,
            REGF_read_out2  =>  DECODE_rf_data_read2);

    SIGN_EXT : sign_extention_decode
        generic map(
            SIGN_EXT_NBIT   =>  DECODE_IR_NBIT)
        port map(
            SIGN_EXT_op     =>  DECODE_sigext_op,
            SIGN_EXT_input  =>  DECODE_ir,
            SIGN_EXT_output =>  DECODE_sigext_out);

    DECODE_pc_out   <=  DECODE_pc_in;
    DECODE_npc_out  <=  DECODE_npc_in;

    DESTINATION_MUX : mux_4to1
        generic map(
            MUX_4to1_NBIT   =>  log2ceil(DECODE_NREG))
        port map(
            MUX_4to1_in0    =>  (others => '0'),
            MUX_4to1_in1    =>  s_rf_addr_rt,
            MUX_4to1_in2    =>  s_rf_addr_rd,
            MUX_4to1_in3    =>  (others => '1'),
            MUX_4to1_sel    =>  DECODE_destination_sel,
            MUX_4to1_out    =>  DECODE_rf_addr_dest);

end str;

configuration CFG_DECODE_STR of decode is
    for str
        for REGISTER_FILE : REGF_register_file
            use configuration work.CFG_REGF_REGISTER_FILE_STR;
        end for;
        for SIGN_EXT : sign_extention_decode
            use configuration work.CFG_SIGN_EXTENTION_DEC_STR;
        end for;
        for DESTINATION_MUX : mux_4to1
            use configuration work.CFG_MUX_4to1_BHV;
        end for;
    end for;
end CFG_DECODE_STR;
