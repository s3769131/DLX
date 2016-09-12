analyze -library DLX -format VHDL { \
 ./RTL/DLX/CORE/1_FETCH/NPC_selector.vhd         \
 ./RTL/DLX/MISC/FF/tff.vhd         \
 ./RTL/DLX/MISC/COMPARATOR/eq_comparator.vhd         \
 ./RTL/DLX/PKG/DLX_pkg.vhd         \
 ./RTL/DLX/MISC/FF/d_ff.vhd         \
 ./RTL/DLX/PKG/ALU_pkg.vhd         \
 ./RTL/DLX/MISC/DECODER/decoder.vhd         \
 ./RTL/DLX/MISC/FF/t_ff.vhd         \
 ./RTL/DLX/MISC/MUX/bit_mux_2to1.vhd         \
 ./RTL/DLX/MISC/ADDER/CLA/CLA_general_generate_propagate.vhd         \
 ./RTL/DLX/CORE/3_EXECUTE/ALU/ALU_logic_unit/LU_bit_logic_unit.vhd         \
 ./RTL/DLX/PKG/REGF_pkg.vhd         \
 ./RTL/DLX/MISC/ADDER/full_adder.vhd         \
 ./RTL/DLX/MISC/MUX/bit_mux_4to1.vhd         \
 ./RTL/DLX/MISC/MUX/mux_2to1.vhd         \
 ./RTL/DLX/MISC/REGISTER/REGF_register.vhd         \
 ./RTL/DLX/MISC/FF/dff.vhd         \
 ./RTL/DLX/MISC/MUX/mux_4to1.vhd         \
 ./RTL/DLX/CORE/3_EXECUTE/ALU/ALU_shifter/SHF_mask_selector.vhd         \
 ./RTL/DLX/MISC/ADDER/CLA/CLA_lower_network.vhd         \
 ./RTL/DLX/CORE/3_EXECUTE/ALU/ALU_logic_unit/ALU_logic_unit.vhd         \
 ./RTL/DLX/CORE/3_EXECUTE/ALU/ALU_comparator/COMP_bit_comparator.vhd         \
 ./RTL/DLX/MISC/ADDER/CLA/CLA_upper_network_element.vhd         \
 ./RTL/DLX/CORE/3_EXECUTE/ALU/ALU_control/ALU_control.vhd         \
 ./RTL/DLX/MISC/REGISTER/d_register.vhd         \
 ./RTL/DLX/MISC/MUX/bit_multiplexer.vhd         \
 ./RTL/DLX/MISC/ADDER/CLA/CLA_pg_network.vhd         \
 ./RTL/DLX/MISC/COUNTER/ud_counter.vhd         \
 ./RTL/DLX/MISC/MUX/multiplexer.vhd         \
 ./RTL/DLX/CORE/3_EXECUTE/ALU/ALU_shifter/SHF_finegrain_shift.vhd         \
 ./RTL/DLX/MISC/ADDER/ripple_carry_adder.vhd         \
 ./RTL/DLX/MISC/sign_extention/sign_extention.vhd         \
 ./RTL/DLX/MISC/sign_extention/sign_extention_decode.vhd
 ./RTL/DLX/CU/forwarding_unit.vhd         \
 ./RTL/DLX/CORE/3_EXECUTE/ALU/ALU_shifter/SHF_mask_generator.vhd         \
 ./RTL/DLX/MISC/FF/TB_d_ff.vhd         \
 ./RTL/DLX/MISC/COUNTER/counter.vhd         \
 ./RTL/DLX/CORE/5_WRITEBACK/writeback.vhd         \
 ./RTL/DLX/CORE/2_DECODE/RF/REGF_register_file.vhd         \
 ./RTL/DLX/CORE/3_EXECUTE/ALU/ALU_comparator/ALU_comparator.vhd         \
 ./RTL/DLX/CORE/3_EXECUTE/ALU/ALU_shifter/ALU_shifter.vhd         \
 ./RTL/DLX/MISC/ADDER/CLA/CLA_carry_generator.vhd         \
 ./RTL/DLX/MISC/ADDER/carry_select_adder.vhd         \
 ./RTL/DLX/CORE/4_MEMORY/memory.vhd         \
 ./RTL/DLX/MISC/COUNTER/sat_counter.vhd         \
 ./RTL/DLX/CORE/2_DECODE/decode.vhd         \
 ./RTL/DLX/MISC/ADDER/CLA/CLA_sum_generator.vhd         \
 ./RTL/DLX/MISC/ADDER/CLA/CLA.vhd         \
 ./RTL/DLX/CORE/3_EXECUTE/ALU/ALU.vhd         \
 ./RTL/DLX/CORE/1_FETCH/fetch.vhd         \
 ./RTL/DLX/CORE/3_EXECUTE/execute.vhd         \
 ./RTL/DLX/CORE/core.vhd  }
