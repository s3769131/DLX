add wave -color purple -radix BIN -label ID_rf_read_en_rs   sim:/tb_dlx/UUT/core_inst/ID/DECODE_rf_read_en_rs
add wave -color purple -radix BIN -label ID_rf_read_en_rt   sim:/tb_dlx/UUT/core_inst/ID/DECODE_rf_read_en_rt
add wave -color purple -radix BIN -label ID_rf_write_en     sim:/tb_dlx/UUT/core_inst/ID/DECODE_rf_write_en

add wave -color green  -radix BIN -label ID_sigext_op       sim:/tb_dlx/UUT/core_inst/ID/DECODE_sigext_op
add wave -color green  -radix HEX -label ID_ir              sim:/tb_dlx/UUT/core_inst/ID/DECODE_ir
add wave -color green  -radix BIN -label ID_destination_sel sim:/tb_dlx/UUT/core_inst/ID/DECODE_destination_sel
add wave -color green  -radix HEX -label ID_rf_data_write   sim:/tb_dlx/UUT/core_inst/ID/DECODE_rf_data_write
add wave -color green  -radix BIN -label ID_rf_addr_write   sim:/tb_dlx/UUT/core_inst/ID/DECODE_rf_addr_write
add wave -color green  -radix HEX -label ID_pc_in           sim:/tb_dlx/UUT/core_inst/ID/DECODE_pc_in
add wave -color green  -radix HEX -label ID_npc_in          sim:/tb_dlx/UUT/core_inst/ID/DECODE_npc_in

add wave -color yellow -radix HEX -label ID_sigext_out      sim:/tb_dlx/UUT/core_inst/ID/DECODE_sigext_out
add wave -color yellow -radix BIN -label ID_rf_addr_dest    sim:/tb_dlx/UUT/core_inst/ID/DECODE_rf_addr_dest
add wave -color yellow -radix HEX -label ID_rf_data_read1   sim:/tb_dlx/UUT/core_inst/ID/DECODE_rf_data_read1
add wave -color yellow -radix HEX -label ID_rf_data_read2   sim:/tb_dlx/UUT/core_inst/ID/DECODE_rf_data_read2
add wave -color yellow -radix HEX -label ID_pc_out          sim:/tb_dlx/UUT/core_inst/ID/DECODE_pc_out
add wave -color yellow -radix HEX -label ID_npc_out         sim:/tb_dlx/UUT/core_inst/ID/DECODE_npc_out

add wave -color cyan   -radix BIN -label int_ID_addr_rs     sim:/tb_dlx/UUT/core_inst/ID/s_rf_addr_rs
add wave -color cyan   -radix BIN -label int_ID_addr_rt     sim:/tb_dlx/UUT/core_inst/ID/s_rf_addr_rt
add wave -color cyan   -radix BIN -label int_ID_addr_rd     sim:/tb_dlx/UUT/core_inst/ID/s_rf_addr_rd
