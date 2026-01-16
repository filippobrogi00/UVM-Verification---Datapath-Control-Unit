set signals [find signals -r /Module_topTestbench/memwb_toplevel/DUT/*]
set fo [open "faults.txt" "w"]	

foreach signal $signals {
  set examine_out "[examine -radix binary,showbase $signal]"
  regexp {(\d*)} $examine_out sig_length
  if {$sig_length eq ""} {
    puts $fo "force -freeze $signal 0"
    puts $fo "force -freeze $signal 1"
    puts "$signal 1"
  } else {
    for {set i 0} {$i < $sig_length} {incr i} {
      puts $fo "force -freeze $signal[$i] 0"
      puts $fo "force -freeze $signal[$i] 1"
      
    }
  }

  #puts "$signal [examine -radix binary,showbase $signal]"
  #puts $fo "force -freeze $signal 0"
  #puts $fo "force -freeze $signal 1"
}

quit
