set SRC_DIR [getenv SRC_DIR]
set SYN_DIR [getenv SYN_DIR]


#####################################
# READING SOURCE FILES
#####################################
analyze -f vhdl -lib WORK $SRC_DIR/000-pkg-globals.vhd
analyze -f vhdl -lib WORK $SRC_DIR/001-pkg-registerfile.vhd

analyze -f vhdl -lib WORK $SRC_DIR/a.b.a.a-generic_shifter.vhd

analyze -f vhdl -lib WORK $SRC_DIR/a.b.i-ZeroComparator.vhd
analyze -f vhdl -lib WORK $SRC_DIR/a.b.h-SignExtender16-32.vhd
analyze -f vhdl -lib WORK $SRC_DIR/a.b.g-FlipFlop.vhd
analyze -f vhdl -lib WORK $SRC_DIR/a.b.f-RegisterFile.vhd
analyze -f vhdl -lib WORK $SRC_DIR/a.b.e-PC_Add.vhd
analyze -f vhdl -lib WORK $SRC_DIR/a.b.d-MUX.vhd
analyze -f vhdl -lib WORK $SRC_DIR/a.b.c-UnsignExtender26-32.vhd
analyze -f vhdl -lib WORK $SRC_DIR/a.b.c-SignExtender26-32.vhd
analyze -f vhdl -lib WORK $SRC_DIR/a.b.b-DRAM.vhd
analyze -f vhdl -lib WORK $SRC_DIR/a.b.a-ALU.vhd

analyze -f vhdl -lib WORK $SRC_DIR/a.b-DP-CU.vhd

# To preserve rtl names in the netlist to ease the procedure for power consumption estimation
set power_preserve_rtl_hier_names true

elaborate DP_IFID -lib WORK


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

#####################################
# START THE SYNTHESIS
#####################################
compile

#####################################
# REPORTING
#####################################
report_timing > ${SYN_DIR}/timing_rpt.txt
report_area > ${SYN_DIR}/area_rpt.txt

# To ease the reading of power consumption?
ungroup -all -flatten

# Imposing verilog rules for the names of the internal signals
change_names -hierarchy -rules verilog

# Saving the Standard Delay Format file
write_sdf ${SYN_DIR}/DP_IFID.sdf

# Saving the Synopsys Design Constraints
write_sdc ${SYN_DIR}/DP_IFID.sdc

# Saving the verilog netlist
write -f verilog -hierarchy -output ${SYN_DIR}/DP_IFID.v

quit
