run -init

#set signals [string map {/ .} [find signals -r "Module_topTestbench.exe_toplevel.DP_EXE_inst.*"]]
set signals [string map {/ .} [find signals $env(DUT_HIERARCHY).*]]
set fo [open $env(FAULT_LIST_FILE) "w"]	

puts $env(DUT_HIERARCHY)
puts $env(FAULT_LIST_FILE)

foreach signal $signals {
  set examine_out "[examine -radix binary,showbase $signal]"
  regexp {(\d*)} $examine_out sig_length
  set signal_trimmed [string trimleft $signal "."]

  set clk_regexp [regexp {.*[Cc][Ll]?[Oo]?[Cc]?[Kk]} $signal]
  set rst_regexp [regexp {.*[Rr][Ee]?[Ss][Ee]?[Tt][_]?[Nn]?} $signal]

  # Exclude clock and reset signals from fault list (infinite simulation)
  if { $clk_regexp || $rst_regexp } {
    continue
  }

  # Else print fault to the file (both SA0 and SA1)
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
exit
