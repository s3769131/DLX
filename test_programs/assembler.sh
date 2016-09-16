#!/bin/bash

if [ ! -r $1 ]
then
	echo "Usage: $0 <dlx_assembly_file>.asm"
	exit 1
fi

asmfile=`echo $1 | sed s/[.].*//g`
mkdir $asmfile

perl ./assembler.bin/dlxasm.pl -o $asmfile/$asmfile.bin -list $asmfile/$asmfile.list $1
rm $asmfile/$asmfile.bin.hdr
cat $asmfile/$asmfile.bin | hexdump -v -e '/1 "%02X" /1 "%02X" /1 "%02X" /1 "%02X\n"' > $asmfile/$asmfile\_dump.txt
mv $1 $asmfile/
