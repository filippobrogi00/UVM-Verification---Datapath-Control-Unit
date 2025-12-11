#!/bin/bash

SRC_DIR=../src
TB_DIR=../tb
GM_DIR=../tb/golden
COV_EXCLUDE="work.rf_pkg work.Module_topTestbench work.Module_topTestbench_sv_unit"
SEED=0
DUT_HIERARCHY="/Module_topTestbench/memwb_toplevel/DUT"
FAULT_LIST="stuckat_fault_list.txt"
FAULT_DURATION="100"

SRC_FILES=$(find $SRC_DIR -maxdepth 1 -name "*.vhd")
SV_COMPILE_LIST="$(find $TB_DIR -maxdepth 1 -name "*.sv") $(find $GM_DIR -maxdepth 1 -name "*.sv")"
TOPLEVEL="Module_topTestbench"
#GM_FILES=$(find $GM_DIR -maxdepth 1 -name "*.cpp")
#GM_FILES=$(find $GM_DIR -maxdepth 1 -name "*.c")
COV_EXCLUDE_COMMAND=$(printf "coverage exclude -du %s; " $COV_EXCLUDE)
FORCE_COMMAND=""

for i in {1..2}
do
    FAULT=$(awk -F' ' "NR==$i {print \$1}" $FAULT_LIST | sed "s/sa//")
    SIGNAL=$(awk -F' ' "NR==$i {print \$3}" $FAULT_LIST)
    FORCE_COMMAND="$FORCE_COMMAND; force -freeze $DUT_HIERARCHY/$SIGNAL $FAULT $(($FAULT_DURATION*($i - 1))) -cancel $(($FAULT_DURATION*$i))"
done
echo $FORCE_COMMAND

###################
###### USAGE ######
###################
if [[ $# -gt 1 ]]; then
  echo "Usage: $0 [number of sequence items per sequence to generate (optional)]"
  return
fi

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

qrun -clean -uvm -autoorder -mixedsvvh -coverage +cover=sbce  $SRC_FILES $SV_COMPILE_LIST $GM_FILES -do "$FORCE_COMMAND; $COV_EXCLUDE_COMMAND; run -all" -top $TOPLEVEL
vcover report -details -html cov_$SEED.ucdb
