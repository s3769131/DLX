LIBRARY_PATH=../work

VHDL_COMPILER=vcom
VHDL_COMPILER_OPT=-work $(LIBRARY_PATH) -2002 -bindAtCompile -check_synthesis
CREATE_LIBRARY=vlib

SOURCES=SHIFTER_mask_generator.vhd SHIFTER_mask_selector.vhd SHIFTER_finegrain_shift.vhd ALU_shifter.vhd
TESTBENCHES=TB_SHIFTER_mask_generator.vhd TB_ALU_shifter.vhd
PACKAGES=../ALU_packages/ALU_pkg.vhd

all : $(TESTBENCHES) $(SOURCES) $(PACKAGES)
	if [ ! -d $(LIBRARY_PATH) ]; then $(CREATE_LIBRARY) $(LIBRARY_PATH);fi
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(SOURCES)
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(TESTBENCHES)

sources : $(SOURCES) $(PACKAGES)
	if [ ! -d $(LIBRARY_PATH) ]; then $(CREATE_LIBRARY) $(LIBRARY_PATH);fi
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(SOURCES)
