###################################################################

# Created by write_sdc on Wed Sep 21 02:44:27 2016

###################################################################
set sdc_version 1.3

create_clock [get_ports DLX_CLK]  -period 1.58  -waveform {0 0.5}
set_max_delay 0  -from [list [get_ports DLX_CLK] [get_ports DLX_RST] [get_ports                \
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
