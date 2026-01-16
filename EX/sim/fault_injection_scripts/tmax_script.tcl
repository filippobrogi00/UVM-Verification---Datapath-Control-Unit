#set Rules Z3-1 Ignore


# POST-SYNTHESIS 
# read_netlist ../libraries/NanGateOpenCellLibrary.v -format verilog -insensitive -library
# read_netlist ../src/DP_EX.v -format verilog -insensitive


# SOURCE CODE 
read_netlist ../000-pkg-globals.vhd -format vhdl -insensitive -library
# read_netlist ../001-pkg-registerfile.vhd -format vhdl -insensitive -library
read_netlist ../a.b.a.a-generic-shifter.vhd -format vhdl -insensitive -library
read_netlist ../a.b.b-DRAM.vhd -format vhdl -insensitive -library
read_netlist ../a.b.c-SignExtender26-32.vhd -format vhdl -insensitive -library
read_netlist ../a.b.c-UnsignExtender26-32.vhd -format vhdl -insensitive -library
read_netlist ../a.b.d-MUX.vhd -format vhdl -insensitive -library
read_netlist ../a.b.e-PC_Add.vhd -format vhdl -insensitive -library
read_netlist ../a.b.f-RegisterFile.vhd -format vhdl -insensitive -library
read_netlist ../a.b.g-FlipFlop.vhd -format vhdl -insensitive -library
read_netlist ../a.b.h-SignExtender16-32.vhd -format vhdl -insensitive -library
read_netlist ../a.b.i-ZeroComparator.vhd -format vhdl -insensitive -library
#read_netlist ../a.b-DataPath.vhd -format vhdl -insensitive -library
read_netlist ../a.b-DP-EX.vhd -format vhdl -insensitive -library



# Build ATPG model for DPEX circuit (DPEX top level module)
run_build_model DP_EX
set_rules Z3 warning
run_drc

# Set model type to "stuck at fault" and add all faults to its DS
set_faults -equiv_code --
set_faults -model stuck
add_faults -all

# Write fault lists (collapsed and not) to files
write_faults fault_list_DPEX_full.txt -all -replace -uncollapsed
write_faults fault_list_DPEX_collapsed.txt -all -replace -collapsed
quit










