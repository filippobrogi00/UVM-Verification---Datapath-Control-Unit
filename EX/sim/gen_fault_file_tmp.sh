SRC_DIR=../src
TB_DIR=../tb
SYN_DIR=../syn
GATE_LIBRARY="/eda/dk/nangate45/verilog/NangateOpenCellLibrary.v"
export TOPLEVEL="Module_topTestbench"
export DUT_HIERARCHY="${TOPLEVEL}.exe_toplevel.EXE_DUT_inst"
POSTSYN_SIMULATION="n"

SRC_FILES=$(find $SRC_DIR -maxdepth 1 -name "*.vhd")
# SV_FILES="$(find $TB_DIR -maxdepth 1 -name "*.sv")"
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
  qrun -clean -uvm -autoorder -mixedsvvh +acc +define+POSTSYN_SIMULATION +define+FAULT_INJECTION_CAMPAIGN -timescale=1ns/1ns $GATE_LIBRARY $SYN_FILES ../tb/pkg* ../tb/Module* ../tb/Iface* -do gen_fault_file.do -top $TOPLEVEL
else
  qrun -clean -uvm -autoorder -mixedsvvh $SRC_FILES ../tb/pkg* ../tb/Module* ../tb/Iface* -do "run 50 ns" -top $TOPLEVEL
fi
