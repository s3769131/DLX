VHDL_COMPILER=vcom

LIBRARY_PATH=./work
SYNTHESIS_ANALYSIS=./scripts/analyze.tcl

VHDL_COMPILER=vcom
VHDL_COMPILER_OPT=-work $(LIBRARY_PATH) -2002 -bindAtCompile -check_synthesis

DIRECTORY_MISC=./0_MISC
DIRECTORY_FETCH=./1_FETCH

all:
	$(MAKE) -C $(DIRECTORY_MISC) all
	$(MAKE) -C $(DIRECTORY_FETCH) all

simulation:
	$(MAKE) -C $(DIRECTORY_MISC) simulation
	$(MAKE) -C $(DIRECTORY_FETCH) simulation

synthesis:
	$(MAKE) -C $(DIRECTORY_MISC) synthesis
	$(MAKE) -C $(DIRECTORY_FETCH) synthesis

clean:
	echo "CLEAN"
