###################################################################

# Created by write_sdc on Wed Sep 21 15:12:31 2016

###################################################################
set sdc_version 1.3

set_operating_conditions nom_1.00V_25C -library CORE65LPLVT
set_wire_load_model -name area_0Kto1K -library CORE65LPLVT
set_max_area 0
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports DLX_CLK]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports DLX_RST]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports ROM_DATA_READY]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[31]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[30]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[29]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[28]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[27]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[26]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[25]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[24]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[23]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[22]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[21]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[20]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[19]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[18]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[17]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[16]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[15]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[14]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[13]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[12]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[11]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[10]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[9]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[8]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[7]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[6]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[5]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[4]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[3]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[2]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[1]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {ROM_INTERFACE[0]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports DRAM_DATA_READY]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[31]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[30]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[29]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[28]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[27]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[26]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[25]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[24]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[23]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[22]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[21]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[20]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[19]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[18]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[17]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[16]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[15]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[14]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[13]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[12]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[11]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[10]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[9]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[8]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[7]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[6]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[5]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[4]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[3]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[2]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[1]}]
set_driving_cell -lib_cell HS65_LH_BFX7 -library                               \
CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT [get_ports {DRAM_INTERFACE[0]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[31]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[30]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[29]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[28]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[27]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[26]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[25]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[24]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[23]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[22]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[21]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[20]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[19]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[18]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[17]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[16]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[15]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[14]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[13]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[12]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[11]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[10]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[9]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[8]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[7]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[6]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[5]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[4]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[3]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[2]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[1]}]
set_load -pin_load 0.05 [get_ports {ROM_ADDRESS[0]}]
set_load -pin_load 0.05 [get_ports ROM_EN]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[31]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[30]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[29]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[28]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[27]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[26]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[25]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[24]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[23]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[22]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[21]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[20]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[19]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[18]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[17]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[16]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[15]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[14]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[13]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[12]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[11]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[10]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[9]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[8]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[7]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[6]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[5]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[4]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[3]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[2]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[1]}]
set_load -pin_load 0.05 [get_ports {DRAM_ADDRESS[0]}]
set_load -pin_load 0.05 [get_ports DRAM_EN]
set_load -pin_load 0.05 [get_ports DRAM_READNOTWRITE]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[31]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[30]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[29]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[28]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[27]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[26]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[25]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[24]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[23]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[22]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[21]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[20]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[19]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[18]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[17]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[16]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[15]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[14]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[13]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[12]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[11]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[10]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[9]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[8]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[7]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[6]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[5]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[4]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[3]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[2]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[1]}]
set_load -pin_load 0.05 [get_ports {DRAM_INTERFACE[0]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[31]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[30]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[29]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[28]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[27]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[26]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[25]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[24]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[23]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[22]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[21]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[20]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[19]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[18]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[17]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[16]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[15]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[14]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[13]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[12]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[11]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[10]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[9]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[8]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[7]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[6]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[5]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[4]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[3]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[2]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[1]}]
set_max_transition 0.01 [get_ports {ROM_ADDRESS[0]}]
set_max_transition 0.01 [get_ports ROM_EN]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[31]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[30]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[29]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[28]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[27]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[26]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[25]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[24]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[23]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[22]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[21]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[20]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[19]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[18]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[17]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[16]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[15]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[14]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[13]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[12]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[11]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[10]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[9]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[8]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[7]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[6]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[5]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[4]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[3]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[2]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[1]}]
set_max_transition 0.01 [get_ports {DRAM_ADDRESS[0]}]
set_max_transition 0.01 [get_ports DRAM_EN]
set_max_transition 0.01 [get_ports DRAM_READNOTWRITE]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[31]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[30]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[29]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[28]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[27]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[26]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[25]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[24]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[23]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[22]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[21]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[20]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[19]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[18]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[17]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[16]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[15]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[14]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[13]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[12]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[11]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[10]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[9]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[8]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[7]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[6]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[5]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[4]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[3]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[2]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[1]}]
set_max_transition 0.01 [get_ports {DRAM_INTERFACE[0]}]
create_clock [get_ports DLX_CLK]  -period 1  -waveform {0 0.5}
set_clock_uncertainty 0.01  [get_clocks DLX_CLK]
set_max_delay 1  -from [list [get_ports DLX_CLK] [get_ports DLX_RST] [get_ports                \
ROM_DATA_READY] [get_ports {ROM_INTERFACE[31]}] [get_ports                     \
{ROM_INTERFACE[30]}] [get_ports {ROM_INTERFACE[29]}] [get_ports                \
{ROM_INTERFACE[28]}] [get_ports {ROM_INTERFACE[27]}] [get_ports                \
{ROM_INTERFACE[26]}] [get_ports {ROM_INTERFACE[25]}] [get_ports                \
{ROM_INTERFACE[24]}] [get_ports {ROM_INTERFACE[23]}] [get_ports                \
{ROM_INTERFACE[22]}] [get_ports {ROM_INTERFACE[21]}] [get_ports                \
{ROM_INTERFACE[20]}] [get_ports {ROM_INTERFACE[19]}] [get_ports                \
{ROM_INTERFACE[18]}] [get_ports {ROM_INTERFACE[17]}] [get_ports                \
{ROM_INTERFACE[16]}] [get_ports {ROM_INTERFACE[15]}] [get_ports                \
{ROM_INTERFACE[14]}] [get_ports {ROM_INTERFACE[13]}] [get_ports                \
{ROM_INTERFACE[12]}] [get_ports {ROM_INTERFACE[11]}] [get_ports                \
{ROM_INTERFACE[10]}] [get_ports {ROM_INTERFACE[9]}] [get_ports                 \
{ROM_INTERFACE[8]}] [get_ports {ROM_INTERFACE[7]}] [get_ports                  \
{ROM_INTERFACE[6]}] [get_ports {ROM_INTERFACE[5]}] [get_ports                  \
{ROM_INTERFACE[4]}] [get_ports {ROM_INTERFACE[3]}] [get_ports                  \
{ROM_INTERFACE[2]}] [get_ports {ROM_INTERFACE[1]}] [get_ports                  \
{ROM_INTERFACE[0]}] [get_ports DRAM_DATA_READY] [get_ports                     \
{DRAM_INTERFACE[31]}] [get_ports {DRAM_INTERFACE[30]}] [get_ports              \
{DRAM_INTERFACE[29]}] [get_ports {DRAM_INTERFACE[28]}] [get_ports              \
{DRAM_INTERFACE[27]}] [get_ports {DRAM_INTERFACE[26]}] [get_ports              \
{DRAM_INTERFACE[25]}] [get_ports {DRAM_INTERFACE[24]}] [get_ports              \
{DRAM_INTERFACE[23]}] [get_ports {DRAM_INTERFACE[22]}] [get_ports              \
{DRAM_INTERFACE[21]}] [get_ports {DRAM_INTERFACE[20]}] [get_ports              \
{DRAM_INTERFACE[19]}] [get_ports {DRAM_INTERFACE[18]}] [get_ports              \
{DRAM_INTERFACE[17]}] [get_ports {DRAM_INTERFACE[16]}] [get_ports              \
{DRAM_INTERFACE[15]}] [get_ports {DRAM_INTERFACE[14]}] [get_ports              \
{DRAM_INTERFACE[13]}] [get_ports {DRAM_INTERFACE[12]}] [get_ports              \
{DRAM_INTERFACE[11]}] [get_ports {DRAM_INTERFACE[10]}] [get_ports              \
{DRAM_INTERFACE[9]}] [get_ports {DRAM_INTERFACE[8]}] [get_ports                \
{DRAM_INTERFACE[7]}] [get_ports {DRAM_INTERFACE[6]}] [get_ports                \
{DRAM_INTERFACE[5]}] [get_ports {DRAM_INTERFACE[4]}] [get_ports                \
{DRAM_INTERFACE[3]}] [get_ports {DRAM_INTERFACE[2]}] [get_ports                \
{DRAM_INTERFACE[1]}] [get_ports {DRAM_INTERFACE[0]}]]  -to [list [get_ports {ROM_ADDRESS[31]}] [get_ports {ROM_ADDRESS[30]}]         \
[get_ports {ROM_ADDRESS[29]}] [get_ports {ROM_ADDRESS[28]}] [get_ports         \
{ROM_ADDRESS[27]}] [get_ports {ROM_ADDRESS[26]}] [get_ports {ROM_ADDRESS[25]}] \
[get_ports {ROM_ADDRESS[24]}] [get_ports {ROM_ADDRESS[23]}] [get_ports         \
{ROM_ADDRESS[22]}] [get_ports {ROM_ADDRESS[21]}] [get_ports {ROM_ADDRESS[20]}] \
[get_ports {ROM_ADDRESS[19]}] [get_ports {ROM_ADDRESS[18]}] [get_ports         \
{ROM_ADDRESS[17]}] [get_ports {ROM_ADDRESS[16]}] [get_ports {ROM_ADDRESS[15]}] \
[get_ports {ROM_ADDRESS[14]}] [get_ports {ROM_ADDRESS[13]}] [get_ports         \
{ROM_ADDRESS[12]}] [get_ports {ROM_ADDRESS[11]}] [get_ports {ROM_ADDRESS[10]}] \
[get_ports {ROM_ADDRESS[9]}] [get_ports {ROM_ADDRESS[8]}] [get_ports           \
{ROM_ADDRESS[7]}] [get_ports {ROM_ADDRESS[6]}] [get_ports {ROM_ADDRESS[5]}]    \
[get_ports {ROM_ADDRESS[4]}] [get_ports {ROM_ADDRESS[3]}] [get_ports           \
{ROM_ADDRESS[2]}] [get_ports {ROM_ADDRESS[1]}] [get_ports {ROM_ADDRESS[0]}]    \
[get_ports ROM_EN] [get_ports {DRAM_ADDRESS[31]}] [get_ports                   \
{DRAM_ADDRESS[30]}] [get_ports {DRAM_ADDRESS[29]}] [get_ports                  \
{DRAM_ADDRESS[28]}] [get_ports {DRAM_ADDRESS[27]}] [get_ports                  \
{DRAM_ADDRESS[26]}] [get_ports {DRAM_ADDRESS[25]}] [get_ports                  \
{DRAM_ADDRESS[24]}] [get_ports {DRAM_ADDRESS[23]}] [get_ports                  \
{DRAM_ADDRESS[22]}] [get_ports {DRAM_ADDRESS[21]}] [get_ports                  \
{DRAM_ADDRESS[20]}] [get_ports {DRAM_ADDRESS[19]}] [get_ports                  \
{DRAM_ADDRESS[18]}] [get_ports {DRAM_ADDRESS[17]}] [get_ports                  \
{DRAM_ADDRESS[16]}] [get_ports {DRAM_ADDRESS[15]}] [get_ports                  \
{DRAM_ADDRESS[14]}] [get_ports {DRAM_ADDRESS[13]}] [get_ports                  \
{DRAM_ADDRESS[12]}] [get_ports {DRAM_ADDRESS[11]}] [get_ports                  \
{DRAM_ADDRESS[10]}] [get_ports {DRAM_ADDRESS[9]}] [get_ports                   \
{DRAM_ADDRESS[8]}] [get_ports {DRAM_ADDRESS[7]}] [get_ports {DRAM_ADDRESS[6]}] \
[get_ports {DRAM_ADDRESS[5]}] [get_ports {DRAM_ADDRESS[4]}] [get_ports         \
{DRAM_ADDRESS[3]}] [get_ports {DRAM_ADDRESS[2]}] [get_ports {DRAM_ADDRESS[1]}] \
[get_ports {DRAM_ADDRESS[0]}] [get_ports DRAM_EN] [get_ports                   \
DRAM_READNOTWRITE] [get_ports {DRAM_INTERFACE[31]}] [get_ports                 \
{DRAM_INTERFACE[30]}] [get_ports {DRAM_INTERFACE[29]}] [get_ports              \
{DRAM_INTERFACE[28]}] [get_ports {DRAM_INTERFACE[27]}] [get_ports              \
{DRAM_INTERFACE[26]}] [get_ports {DRAM_INTERFACE[25]}] [get_ports              \
{DRAM_INTERFACE[24]}] [get_ports {DRAM_INTERFACE[23]}] [get_ports              \
{DRAM_INTERFACE[22]}] [get_ports {DRAM_INTERFACE[21]}] [get_ports              \
{DRAM_INTERFACE[20]}] [get_ports {DRAM_INTERFACE[19]}] [get_ports              \
{DRAM_INTERFACE[18]}] [get_ports {DRAM_INTERFACE[17]}] [get_ports              \
{DRAM_INTERFACE[16]}] [get_ports {DRAM_INTERFACE[15]}] [get_ports              \
{DRAM_INTERFACE[14]}] [get_ports {DRAM_INTERFACE[13]}] [get_ports              \
{DRAM_INTERFACE[12]}] [get_ports {DRAM_INTERFACE[11]}] [get_ports              \
{DRAM_INTERFACE[10]}] [get_ports {DRAM_INTERFACE[9]}] [get_ports               \
{DRAM_INTERFACE[8]}] [get_ports {DRAM_INTERFACE[7]}] [get_ports                \
{DRAM_INTERFACE[6]}] [get_ports {DRAM_INTERFACE[5]}] [get_ports                \
{DRAM_INTERFACE[4]}] [get_ports {DRAM_INTERFACE[3]}] [get_ports                \
{DRAM_INTERFACE[2]}] [get_ports {DRAM_INTERFACE[1]}] [get_ports                \
{DRAM_INTERFACE[0]}]]
set_input_delay -clock DLX_CLK  0  [get_ports DLX_CLK]
set_input_delay -clock DLX_CLK  0.01  [get_ports DLX_RST]
set_input_delay -clock DLX_CLK  0.01  [get_ports ROM_DATA_READY]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[31]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[30]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[29]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[28]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[27]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[26]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[25]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[24]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[23]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[22]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[21]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[20]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[19]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[18]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[17]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[16]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[15]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[14]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[13]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[12]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[11]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[10]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[9]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[8]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[7]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[6]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[5]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[4]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[3]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[2]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[1]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {ROM_INTERFACE[0]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports DRAM_DATA_READY]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[31]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[30]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[29]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[28]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[27]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[26]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[25]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[24]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[23]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[22]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[21]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[20]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[19]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[18]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[17]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[16]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[15]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[14]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[13]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[12]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[11]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[10]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[9]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[8]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[7]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[6]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[5]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[4]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[3]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[2]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[1]}]
set_input_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[0]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[31]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[30]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[29]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[28]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[27]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[26]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[25]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[24]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[23]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[22]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[21]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[20]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[19]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[18]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[17]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[16]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[15]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[14]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[13]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[12]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[11]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[10]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[9]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[8]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[7]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[6]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[5]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[4]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[3]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[2]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[1]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_INTERFACE[0]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[31]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[30]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[29]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[28]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[27]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[26]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[25]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[24]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[23]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[22]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[21]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[20]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[19]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[18]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[17]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[16]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[15]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[14]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[13]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[12]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[11]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[10]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[9]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[8]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[7]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[6]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[5]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[4]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[3]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[2]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[1]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {ROM_ADDRESS[0]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports ROM_EN]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[31]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[30]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[29]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[28]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[27]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[26]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[25]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[24]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[23]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[22]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[21]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[20]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[19]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[18]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[17]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[16]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[15]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[14]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[13]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[12]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[11]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[10]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[9]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[8]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[7]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[6]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[5]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[4]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[3]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[2]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[1]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports {DRAM_ADDRESS[0]}]
set_output_delay -clock DLX_CLK  0.01  [get_ports DRAM_EN]
set_output_delay -clock DLX_CLK  0.01  [get_ports DRAM_READNOTWRITE]
