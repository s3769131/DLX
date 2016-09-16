add wave -color purple -radix BIN -label MEM_CU_READNOTWRITE       sim:/tb_dlx/UUT/core_inst/MEM/MEM_CU_READNOTWRITE
add wave -color purple -radix BIN -label MEM_CU_SIGNED_LOAD        sim:/tb_dlx/UUT/core_inst/MEM/MEM_CU_SIGNED_LOAD
add wave -color purple -radix BIN -label MEM_CU_LOAD_TYPE          sim:/tb_dlx/UUT/core_inst/MEM/MEM_CU_LOAD_TYPE

add wave -color green -radix HEX -label MEM_IR_IN                 sim:/tb_dlx/UUT/core_inst/MEM/MEM_IR_IN
add wave -color green -radix HEX -label MEM_NPC_IN                sim:/tb_dlx/UUT/core_inst/MEM/MEM_NPC_IN
add wave -color green -radix HEX -label MEM_ADDRESS_IN            sim:/tb_dlx/UUT/core_inst/MEM/MEM_ADDRESS_IN
add wave -color green -radix HEX -label MEM_DATA_IN               sim:/tb_dlx/UUT/core_inst/MEM/MEM_DATA_IN

add wave -color yellow -radix HEX -label MEM_IR_OUT                sim:/tb_dlx/UUT/core_inst/MEM/MEM_IR_OUT
add wave -color yellow -radix HEX -label MEM_NPC_OUT               sim:/tb_dlx/UUT/core_inst/MEM/MEM_NPC_OUT
add wave -color yellow -radix HEX -label MEM_ADDRESS_OUT           sim:/tb_dlx/UUT/core_inst/MEM/MEM_ADDRESS_OUT
add wave -color yellow -radix HEX -label MEM_DATA_OUT              sim:/tb_dlx/UUT/core_inst/MEM/MEM_DATA_OUT

add wave -color orange -radix HEX -label MEM_INTERFACE             sim:/tb_dlx/UUT/core_inst/MEM/MEM_INTERFACE

add wave -color cyan -radix HEX -label int_MEM_internal_address        sim:/tb_dlx/UUT/core_inst/MEM/s_internal_address                     
add wave -color cyan -radix HEX -label int_MEM_internal_data_from_mem  sim:/tb_dlx/UUT/core_inst/MEM/s_internal_data_from_mem
add wave -color cyan -radix HEX -label int_MEM_internal_data_word      sim:/tb_dlx/UUT/core_inst/MEM/s_internal_data_word
add wave -color cyan -radix HEX -label int_MEM_internal_data_halfword  sim:/tb_dlx/UUT/core_inst/MEM/s_internal_data_halfword
add wave -color cyan -radix HEX -label int_MEM_internal_data_byte      sim:/tb_dlx/UUT/core_inst/MEM/s_internal_data_byte
