#####################################
# READING SOURCE FILES
#####################################
analyze -f vhdl -lib WORK ../src/000-pkg-globals.vhd
analyze -f vhdl -lib WORK ../src/001-pkg-registerfile.vhd

analyze -f vhdl -lib WORK ../src/a.b.a.a-generic_shifter.vhd

analyze -f vhdl -lib WORK ../src/a.b.i-ZeroComparator.vhd
analyze -f vhdl -lib WORK ../src/a.b.h-SignExtender16-32.vhd
analyze -f vhdl -lib WORK ../src/a.b.g-FlipFlop.vhd
analyze -f vhdl -lib WORK ../src/a.b.f-RegisterFile.vhd
analyze -f vhdl -lib WORK ../src/a.b.e-PC_Add.vhd
analyze -f vhdl -lib WORK ../src/a.b.d-MUX.vhd
analyze -f vhdl -lib WORK ../src/a.b.c-UnsignExtender26-32.vhd
analyze -f vhdl -lib WORK ../src/a.b.c-SignExtender26-32.vhd
analyze -f vhdl -lib WORK ../src/a.b.b-DRAM.vhd
analyze -f vhdl -lib WORK ../src/a.b.a-ALU.vhd

analyze -f vhdl -lib WORK ../src/a.b-DP-EX.vhd

# To preserve rtl names in the netlist to ease the procedure for power consumption estimation
set power_preserve_rtl_hier_names true

elaborate DP_EX -lib WORK


#####################################
# APPLYING CONSTRAINTS
#####################################
# Setting clk_period
#try {
#    set clk_period [getenv CLK_PERIOD]
#} on error {msg} {
#    puts "ERROR: missing CLK_PERIOD environment variable"
#    puts "Message: $msg"
#    exit 1
#}
#create_clock -name my_clk -period $clk_period CLK
create_clock -name my_clk -period 10 CLK

# Since the clock is a “special” signal in the design, we set the dont touch property
set_dont_touch_network my_clk

# Since the clock could be affected by jitter we set the uncertainty
#set_clock_uncertainty 0.07 [get_clocks my_clk]

# Each input signal could arrive with a certain delay with respect to the clock.
# Assuming that all input signals have the same maximum input delay, we can set their input delay
#set_input_delay 0.5 -max -clock my_clk [remove_from_collection [all_inputs] CLK]

# In general the input delay must be lower than the clock period to avoid slow input paths.
# Similarly, we can set the maximum delay of output ports
#set_output_delay 0.5 -max -clock my_clk [all_outputs]

# We can set the load of each output in our design. For the sake of simplicity we assume that
# the load of each output is the input capacitance of a buffer. Among the buffers available
# in this technology we choose the BUF X4, which input port is named A
#set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
#set_load $OLOAD [all_outputs]

#set_dont_touch [current_design]

#####################################
# START THE SYNTHESIS
#####################################
set_app_var verilogout_no_tri true
compile

#####################################
# REPORTING
#####################################
report_timing > ./timing_rpt.txt
report_area > ./area_rpt.txt

# To ease the reading of power consumption?
ungroup -all -flatten

# Imposing verilog rules for the names of the internal signals
change_names -hierarchy -rules verilog

# Saving the Standard Delay Format file
write_sdf ./DP_EX.sdf

# Saving the Synopsys Design Constraints
write_sdc ./DP_EX.sdc

# Saving the verilog netlist
write -f verilog -hierarchy -output ./DP_EX.v

quit
