#!/bin/bash

echo
echo "COMPILE DECODE"
echo "----------------------------------"
echo
if [[ ! -d $1 ]]; then
    echo "directory $1 does not exist... exit..."
    exit
fi

COMPILE_COMMAND="vcom -2002 -check_synthesis -bindAtCompile -work $1"

$COMPILE_COMMAND ../../PKG/DLX_pkg.vhd | grep "vcom.*\.vhd\|Errors"

$COMPILE_COMMAND sign_extention/sign_extention.vhd | grep "vcom.*\.vhd\|Errors"

$COMPILE_COMMAND ../../MISC/FF/d_ff.vhd ../../MISC/MUX/bit_mux_2to1.vhd ../../MISC/MUX/mux_2to1.vhd     \
                    ../../MISC/DECODER/decoder.vhd ../../MISC/REGISTER/d_register.vhd                   \
                    ../../MISC/COMPARATOR/eq_comparator.vhd ../../MISC/MUX/multiplexer.vhd              \
                    RF/REGF_register_file.vhd | grep "vcom.*\.vhd\|Errors"

$COMPILE_COMMAND decode.vhd | grep "vcom.*\.vhd\|Errors"

#$COMPILE_COMMAND TB_decode.vhd #| grep "vcom.*\.vhd\|Errors"
