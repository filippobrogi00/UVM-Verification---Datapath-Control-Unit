#!/bin/bash

# $UVM_HOME = /playground_lib/uvm-1.2
# $QUESTA_HOME = /usr/share/questa/questasim/

SV_COMPILE_LIST="Iface_P4Adder.sv Module_P4Adder_Wrapper.sv testbench.sv"

tb_entity="Module_topTestbench"

# Create work library and remove old one
if [ -d "work" ]; then
  rm -rf work
fi
vlib work
vmap work work

########### FUNCTIONS ###########

# name: compile_files
# args:
#   dir: Directory in which to search files to compile
#   filetype: File types to compile (VHDL, Verilog, SystemVerilog)
#   compilation: Source files or testbench files (SOURCE | TESTBENCH)
# desc: Compiles files of specified extension in the directory, using the appropriate compiler
compile_files() {
  local filetype="$1"
  local compilation="$2"
  local ext=""
  local compiler=""
  local language=""

  # Pick compiler + language based on extension
  case "$filetype" in
  VHDL)
    ext="vhd"
    compiler="vcom -reportprogress 300 -2008 -work work -autoorder"
    language="VHDL"
    ;;
  VERILOG)
    ext="v"
    compiler="vlog -work work"
    language="VERILOG"
    ;;
  SYSTEMVERILOG)
    ext="sv"
    compiler="vlog -sv -mixedsvvh -work work +incdir+$UVM_HOME/src -L $QUESTA_HOME/uvm-1.2" # enable mixed-language simulation and code coverage tracking
    language="SYSTEMVERILOG"
    ;;
  *)
    echo "Unsupported file type: .$filetype"
    return 1
    ;;
  esac

  # Only compile if files exist
  if compgen -G *."$ext" >/dev/null; then

    echo "############ $language $compilation FILES COMPILATION: ############ "

    if [[ "$filetype" == "SYSTEMVERILOG" ]]; then
      # ---------- SystemVerilog ----------

      #if [[ "$compilation" == "TESTBENCH" ]]; then

      $compiler $SV_COMPILE_LIST 2>&1 |
        grep -v '^--\sCompiling' | grep -v '^--\sLoading' | sed 's#::>::#Compiled#g' |
        while IFS= read -r line; do
          case "$line" in
          "** Error"*) echo "$line" ;;
          "** Warning"*) echo "$line" ;;
          "** Info"* | "Compiled"*) echo "$line" ;;
          *) echo "$line" ;;
          esac
        done

      if [ "${PIPESTATUS[0]}" -ne 0 ]; then
        exit 1
      fi

      #else
      #  # Skip source SystemVerilog files
      #  return
      #fi

    else
      # ---------- VHDL & Verilog ----------
      local files=*."$ext"
      $compiler $files 2>&1 |
        grep -v '^--\sCompiling' | grep -v '^--\sLoading' | sed 's#::>::#Compiled#g' |
        while IFS= read -r line; do
          case "$line" in
          "** Error"*) echo "$line" ;;
          "** Warning"*) echo "$line" ;;
          "** Info"* | "Compiled"*) echo "$line" ;;
          *) echo "$line" ;;
          esac
        done
      if [ "${PIPESTATUS[0]}" -ne 0 ]; then
        exit 1
      fi
    fi
  fi
}

#############################################################
#### COMPILE SOURCE FILES FOR MIXED-LANGUAGE SIMULATION  ####
#############################################################

# Compile VHDL Source Files if present
compile_files VHDL SOURCE

# Compile Verilog Source Files if present
compile_files VERILOG SOURCE

###############################################
#### COMPILE SYSTEMVERILOG TESTBENCH FILES ####
###############################################
compile_files SYSTEMVERILOG TESTBENCH

#####################################################################
#### SIMULATE USING CONSTRAINT RANDOMIZATION AND REPORT COVERAGE ####
#####################################################################
# Always simulate using Questasim (vsim is Questa's internal simulator tool)
echo "############ SIMULATION: ############ "

# vsim parameters
SIM_RUNTIME="30ns"
SIM_SEQITEMS="+NUM_SEQITEMS=20"

# Simulate
vsim -c -coverage "work.$tb_entity" -t 10ps -voptargs=+acc -sv_seed random \
  -do "run -all; quit" 2>&1 |
  grep -v '^#\s\+Time:' |
  while IFS= read -r line; do
    case "$line" in
    "# ** Error"* | "# ** Fatal"*) echo "$line" ;;
    "# ** Warning"*) echo "$line" ;;
    "# ** Note"*) echo "$line" ;;
    *) echo "$line" ;;
    esac
  done # Colorize output lines

###############################################
#### 	    FUNCTIONAL AND CODE COVERAGE 	   ####
###############################################
echo "############ COVERAGE: ############ "
cat func_cover.txt
