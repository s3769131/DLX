add wave -color purple -label IFID_EN   sim:/tb_dlx/UUT/core_inst/CORE_IFID_EN
add wave -color purple -label IFID_CLR  sim:/tb_dlx/UUT/core_inst/CORE_IFID_CLR

add wave -color orange -label IFID_PC          sim:/tb_dlx/UUT/core_inst/IFID_PC/REG_data_out
add wave -color orange -label IFID_NPC         sim:/tb_dlx/UUT/core_inst/IFID_NPC/REG_data_out
add wave -color purple -label IFID_IR          sim:/tb_dlx/UUT/core_inst/IFID_IR/REG_data_out
add wave -color purple -label IFID_BTB_TARGET  sim:/tb_dlx/UUT/core_inst/IFID_BTB_TARGET/REG_data_out
add wave -color green  -label IFID_BTB_PREDICT sim:/tb_dlx/UUT/core_inst/IFID_BTB_PREDICTION/DFF_q
