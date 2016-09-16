add wave -color orange -label CLK                             sim:/tb_dlx/UUT/core_inst/IF_stage/FETCH_clk
add wave -color orange -label RST                             sim:/tb_dlx/UUT/core_inst/IF_stage/FETCH_rst
add wave -color purple -label IF_pc_enable                    sim:/tb_dlx/UUT/core_inst/IF_stage/FETCH_pc_enable
add wave -color purple -label IF_pc_clear                     sim:/tb_dlx/UUT/core_inst/IF_stage/FETCH_pc_clear
add wave -color green  -label IF_btb_prediction_in            sim:/tb_dlx/UUT/core_inst/IF_stage/FETCH_btb_prediction_in
add wave -color green  -label IF_btb_target_in     -radix HEX sim:/tb_dlx/UUT/core_inst/IF_stage/FETCH_btb_target_in
add wave -color green  -label IF_alu_out           -radix HEX sim:/tb_dlx/UUT/core_inst/IF_stage/FETCH_alu_out
add wave -color green  -label IF_ir_in             -radix HEX sim:/tb_dlx/UUT/core_inst/IF_stage/FETCH_ir_in
add wave -color green  -label IF_ir_out            -radix HEX sim:/tb_dlx/UUT/core_inst/IF_stage/FETCH_ir_out
add wave -color green  -label IF_pc                -radix HEX sim:/tb_dlx/UUT/core_inst/IF_stage/FETCH_pc
add wave -color green  -label IF_npc               -radix HEX sim:/tb_dlx/UUT/core_inst/IF_stage/FETCH_npc
add wave -color green  -label IF_btb_prediction_out           sim:/tb_dlx/UUT/core_inst/IF_stage/FETCH_btb_prediction_out
add wave -color green  -label IF_btb_target_out    -radix HEX sim:/tb_dlx/UUT/core_inst/IF_stage/FETCH_btb_target_out
