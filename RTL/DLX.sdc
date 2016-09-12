#set period 1.5
#set clockName “CORE_CLK”
#create_clock $clockName -name $clockName -period $period
#set_max_delay -from [all_inputs] -to [all_outputs] $period
#set_max_area 0



set sdc_version 1.3

set clockName "CORE_CLK"
set rstName "CORE_RST"
set clockPeriod "1.5"

;# Set-up Clock
create_clock $clockName -name $clockName -period $clockPeriod
set_clock_uncertainty [format %.4f [expr $clockPeriod*0.05]]  $clockName
set_dont_touch_network $clockName
set_ideal_network $clockName
set_dont_touch_network $rstName
set_ideal_network $rstName

;# fix hold constraints
set_min_delay 0.1 -through [all_registers] -from [all_inputs] -to [all_outputs]

;# Set-up IOs
set STM_minStrength_buf_LVT "HS65_LL_BFX7"
set STM_minStrength_buf_SVT "HS65_LS_BFX7"
set STM_minStrength_buf_HVT "HS65_LH_BFX7"

set_driving_cell -library "CORE65LPLVT_nom_1.00V_25C.db:CORE65LPLVT" -lib_cell $STM_minStrength_buf_LVT [all_inputs]
set_driving_cell -library "CORE65LPSVT_nom_1.00V_25C.db:CORE65LPSVT" -lib_cell $STM_minStrength_buf_SVT [all_inputs]
set_driving_cell -library "CORE65LPHVT_nom_1.00V_25C.db:CORE65LPHVT" -lib_cell $STM_minStrength_buf_HVT [all_inputs]

set_input_delay  [format %.4f [expr $clockPeriod*0.10]] -clock $clockName [all_inputs]
set_output_delay [format %.4f [expr $clockPeriod*0.10]] -clock $clockName [all_outputs]
set_input_delay 0 -clock clk clk

set max_transition_time 0.1
set_max_transition $max_transition_time [all_outputs]

;# Set area constraint
set_max_area 0
