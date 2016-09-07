library ieee;
use ieee.std_logic_1164.all;
use work.DLX_pkg.all;

--!   \brief   Generates the propagate and generate signals for each bit.
--!
--!   This entity models the network that generates the propagate and generate signals given
--!   the input bits. The network receives also the carry in bit, and takes it into account when Generates
--!   the first couple of generate and propagate, on position 0.
entity CLA_pg_network is
    generic(
        CLA_PGN_N :	integer	:=	32);   --!   the parallelism of the operands
    port(
        CLA_PGN_op1	: in  std_logic_vector(CLA_PGN_N-1 downto 0);   --!   first operand
        CLA_PGN_op2	: in  std_logic_vector(CLA_PGN_N-1 downto 0);   --!   second operand
        CLA_PGN_cin   : in  std_logic;                              --!   carry in bit
        CLA_PGN_p     : out std_logic_vector(CLA_PGN_N-1 downto 0); --!   propagate signals
        CLA_PGN_g     : out std_logic_vector(CLA_PGN_N-1 downto 0));--!   generate signals
end CLA_pg_network;

architecture dflow of CLA_pg_network is
begin

    CLA_PG_GEN : for i in 0 to CLA_PGN_N-1 generate
        CARRY_IN_GEN : if i = 0 generate
            CLA_PGN_p(i) <= CLA_PGN_op1(i) and CLA_PGN_op2(i);
            CLA_PGN_g(i) <= (CLA_PGN_op1(i) and CLA_PGN_op2(i)) or ((CLA_PGN_op1(i) or CLA_PGN_op2(i)) and CLA_PGN_cin);
        end generate;
        OTHER_GEN : if i /= 0 generate
            CLA_PGN_p(i) <= CLA_PGN_op1(i) or CLA_PGN_op2(i);
            CLA_PGN_g(i) <= CLA_PGN_op1(i) and CLA_PGN_op2(i);
        end generate;
    end generate;
end dflow;

configuration CFG_CLA_PGN_DFLOW of CLA_pg_network is
    for dflow
        for CLA_PG_GEN
            for CARRY_IN_GEN
            end for;
            for OTHER_GEN
            end for;
        end for;
    end for;
end configuration CFG_CLA_PGN_DFLOW;
