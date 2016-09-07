#!/bin/bash

echo
echo "COMPILE FETCH"
echo "----------------------------------"
echo
if [[ ! -d $1 ]]; then
    echo "directory $1 does not exist... exit..."
    exit
fi

COMPILE_COMMAND="vcom -2002 -check_synthesis -bindAtCompile -work $1"

$COMPILE_COMMAND ../../PKG/DLX_pkg.vhd | grep "vcom.*\.vhd\|Errors"

$COMPILE_COMMAND NPC_selector.vhd | grep "vcom.*\.vhd\|Errors"

$COMPILE_COMMAND ../../MISC/MUX/bit_mux_2to1.vhd ../../MISC/FF/d_ff.vhd                                     \
                ../../MISC/REGISTER/d_register.vhd | grep "vcom.*\.vhd\|Errors"

$COMPILE_COMMAND ../../MISC/MUX/mux_2to1.vhd ../../MISC/MUX/multiplexer.vhd | grep "vcom.*\.vhd\|Errors"

$COMPILE_COMMAND ../../MISC/ADDER/full_adder.vhd ../../MISC/ADDER/ripple_carry_adder.vhd                    \
                ../../MISC/ADDER/carry_select_adder.vhd                                                     \
                ../../MISC/ADDER/CLA/CLA_general_generate_propagate.vhd                                     \
                ../../MISC/ADDER/CLA/CLA_pg_network.vhd ../../MISC/ADDER/CLA/CLA_upper_network_element.vhd  \
                ../../MISC/ADDER/CLA/CLA_lower_network.vhd ../../MISC/ADDER/CLA/CLA_carry_generator.vhd     \
                ../../MISC/ADDER/CLA/CLA_sum_generator.vhd                                                  \
                ../../MISC/ADDER/CLA/CLA.vhd | grep "vcom.*\.vhd\|Errors"

$COMPILE_COMMAND fetch.vhd | grep "vcom.*\.vhd\|Errors"

$COMPILE_COMMAND TB_fetch.vhd | grep "vcom.*\.vhd\|Errors"
