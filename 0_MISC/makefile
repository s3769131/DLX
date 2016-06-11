LIBRARY_PATH=../work
SYNTHESIS_ANALYSIS=../scripts/analyze.tcl
DIRECTORY_PATH=./O_MISC/

VHDL_COMPILER=vcom
VHDL_COMPILER_OPT=-work $(LIBRARY_PATH) -2002 -bindAtCompile -check_synthesis
CREATE_LIBRARY=vlib

SOURCES=bit_mux_2to1.vhd bit_mux_2to1.vhd mux_2to1.vhd mux_2to1.vhd register.vhd

all : $(TESTBENCHES) $(SOURCES) $(PACKAGES)
	if [ ! -d $(LIBRARY_PATH) ]; then $(CREATE_LIBRARY) $(LIBRARY_PATH);fi
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(SOURCES)

simulation : $(SOURCES) $(PACKAGES)
	if [ ! -d $(LIBRARY_PATH) ]; then $(CREATE_LIBRARY) $(LIBRARY_PATH);fi
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(SOURCES)

synthesis : $(SOURCES) $(DEPENDENCIES) $(PACKAGES)
		@if [ ! -d $(SYNTHESIS_ANALYSIS) ]; then touch $(SYNTHESIS_ANALYSIS); fi
		@echo analyze -format vhdl -library WORK { $(addprefix $(DIRECTORY_PATH), $(SOURCES)) } >> $(SYNTHESIS_ANALYSIS)
