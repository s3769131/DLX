library ieee;
use ieee.std_logic_1164.all;
--use ieee.math_real.all;
use work.constants.all;
use work.bus_array.all;
use work.DLX_pkg.all;

entity PARALLEL_MUL is
  generic(
    N_PM : integer := 32;               --! Number of bits of the first operand
    M_PM : integer := 32
  );                                    --! Number of bits of the second operand
  port(
    operandA : in  std_logic_vector(N_PM - 1 downto 0);
    operandB : in  std_logic_vector(M_PM - 1 downto 0);
    result   : out std_logic_vector(N_PM + M_PM - 1 downto 0)
  );
end entity;

architecture STR of PARALLEL_MUL is

  -- Component declaration
  component SHIFT_GENERATOR is
    generic(
      N : integer := 32;                --! Number of bits of the first operand
      M : integer := 32
    );                                  --! Number of bits of the second operand
    port(
      A : in  std_logic_vector(N - 1 downto 0);
      Z : out bus_array(2 * M - 1 downto 0)
    );
  end component;

  component BOOTHS_ENC is
    port(
      in_value  : in  std_logic_vector(2 downto 0);
      out_value : out std_logic_vector(2 downto 0)
    );
  end component;

  component MUX_GEN is
    generic(
      N : integer := 8
    );                                  --! Number of inputs
    port(
      A   : in  bus_array(N - 1 downto 0);
      SEL : in  std_logic_vector(log2ceil(N) - 1 downto 0);
      Y   : out std_logic_vector(Nbit + Mbit - 1 downto 0)
    );
  end component;

  component mux2to1 is
    generic(
      MUX2TO1_N : integer := 4);
    port(
      MUX2TO1_in0 : in  std_logic_vector(MUX2TO1_N - 1 downto 0);
      MUX2TO1_in1 : in  std_logic_vector(MUX2TO1_N - 1 downto 0);
      MUX2TO1_sel : in  std_logic;
      MUX2TO1_y   : out std_logic_vector(MUX2TO1_N - 1 downto 0));
  end component;

  component P4_adder is
    generic(
      P4_NBIT  : integer := 32;
      P4_CSTEP : integer := 4);
    port(
      P4_operand_A : in  std_logic_vector(P4_NBIT downto 1);
      P4_operand_B : in  std_logic_vector(P4_NBIT downto 1);
      P4_carry_in  : in  std_logic;
      P4_result    : out std_logic_vector(P4_NBIT downto 1);
      P4_carry_out : out std_logic);
  end component;

  -- Signal declaration

  -- Contains the results of all the possible shifts made by the shift generator
  -- It's an array of 2M-1 std_logic_vectors each of them with N+M bits
  signal shift_results : bus_array(2 * M_PM - 1 downto 0) := (others => (others => '0'));

  -- Contains the control signals for the multiplexers
  signal mux_selections : std_logic_vector(M_PM / 2 * 3 - 1 downto 0) := (others => '0');

  -- Signal used to control the first encored
  -- Needed due to error in simulation using compiler 2007
  -- "Actual (infix expression) for formal "in_value" is not a globally
  -- static expression."
  signal first_encoder_input : std_logic_vector(2 downto 0);

  -- Contains the output of each multiplexer.
  -- It's an array of M/2+1 std_logic_vectors each of them with N+M bits
  signal out_mux : bus_array(M_PM / 2 downto 0) := (others => (others => '0'));

  -- Contains the partial sum step by step for each set of bits
  -- In's an array of M/2+1 std_logic_vectors each of them with N+M bits
  signal out_adders : bus_array(M_PM / 2 downto 0) := (others => (others => '0'));

  -- Contains the final shift A * 2^M
  signal last_shift : std_logic_vector(N_PM + M_PM - 1 downto 0);

begin
  -- Shifts generator
  --
  SG : SHIFT_GENERATOR
    generic map(N_PM, M_PM)
    port map(operandA, shift_results);

  -- Encoder blocks
  --
  ENC_LOOP : for i in 0 to M_PM / 2 - 1 generate
    ENC0 : if i = 0 generate
      first_encoder_input <= operandB(1 downto 0) & '0';
      BENC0 : BOOTHS_ENC
        port map(first_encoder_input,
                 mux_selections(2 downto 0));
    end generate ENC0;

    ENCN : if i /= 0 generate
      BENC : BOOTHS_ENC
        port map(operandB(i * 2 + 1 downto i * 2 - 1),
                 mux_selections(i * 3 + 2 downto i * 3));
    end generate ENCN;
  end generate ENC_LOOP;

  -- Multiplexers
  --
  MUX_LOOP : for i in 0 to M_PM / 2 - 1 generate
    MUX : MUX_GEN
      generic map(5)
      port map(A(4 downto 1) => shift_results(i * 4 + 3 downto i * 4),
               A(0)          => (others => '0'),
               SEL           => mux_selections(i * 3 + 2 downto i * 3),
               Y             => out_mux(i));

  end generate MUX_LOOP;

  -- Adders
  -- Prepare the signal for the first adder
  -- For sake of code semplicity out_adder(0) is the output of the
  -- first multiplexer
  out_adders(0) <= out_mux(0);
  ADD_LOOP : for i in 0 to M_PM / 2 - 2 generate
    ADDERS : P4_adder
      generic map(N_PM + M_PM, 4)
      port map(out_mux(i + 1),
               out_adders(i),
               '0',
               out_adders(i + 1),
               open);
  end generate ADD_LOOP;

  -- Final check for MSB
  -- Perform the last shift with the positive result at the previous
  -- stage
  last_shift <= shift_results(2 * M_PM - 2)(N_PM + M_PM - 2 downto 0) & '0';

  LAST_MUX : MUX2TO1
    generic map(N_PM + M_PM)
    port map(MUX2TO1_in1 => last_shift,
             MUX2TO1_in0 => (others => '0'),
             MUX2TO1_sel => operandB(M_PM - 1),
             MUX2TO1_y   => out_mux(M_PM / 2));

  LAST_ADDER : P4_adder
    generic map(N_PM + M_PM, 4)
    port map(out_adders(M_PM / 2 - 1),
             out_mux(M_PM / 2),
             '0',
             result,
             open);

-- Result binding
--result <= out_adders(M/2-1);

end architecture;
