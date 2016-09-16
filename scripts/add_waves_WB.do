add wave -color purple -radix BIN -label WB_CU_MUX_CONTROL  sim:/tb_dlx/UUT/core_inst/WB/WB_CU_MUX_CONTROL

add wave -color green -radix HEX -label  WB_IR_IN           sim:/tb_dlx/UUT/core_inst/WB/WB_IR_IN
add wave -color green -radix HEX -label  WB_NPC_IN          sim:/tb_dlx/UUT/core_inst/WB/WB_NPC_IN
add wave -color green -radix HEX -label  WB_DATA_FROM_MEM   sim:/tb_dlx/UUT/core_inst/WB/WB_DATA_FROM_MEM
add wave -color green -radix HEX -label  WB_DATA_FROM_ALU   sim:/tb_dlx/UUT/core_inst/WB/WB_DATA_FROM_ALU

add wave -color yellow -radix HEX -label WB_IR_OUT      sim:/tb_dlx/UUT/core_inst/WB/WB_IR_OUT
add wave -color yellow -radix HEX -label WB_NPC_OUT     sim:/tb_dlx/UUT/core_inst/WB/WB_NPC_OUT
add wave -color yellow -radix HEX -label WB_DATA_TO_R   sim:/tb_dlx/UUT/core_inst/WB/WB_DATA_TO_RF
