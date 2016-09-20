add wave -color green -radix HEX -label EX_IR_IN           sim:/tb_dlx/UUT/core_inst/EX/EXE_IR_IN
add wave -color green -radix HEX -label EX_NPC_IN          sim:/tb_dlx/UUT/core_inst/EX/EXE_NPC_IN
add wave -color green -radix HEX -label EX_RF_IN1          sim:/tb_dlx/UUT/core_inst/EX/EXE_RF_IN1
add wave -color green -radix HEX -label EX_IMM_IN          sim:/tb_dlx/UUT/core_inst/EX/EXE_IMM_IN
add wave -color green -radix HEX -label EX_RF_IN2          sim:/tb_dlx/UUT/core_inst/EX/EXE_RF_IN2
add wave -color green -radix HEX -label EX_FW_ALU_FROM_MEM sim:/tb_dlx/UUT/core_inst/EX/EXE_FW_ALU_FROM_MEM
add wave -color green -radix HEX -label EX_FW_ALU_FROM_WB  sim:/tb_dlx/UUT/core_inst/EX/EXE_FW_ALU_FROM_WB
add wave -color green -radix HEX -label EX_FW_MEM_FROM_WB  sim:/tb_dlx/UUT/core_inst/EX/EXE_FW_MEM_FROM_WB
add wave -color green -radix HEX -label EX_BTB_TARGET      sim:/tb_dlx/UUT/core_inst/EX/EXE_BTB_TARGET
add wave -color green -radix BIN -label EX_PRED_COND       sim:/tb_dlx/UUT/core_inst/EX/EXE_PRED_COND


add wave -color yellow -radix HEX -label EX_IR_OUT        sim:/tb_dlx/UUT/core_inst/EX/EXE_IR_OUT
add wave -color yellow -radix HEX -label EX_NPC_OUT       sim:/tb_dlx/UUT/core_inst/EX/EXE_NPC_OUT
add wave -color yellow -radix HEX -label EX_CALC_COND     sim:/tb_dlx/UUT/core_inst/EX/EXE_CALC_COND
add wave -color yellow -radix HEX -label EX_WRONG_COND    sim:/tb_dlx/UUT/core_inst/EX/EXE_WRONG_COND
add wave -color yellow -radix HEX -label EX_WRONG_TARGET  sim:/tb_dlx/UUT/core_inst/EX/EXE_WRONG_TARGET
add wave -color yellow -radix HEX -label EX_ALU_OUT       sim:/tb_dlx/UUT/core_inst/EX/EXE_ALU_OUT


add wave -color purple -radix BIN -label EX_CU_IS_JUMP   sim:/tb_dlx/UUT/core_inst/EX/EXE_CU_IS_JUMP
add wave -color purple -radix BIN -label EX_CU_IS_BRANCH   sim:/tb_dlx/UUT/core_inst/EX/EXE_CU_IS_BRANCH
add wave -color purple -radix BIN -label EX_CU_BRANCH_TYPE sim:/tb_dlx/UUT/core_inst/EX/EXE_CU_BRANCH_TYPE
add wave -color purple -radix BIN -label EX_CU_ALU_CONTROL sim:/tb_dlx/UUT/core_inst/EX/EXE_CU_ALU_CONTROL
add wave -color purple -radix BIN -label EX_CU_TOP_MUX     sim:/tb_dlx/UUT/core_inst/EX/EXE_CU_TOP_MUX
add wave -color purple -radix BIN -label EX_CU_BOT_MUX     sim:/tb_dlx/UUT/core_inst/EX/EXE_CU_BOT_MUX
add wave -color purple -radix BIN -label EX_CU_FW_TOP_MUX  sim:/tb_dlx/UUT/core_inst/EX/EXE_CU_FW_TOP_MUX
add wave -color purple -radix BIN -label EX_CU_FW_BOT_MUX  sim:/tb_dlx/UUT/core_inst/EX/EXE_CU_FW_BOT_MUX


add wave -color cyan -radix HEX -label int_EX_internal_npc           sim:/tb_dlx/UUT/core_inst/EX/s_internal_npc
add wave -color cyan -radix HEX -label int_EX_top_mux_out            sim:/tb_dlx/UUT/core_inst/EX/s_top_mux_out
add wave -color cyan -radix HEX -label int_EX_bot_mux_out            sim:/tb_dlx/UUT/core_inst/EX/s_bot_mux_out
add wave -color cyan -radix HEX -label int_EX_top_fw_mux_out         sim:/tb_dlx/UUT/core_inst/EX/s_top_fw_mux_out
add wave -color cyan -radix HEX -label int_EX_bot_fw_mux_out         sim:/tb_dlx/UUT/core_inst/EX/s_bot_fw_mux_out
add wave -color cyan -radix HEX -label int_EX_alu_out                sim:/tb_dlx/UUT/core_inst/EX/s_alu_out
add wave -color cyan -radix BIN -label int_EX_zero_comp_out          sim:/tb_dlx/UUT/core_inst/EX/s_zero_comp_out
add wave -color cyan -radix BIN -label int_EX_zero_comp_out_inv      sim:/tb_dlx/UUT/core_inst/EX/s_zero_comp_out_inv
add wave -color cyan -radix BIN -label int_EX_cond_mux_out           sim:/tb_dlx/UUT/core_inst/EX/s_cond_mux_out
add wave -color cyan -radix BIN -label int_EX_wrong_target           sim:/tb_dlx/UUT/core_inst/EX/s_wrong_target
add wave -color cyan -radix BIN -label int_EX_cond_mux_out_is_branch sim:/tb_dlx/UUT/core_inst/EX/s_cond_mux_out_is_branch
