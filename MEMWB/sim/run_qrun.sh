#!/bin/bash

SYN_DIR=../syn
SRC_DIR=../src
TB_DIR=../tb
GM_DIR=../tb/golden

COV_EXCLUDE="work.rf_pkg work.Module_topTestbench work.Module_topTestbench_sv_unit"
SEED=0
export DUT_HIERARCHY="/Module_topTestbench/memwb_toplevel/DUT"

export GATE_LIBRARY="/eda/dk/nangate45/verilog/NangateOpenCellLibrary.v"
export POSTSYN_SIMULATION="y"

export FAULT_INJECT_CAMPAIGN="y"
export FAULT_INJECT_LOG_FILE="../sim/fault_log.txt"
export FAULT_INJECT_FAULT_FILE="../sim/fault_list.txt"
#if [ "$POSTSYN_SIMULATION" = "y" ]; then
#  FAULT_INJECT="-do gen_fault_file.do"
#fi

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

#qrun -clean -coverage -uvm -autoorder -mixedsvvh $PACKAGES $SRC_FILES $SV_COMPILE_LIST $C_FILES -sysc $GM_FILES -top $TOPLEVEL
rm -rf cov_$SEED.ucdb covhtmlreport

#./gen_fault_file.sh

if [ "$POSTSYN_SIMULATION" = "y" ]; then
  qrun -clean -uvm -autoorder -mixedsvvh -coverage +acc +cover=sbcexf +define+POSTSYN -timescale=1ns/1ns $GATE_LIBRARY  $SYN_FILES $SV_COMPILE_LIST $FAULT_INJECT -do "$COV_EXCLUDE_COMMAND; run -all" -top $TOPLEVEL
else
  qrun -clean -uvm -autoorder -mixedsvvh -coverage +acc +cover=sbce  $SRC_FILES $SV_COMPILE_LIST $FAULT_INJECT -do "$COV_EXCLUDE_COMMAND; run -all" -top $TOPLEVEL
fi
vcover report -details -html cov_$SEED.ucdb
