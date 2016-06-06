LIBRARY_PATH=../work
SYNTHESIS_ANALYSIS=../analyze.tcl

VHDL_COMPILER=vcom
VHDL_COMPILER_OPT=-work $(LIBRARY_PATH) -2002 -bindAtCompile -check_synthesis
CREATE_LIBRARY=vlib

PACKAGES=ALU_pkg.vhd

all :
	if [ ! -d $(LIBRARY_PATH) ]; then $(CREATE_LIBRARY) $(LIBRARY_PATH);fi
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(PACKAGES)

synthesis : $(SOURCES) $(DEPENDENCIES) $(PACKAGES)
			if [ ! -d $(SYNTHESIS_ANALYSIS) ]; then touch $(SYNTHESIS_ANALYSIS); fi
			echo analyze -format vhdl -library WORK { $(SOURCES) } >> $(SYNTHESIS_ANALYSIS)
