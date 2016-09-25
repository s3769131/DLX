source vcom_compile.tcl
vsim tb_dlx(test)
do scripts/add_waves_IF.do
do scripts/add_waves_ID.do
do scripts/add_waves_EX.do
do scripts/add_waves_MEM.do
do scripts/add_waves_WB.do
add wave -position end sim:/tb_dlx/DDRAM/DRAM_ADDRESS
