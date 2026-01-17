#set signals [string map {/ .} [find signals -r Module_topTestbench.memwb_toplevel.DUT.*]]
set signals [string map {/ .} [find signals $env(DUT_HIERARCHY).*]]
#set signals [string map {/ .} [find signals -out $env(DUT_HIERARCHY).*]]
set fo [open "faults.txt" "w"]	

foreach signal $signals {
  set examine_out "[examine -radix binary,showbase $signal]"
  regexp {(\d*)} $examine_out sig_length
  set signal_trimmed [string trimleft $signal "."]

  if {$sig_length eq "" || $sig_length eq "1"} {
    puts $fo "$signal_trimmed 0"
    puts $fo "$signal_trimmed 1"
  } else {
    for {set i 0} {$i < $sig_length} {incr i} {
      puts $fo "$signal_trimmed[$i] 0"
      puts $fo "$signal_trimmed[$i] 1"
      
    }
  }

  #puts "$signal [examine -radix binary,showbase $signal]"
  #puts $fo "$signal 0"
  #puts $fo "$signal 1"
}
