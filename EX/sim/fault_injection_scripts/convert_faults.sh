#!/bin/sh

### LATER: ALSO GET TB MODULE NAME FROM TOP TESTBENCH FILE (FOR NOW HARDCODED)

# FOR LATER 
# if [ "$#" -ne 2 ]; then
#     echo "Usage: $0 <fault_list_file> <top_testbench_file>"
#     exit 1
# fi

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <fault_list_file>"
    exit 1
fi

fault_list_file=$1
#top_tb_file=$2

# Get SystemVerilog testbench module name
# get_systemverilog_testbench_module() {
#   # Check file exists
#   if [[ ! -f "$top_tb_file" ]]; then
#     echo "[Error] File '$top_tb_file' not found"
#     return 1
#   fi

#   # Extract the first module name
#   local tb_module
#   tb_module="$(awk '/^[[:space:]]*module[[:space:]]+/ {print $2; exit}' "$top_tb_file" | sed 's/[;(].*//')"

#   if [[ -z "$tb_module" ]]; then
#     echo "[Error] No module found in '$top_tb_file'"
#     return 1
#   fi

#   echo "$tb_module"
# }

line_number="$(wc -l < "$fault_list_file")"

# FOR LATER 
# SV_TOPMODULE_NAME="$(get_systemverilog_testbench_module \"$top_tb_file\")"
SV_TOPMODULE_NAME="Module_topTestbench"

# Convert all lines of input file into force simulation commands
for i in $(seq 1 $line_number); do 
  head -$i $fault_list_file | tail -1 | awk '
  /^sa[01]/ { print "force -freeze /'"$SV_TOPMODULE_NAME"'/" $3, $1 == "sa0" ? "0" : "1" }
  '
done

# should build a vhdl unit hierarchy graph tool... or vcom to get hierarchy? 


# For each injected fault:
#  1) FAULT-FREE SIMULATION: 
#    1.1) Insert into testbench an uvm_info command reporting the fault-free value
#    1.2) Perform fault-free simulation in the script
#    1.3) Save with grep from the script the fault-free output value into a var
# 2) FAULTY SIMULATION:
#    2.1) Insert into testbench an uvm_info command reporting the faulty value
#     and perform first fault-free simulation, 
#    2.2) Perform fault-simulation
#    2.3) Save with grep from the script the faulty output value into another var
# 3) COMPARE VALUES AND FAULT COVERAGE
#    3.1) Compare the two output values (fault-free vs faulty)
#    3.2) Calculate FC as 
#
# if $ENV{inject_fault == 1} then
#   force ...
# fi
#
# if $ENV{inject_fault == 1} then 
#   uvm_info("fault free: ") 
# else 
#   uvm_info("faulty: ")
# fi
#

# Golden model file
# net1: 1    
# net2: 0

  force net1 sa0

# Outputs 
# net1: 0
# 

# MODIFY ME
loop
  sed 's/MODIFY ME/force ..../g' input_file > output_file

