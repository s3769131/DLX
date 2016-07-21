library ieee;
use ieee.std_logic_1164.all;
use work.REGF_pkg.all;

entity REGF_register_file is
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
end REGF_register_file;

architecture str of REGF_register_file is

    component REGF_decoder is
        generic(
            DEC_NBIT    :   integer :=  5);
        port(
            DEC_address :   in  std_logic_vector(DEC_NBIT-1 downto 0);
            DEC_enable  :   in  std_logic;
            DEC_output  :   out std_logic_vector(2**DEC_NBIT-1 downto 0));
    end component;

    component REGF_multiplexer is
        generic(
            MUX_NBIT    :   integer :=  4;
            MUX_NSEL    :   integer :=  3);
        port(
            MUX_inputs  :   in  std_logic_vector(MUX_NBIT*(2**MUX_NSEL)-1 downto 0);
            MUX_select  :   in  std_logic_vector(MUX_NSEL-1 downto 0);
            MUX_output  :   out std_logic_vector(MUX_NBIT-1 downto 0));
    end component;

    component REGF_register is
        generic(
            REG_NBIT    :   integer :=  8);
        port(
            REG_clk         :   in  std_logic;
            REG_rst         :   in  std_logic;
            REG_enable      :   in  std_logic;
            REG_data_in     :   in  std_logic_vector(REGF_NBIT-1 downto 0);
            REG_data_out    :   out std_logic_vector(REGF_NBIT-1 downto 0));
    end component;

    signal s_register_enable    :   std_logic_vector(REGF_NREG-1 downto 0);
    signal s_multiplexer_inputs :   std_logic_vector(REGF_NBIT*REGF_NREG-1 downto 0);

begin

    WRITE_DECODER : REGF_decoder
        generic map(
            DEC_NBIT    =>  log2ceil(REGF_NREG))
        port map(
            DEC_address =>  REGF_write_addr,
            DEC_enable  =>  REGF_write_en,
            DEC_output  =>  s_register_enable);

    GATE1_MULTIPLEXER : REGF_multiplexer
        generic map(
            MUX_NBIT    =>  REGF_NBIT,
            MUX_NSEL    =>  log2ceil(REGF_NREG))
        port map(
            MUX_inputs  =>  s_multiplexer_inputs,
            MUX_select  =>  REGF_read_addr1,
            MUX_output  =>  REGF_read_out1);

    GATE2_MULTIPLEXER : REGF_multiplexer
        generic map(
            MUX_NBIT    =>  REGF_NBIT,
            MUX_NSEL    =>  log2ceil(REGF_NREG))
        port map(
            MUX_inputs  =>  s_multiplexer_inputs,
            MUX_select  =>  REGF_read_addr2,
            MUX_output  =>  REGF_read_out2);

    REGISTER_GEN : for i in 0 to REGF_NREG-1 generate
        R0_REGISTER : if i = 0 generate
            REG : REGF_register
                generic map(
                    REG_NBIT    =>  REGF_NBIT)
                port map(
                    REG_clk         =>  '0',
                    REG_rst         =>  '0',
                    REG_enable      =>  '0',
                    REG_data_in     =>  (others => '0'),
                    REG_data_out    =>  s_multiplexer_inputs(REGF_NBIT-1 downto 0));
        end generate;
        OTHER_REGISTERS : if i /= 0 generate
            REG : REGF_register
                generic map(
                    REG_NBIT    =>  REGF_NBIT)
                port map(
                    REG_clk         =>  REGF_clk,
                    REG_rst         =>  REGF_rst,
                    REG_enable      =>  s_register_enable(i),
                    REG_data_in     =>  REGF_write_data,
                    REG_data_out    =>  s_multiplexer_inputs((i+1)*REGF_NBIT-1 downto i*REGF_NBIT));
        end generate;
    end generate;

end str;

configuration CFG_REGF_REGISTER_FILE_STR of REGF_register_file is
    for str
        for WRITE_DECODER : REGF_decoder
            use configuration work.CFG_REGF_DECODER_BHV;
        end for;
        for GATE1_MULTIPLEXER : REGF_multiplexer
            use configuration work.CFG_REGF_MULTIPLEXER_DFLOW;
        end for;
        for GATE2_MULTIPLEXER : REGF_multiplexer
            use configuration work.CFG_REGF_MULTIPLEXER_DFLOW;
        end for;
        for REGISTER_GEN
            for R0_REGISTER
                for REG : REGF_register
                    use configuration work.CFG_REGF_REGISTER_BHV;
                end for;
            end for;
            for OTHER_REGISTERS
                for REG : REGF_register
                    use configuration work.CFG_REGF_REGISTER_BHV;
                end for;
            end for;
        end for;
    end for;
end CFG_REGF_REGISTER_FILE_STR;
