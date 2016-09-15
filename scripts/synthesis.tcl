

######################################################################
##
## SPECIFY LIBRARIES
##
######################################################################

# SOURCE SETUP FILE
source "./tech/STcmos65/synopsys_dc.setup"

# SUPPRESS WARNING MESSAGES
suppress_message MWLIBP-319
suppress_message MWLIBP-324
suppress_message TFCHK-012
suppress_message TFCHK-014
suppress_message TFCHK-049
suppress_message TFCHK-072
suppress_message TFCHK-084
suppress_message PSYN-651
suppress_message PSYN-650
suppress_message UID-401
suppress_message LINK-14
suppress_message TIM-134
suppress_message VER-130
######################################################################
##
## READ DESIGN
##
######################################################################

# DEFINE CIRCUITS and WORK DIRS
set blockName "DLX"
set active_design $blockName

# DEFINE WORK DIRS
set dirname "./saved/${blockName}"
if {![file exists $dirname]} {
	file mkdir $dirname
}
set dirname "./saved/${blockName}/synthesis"
if {![file exists $dirname]} {
	file mkdir $dirname
}
set libDir "./saved/${blockName}/synthesis/synlib"
file mkdir $libDir
define_design_lib  -path $libDir $blockName

# ANALYZE HDL SOURCES
source ./RTL/analyze.tcl

# ELABORATE DESIGN
elaborate -lib $blockName CFG_DLX_STR

######################################################################
##
## DEFINE DESIGN ENVIRONMENT
##
######################################################################
set_operating_condition -library "[lindex $target_library 0]:CORE65LPLVT" nom_1.00V_25C
#set_wire_load_model -library "${target_library}:CORE65LPSVT" -name area_12Kto18K [find design *]
set_wire_load_model -name "area_0Kto1K" -library "[lindex $target_library 0]:CORE65LPLVT"
set_load 0.05 [all_outputs]

######################################################################
##
## SET DESIGN CONSTRAINTS
##
######################################################################
set_attribute [find library CORE65LPLVT] default_threshold_voltage_group LVT -type string
set_attribute [find library CORE65LPHVT] default_threshold_voltage_group HVT -type string
set_max_leakage_power 0
source "./RTL/${blockName}.sdc"

######################################################################
##
## COMPILE DESIGN
##
######################################################################
link
ungroup -all -flatten

set_fix_hold $clockName
compile


######################################################################
##
## OPTIMIZE DESIGN
##
######################################################################

compile -incremental_mapping -map_effort high -ungroup_all
optimize_registers -clock $clockName -minimum_period_only

set clockGateMinBitWidth 1 ;# minimum bit-width of the cg bank-register
set clockGateMaxFanout 1024 ;# maximum number of ffd driven by the same cg-element
set_clock_gating_style -minimum_bitwidth $clockGateMinBitWidth -max_fanout $clockGateMaxFanout -positive_edge_logic {integrated} -control_point before

#compile_ultra -incremental -gate_clock

compile_ultra -gate_clock -timing_high_effort_script

######################################################################
##
## SAVE DESIGN
##
######################################################################

write -format vhdl -hierarchy -output "${dirname}/${blockName}_postsyn.vhdl"
write -format verilog -hierarchy -output "${dirname}/${blockName}_postsyn.v"
write_sdc -version 1.3 "${dirname}/${blockName}_postsyn.sdc"

######################################################################
##
## SAVE REPORTS
##
######################################################################

report_timing                      > "${dirname}/${blockName}_report_timing.rpt"
report_power -analysis_effort high > "${dirname}/${blockName}_report_power.rpt"
report_clock_gating                > "${dirname}/${blockName}_report_gating.rpt"
report_threshold_voltage_group     > "${dirname}/${blockName}_report_MTV.rpt"

######################################################################
##
## CLEAN & EXIT
##
######################################################################

#exec rm -rf $libDir
#exit
