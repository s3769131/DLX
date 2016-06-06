VHDL_COMPILER=vcom

LIBRARY_PATH=./work

VHDL_COMPILER=vcom
VHDL_COMPILER_OPT=-work $(LIBRARY_PATH) -2002 -bindAtCompile -check_synthesis

DIRECTORY_PACKAGES=./ALU_packages
DIRECTORY_ADDER=./ALU_carry_lookahead_adder
DIRECTORY_SHIFTER=./ALU_shifter
DIRECTORY_COMPARATOR=./ALU_comparator
DIRECTORY_LOGIC=./ALU_logic_unit
DIRECTORY_MISC=./ALU_misc
DIRECTORY_CONTROL=./ALU_control

SOURCES=./ALU.vhd
TESTBENCHES=./TB_ALU.vhd

all:
	$(MAKE) -C $(DIRECTORY_PACKAGES) all
	$(MAKE) -C $(DIRECTORY_MISC) all
	$(MAKE) -C $(DIRECTORY_SHIFTER) all
	$(MAKE) -C $(DIRECTORY_ADDER) all
	$(MAKE) -C $(DIRECTORY_LOGIC) all
	$(MAKE) -C $(DIRECTORY_COMPARATOR) all
	$(MAKE) -C $(DIRECTORY_CONTROL) all
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(SOURCES)
	$(VHDL_COMPILER) $(VHDL_COMPILER_OPT) $(TESTBENCHES)

packages:
	$(MAKE) -C $(DIRECTORY_PACKAGES) all

misc:
	$(MAKE) -C $(DIRECTORY_MISC) all

shifter:
	$(MAKE) -C $(DIRECTORY_SHIFTER) all

adder:
	$(MAKE) -C $(DIRECTORY_ADDER) all

logic:
	$(MAKE) -C $(DIRECTORY_LOGIC) all

comparator:
	$(MAKE) -C $(DIRECTORY_COMPARATOR) all

control:
	$(MAKE) -C $(DIRECTORY_CONTROL) all

clean:
	if [ -e transcript ]; then rm transcript;fi
	if [ -e vsim.wlf ]; then rm vsim.wlf;fi
	rm -rf $(LIBRARY_PATH)
