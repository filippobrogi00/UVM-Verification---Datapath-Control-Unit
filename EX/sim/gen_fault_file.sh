SRC_DIR=../src
TB_DIR=../tb
TOPLEVEL="Module_topTestbench"

SRC_FILES=$(find $SRC_DIR -maxdepth 1 -name "*.vhd")
SV_FILES="$(find $TB_DIR -maxdepth 1 -name "*.sv")"

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

qrun -clean -uvm -autoorder -mixedsvvh $SRC_FILES $SV_FILES -do gen_fault_file_2.do -top $TOPLEVEL
