#Exercise 1
puts "**** Exercise 1 ****"
set operand1 1
set operand2 2
set result [expr $operand1 + $operand2]
puts "$operand1 + $operand2 = $result"

#Exercise 2
puts "**** Exercise 2 ****"
set a 1
set b 2
set c 1

set delta [expr $b*$b - 4 * $a * $c]

if {$delta >= 0} {
  set x1 [expr (-$b - sqrt($delta))/(2 * $a)]
  set x2 [expr (-$b + sqrt($delta))/(2 * $a)]
  puts "x1 = $x1"
  puts "x2 = $x2"
} else {
  puts "No real solutions"
}

#Exercise 3
puts "**** Exercise 3 ****"

set var_list [list]
for {set i 0} { $i < 11} {incr i} {
  lappend var_list $i
}
set i 0
foreach var $var_list {
  puts "Element $i: $var"
  incr i
}
lappend var_list [expr [lindex $var_list 5] + [lindex $var_list 10]]
puts "Added element: [lindex $var_list 11]"

#Exercise 4
puts "**** Exercise 4 ****"

set four_seasons [list "Winter" "Spring" "Summer" "Autumn"]

foreach season $four_seasons {
 puts $season
}

set index [lsearch $four_seasons "Spring"]
puts "Spring is in position $index"


