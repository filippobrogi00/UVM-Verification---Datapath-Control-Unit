#!/bin/bash

# Directory of the source files
SRC_DIR=../src
# Directory of the systemverilog files. Assumes that the classes are not in the same directory as the modules and interfaces.
TB_DIR=../tb
# Directory of the post-synthesis netlists.
SYN_DIR=../syn
GM_DIR=../tb/golden
# Directory of the gate library
export GATE_LIBRARY="/eda/dk/nangate45/verilog/NangateOpenCellLibrary.v"
# Name of the top-level module
export TOPLEVEL="Module_topTestbench"
# DUT hierarchy as laid out in the testbench.
export DUT_HIERARCHY="/$TOPLEVEL/memwb_toplevel/DUT"

# Files to exclude from coverage collection
COV_EXCLUDE="work.rf_pkg work.Module_topTestbench work.Module_topTestbench_sv_unit"
# RNG seed
SEED=0

# Simulate the post_synthesis netlist? 
export POSTSYN_SIMULATION="y"

# Run fault injection campaign?
export FAULT_INJECT_CAMPAIGN="n"
# File to which write the cathegorized log files
export FAULT_INJECT_LOG_FILE="../sim/fault_log.txt"
# File from which to read the stuck_at faults
export FAULT_INJECT_FAULT_FILE="../sim/fault_list.txt"

SYN_FILES=$(find $SYN_DIR -maxdepth 1 -name "*.v")
echo $SYN_FILES
SRC_FILES=$(find $SRC_DIR -maxdepth 1 -name "*.vhd")
SV_COMPILE_LIST="$(find $TB_DIR -maxdepth 1 -name "*.sv") $(find $GM_DIR -maxdepth 1 -name "*.sv")"
TOPLEVEL="Module_topTestbench"
#GM_FILES=$(find $GM_DIR -maxdepth 1 -name "*.cpp")
#GM_FILES=$(find $GM_DIR -maxdepth 1 -name "*.c")
#COV_EXCLUDE_COMMAND=$(printf "coverage exclude -du %s; " $COV_EXCLUDE)

#############################################################
###########     SCRIPT INCLUDES AND DIRECTORY     ###########
#############################################################
INCLUDE_DIR=""
if [ -f /.dockerenv ]; then
  # Script running inside Docker
  INCLUDE_DIR="/home/dockeruser/.include"
else
  # Script running on server
  # INCLUDE_DIR="$HOME/.config/.zshinclude"
  # Seteldo
  source "/eda/scripts/init_amsv"
  # Setinnovus
  source "/eda/scripts/init_cadence_2020-21"
  # Setmentor
  source "/eda/scripts/init_questa_core_prime"
  # Setsynopsys
  source "/eda/scripts/init_design_vision"
fi

# Utilities for output coloring and systemverilog functions
source ./sim_colors.sh
source ./systemverilog_utils.sh # get_systemverilog_testbench_module()

# Remove previous coverage directory
rm -rf cov_$SEED.ucdb covhtmlreport

if [ "$POSTSYN_SIMULATION" = "y" ]; then
  qrun -clean -uvm -autoorder -mixedsvvh -coverage +acc +cover=sbcexf +define+POSTSYN -timescale=1ns/1ns $GATE_LIBRARY  $SYN_FILES $SV_COMPILE_LIST $FAULT_INJECT -do "$COV_EXCLUDE_COMMAND; run -all" -top $TOPLEVEL
else
  qrun -clean -uvm -autoorder -mixedsvvh -coverage +acc +cover=sbce  $SRC_FILES $SV_COMPILE_LIST $FAULT_INJECT -do "$COV_EXCLUDE_COMMAND; run -all" -top $TOPLEVEL
fi
vcover report -details -html cov_$SEED.ucdb

if [ "$FAULT_INJECT_CAMPAIGN" = "y" ]; then
  detected=$(grep -E "\sDETECTED" $FAULT_INJECT_LOG_FILE | wc -l)
  total_faults=$(cat $FAULT_INJECT_LOG_FILE | wc -l)
  total_cov=$(( $detected * 100 / $total_faults ))
  echo "Total fault coverage: $total_cov"
fi

