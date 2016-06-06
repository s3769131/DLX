LIBRARY_PATH=../work

VHDL_COMPILER=vcom
VHDL_COMPILER_OPT=-work $(LIBRARY_PATH) -2002 -bindAtCompile -check_synthesis
CREATE_LIBRARY=vlib

SOURCES=LU_bit_logic_unit.vhd ALU_logic_unit.vhd
TESTBENCHES=TB_LU_bit_logic_unit.vhd TB_ALU_logic_unit.vhd
PACKAGES=../ALU_packages/ALU_pkg.vhd

all : $(TESTBENCHES) $(SOURCES) $(PACKAGES)
	if [ ! -d $(LIBRARY_PATH) ]; then $(CREATE_LIBRARY) $(LIBRARY_PATH);fi
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(SOURCES)
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(TESTBENCHES)

sources : $(SOURCES) $(PACKAGES)
	if [ ! -d $(LIBRARY_PATH) ]; then $(CREATE_LIBRARY) $(LIBRARY_PATH);fi
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(SOURCES)
