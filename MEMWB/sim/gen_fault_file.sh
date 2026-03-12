# Directory of the source files
SRC_DIR=../src
# Directory of the systemverilog files. Assumes that the classes are not in the same directory as the modules and interfaces.
TB_DIR=../tb
# Directory of the post-synthesis netlists.
SYN_DIR=../syn
# Directory of the gate library
GATE_LIBRARY="/eda/dk/nangate45/verilog/NangateOpenCellLibrary.v"
# Name of the top-level module
export TOPLEVEL="Module_topTestbench"
# DUT hierarchy as laid out in the testbench.
export DUT_HIERARCHY="${TOPLEVEL}.memwb_toplevel.DUT"
# File to which write the stuck-at faults
export FAULT_LIST_FILE="fault_list.txt"

# Execute script in post-synthesis mode?
POSTSYN_SIMULATION="y"
# Name of the macro that controls post-synthesis simulation inside of the testbench.
POSTSYN_FLAG="POSTSYN"

SRC_FILES=$(find $SRC_DIR -maxdepth 1 -name "*.vhd")
SV_FILES="$(find $TB_DIR -maxdepth 1 -name "*.sv")"
SYN_FILES=$(find $SYN_DIR -maxdepth 1 -name "*.v")

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

if [ "$POSTSYN_SIMULATION" = "y" ]; then
  qrun -clean -uvm -autoorder -mixedsvvh +acc +define+$POSTSYN_FLAG -timescale=1ns/1ns $GATE_LIBRARY $SYN_FILES $SV_FILES -do gen_fault_file.do -top $TOPLEVEL
else
  qrun -clean -uvm -autoorder -mixedsvvh +acc $SRC_FILES $SV_FILES -do gen_fault_file.do -do -top $TOPLEVEL
fi
