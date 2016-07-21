LIBRARY_PATH=../work
SYNTHESIS_ANALYSIS=../analyze.tcl

VHDL_COMPILER=vcom
VHDL_COMPILER_OPT=-work $(LIBRARY_PATH) -2002 -bindAtCompile -check_synthesis
CREATE_LIBRARY=vlib

SOURCES=bit_mux_2to1.vhd mux_2to1.vhd bit_mux_4to1.vhd mux_4to1.vhd full_adder.vhd \
        ripple_carry_adder.vhd carry_select_adder.vhd
TESTBENCHES=TB_ripple_carry_adder.vhd TB_carry_select_adder.vhd

all : $(TESTBENCHES) $(SOURCES)
	if [ ! -d $(LIBRARY_PATH) ]; then $(CREATE_LIBRARY) $(LIBRARY_PATH);fi
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(SOURCES)
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(TESTBENCHES)

sources : $(SOURCES)
	if [ ! -d $(LIBRARY_PATH) ]; then $(CREATE_LIBRARY) $(LIBRARY_PATH);fi
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(SOURCES)

synthesis : $(SOURCES) $(DEPENDENCIES) $(PACKAGES)
			if [ ! -d $(SYNTHESIS_ANALYSIS) ]; then touch $(SYNTHESIS_ANALYSIS); fi
			echo analyze -format vhdl -library WORK { $(SOURCES) } >> $(SYNTHESIS_ANALYSIS)
