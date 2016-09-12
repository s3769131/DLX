#Simple instructions
set a 4
set b 3
puts "SUM : [expr $a + $b]"

#List
set var_list [list a b c d ]
puts $var_list
puts "Element nr. 1 = [lindex $var_list 1]"
lappend var_list e f
puts $var_list
set index [lsearch $var_list "c"]
puts $index

#If-Then-Else
if {[lindex $var_list 3 ] == "d"}
{
  puts "ok"
}
else
{
  puts [lindex $var_index 3]
}

#Loop statements
foreach var $var_list
{
  puts $var
}

