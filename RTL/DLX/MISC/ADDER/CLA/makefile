LIBRARY_PATH=../work
SYNTHESIS_ANALYSIS=../analyze.tcl

VHDL_COMPILER=vcom
VHDL_COMPILER_OPT=-work $(LIBRARY_PATH) -2002 -bindAtCompile -check_synthesis
CREATE_LIBRARY=vlib

SOURCES=CLA_pg_network.vhd CLA_general_generate_propagate.vhd CLA_upper_network_element.vhd CLA_lower_network.vhd \
        CLA_carry_generator.vhd CLA_sum_generator.vhd ALU_carry_lookahead_adder.vhd
TESTBENCHES=TB_CLA_pg_network.vhd TB_CLA_upper_network_element.vhd TB_CLA_lower_network.vhd \
        TB_CLA_carry_generator.vhd TB_CLA_sum_generator.vhd TB_ALU_carry_lookahead_adder.vhd
DEP_DIR=../ALU_misc
DEPENDENCIES=$(DEP_DIR)/bit_mux_2to1.vhd $(DEP_DIR)/mux_2to1.vhd $(DEP_DIR)/full_adder.vhd \
             $(DEP_DIR)/ripple_carry_adder.vhd $(DEP_DIR)/carry_select_adder.vhd
PACKAGES=../ALU_packages/DLX_pkg.vhd

all : $(TESTBENCHES) $(SOURCES) $(DEPENDENCIES) $(PACKAGES)
	if [ ! -d $(LIBRARY_PATH) ]; then $(CREATE_LIBRARY) $(LIBRARY_PATH);fi
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(SOURCES)
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(TESTBENCHES)

sources : $(SOURCES) $(DEPENDENCIES) $(PACKAGES)
	if [ ! -d $(LIBRARY_PATH) ]; then $(CREATE_LIBRARY) $(LIBRARY_PATH);fi
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(SOURCES)

synthesis : $(SOURCES) $(DEPENDENCIES) $(PACKAGES)
			if [ ! -d $(SYNTHESIS_ANALYSIS) ]; then touch $(SYNTHESIS_ANALYSIS); fi
			echo analyze -format vhdl -library WORK { $(SOURCES) } >> $(SYNTHESIS_ANALYSIS)
