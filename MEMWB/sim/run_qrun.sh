#!/bin/bash

SRC_DIR=../src
TB_DIR=../tb
GM_DIR=../tb/golden

SRC_FILES=$(find $SRC_DIR -maxdepth 1 -name "*.vhd")
SV_COMPILE_LIST="$TB_DIR/pkg_constants.sv $TB_DIR/Iface_MEMWB.sv $TB_DIR/Module_MEMWB_Wrapper.sv $TB_DIR/Module_topTestbench.sv"
GM_FILES=$(find $TB_DIR -maxdepth 1 -name "*.cpp")

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

qrun -clean -coverage -uvm -autoorder -mixedsvvh $SRC_FILES $SV_COMPILE_LIST -sysc $GM_FILES

