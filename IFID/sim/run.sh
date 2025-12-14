#!/bin/bash
###################
###### USAGE ######
###################
if [[ $# -gt 2 ]]; then
  echo "Usage: $0 [rtl/synth] [number of sequence items per sequence to generate (optional)]"
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

# Script variables - Working directories
BASENAME_CWD="$(basename $(pwd))"
ROOT_DIR=""
SIM_DIR="sim"
SRC_DIR="src"
TB_DIR="tb"
COV_DIR="$SIM_DIR/coverage"
COV_HTML_DIR="$SIM_DIR/covhtmlreport"

if [[ $BASENAME_CWD == "$SIM_DIR" || $BASENAME_CWD == "$SRC_DIR" || $BASENAME_CWD == "$TB_DIR" ]]; then
  SIM_DIR="../$SIM_DIR"
  SRC_DIR="../$SRC_DIR"
  TB_DIR="../$TB_DIR"
  COV_DIR="$SIM_DIR/coverage"
  COV_HTML_DIR="$SIM_DIR/covhtmlreport"
  ROOT_DIR="../"
fi

# Create dirs
mkdir -p $SIM_DIR
mkdir -p $SRC_DIR
mkdir -p $TB_DIR
mkdir -p $COV_DIR

# Script variables - Compilation
SV_COMPILE_LIST="$TB_DIR/Module_topTestbench.sv $TB_DIR/Iface_IFID.sv $TB_DIR/Module_IFID_Wrapper.sv"

########### FUNCTIONS ###########

# name: compile_files
# args:
#   dir: Directory in which to search files to compile
#   filetype: File types to compile (VHDL, Verilog, SystemVerilog)
#   compilation: Source files or testbench files (SOURCE | TESTBENCH)
# desc: Compiles files of specified extension in the directory, using the appropriate compiler
compile_files() {
  local dir="$1"
  local filetype="$2"
  local compilation="$3"
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
    compiler="vlog -sv -mixedsvvh -work work +cover=bcesft" # enable mixed-language
    language="SYSTEMVERILOG"
    ;;
  *)
    echo "Unsupported file type: .$filetype"
    return 1
    ;;
  esac

  # Only compile if files exist
  if compgen -G "$dir"/*."$ext" >/dev/null; then
    print_green "############ $language $compilation FILES COMPILATION: ############ "

    if [[ "$filetype" == "SYSTEMVERILOG" ]]; then
      # ---------- SystemVerilog dependency ordering ----------

      if [[ "$compilation" == "TESTBENCH" ]]; then

        colorize $compiler $SV_COMPILE_LIST

      else
        # Skip
        return
      fi

    else
      # ---------- VHDL & Verilog ----------
      local files="$dir"/*."$ext"
      colorize $compiler $files
    fi
  fi
}

# name: cov_print
# args:
#   file : file from which to get total coverage
# desc: Gets total coverage from the specified coverage report and prints it colored on the screen
cov_print() {

  if [ $# -ne 1 ]; then
    echo "Usage: $0 <coverage_report_file>"
  fi

  # Get coverage type from filename
  filename="$1"
  cov_type="${filename#*cov_}" # strip "cov_" from the front
  cov_type="${cov_type%.txt}"  # stirp .txt from the end
  cov_type="${cov_type^}"      # capitalize first char

  # File not empty, coverage statistics defined and calculated by vopt
  if [ ! -s "$filename" ]; then
    # File empty, output and exit right away
    print_blue "[NOT DEFINED] \t $cov_type"
    return
  fi

  # Get line
  total_cov_line=""
  if [[ $cov_type == "Functional" ]]; then
    total_cov_line="$(grep "^# Functional Coverage:" $1)"
    echo $total_cov_line
  else
    total_cov_line="$(grep "^Total Coverage" $1)"
  fi

  # Get total coverage
  total_cov_str="${total_cov_line#*:}"

  # Get percent digits from the line and convert them into a number
  cov=${total_cov_str%.*}

  # Output string
  out_str=""
  if [[ "$cov_type" == "Functional" ]]; then
    out_str="$cov_type Coverage:\t $total_cov_str"
  else
    out_str="Total $cov_type Coverage:\t $total_cov_str"
  fi

  # Classify coverage statistics
  if [ $cov -lt 80 ]; then
    print_red "[INSUFFICIENT] \t $out_str"
  elif [ $cov -ge 80 ] && [ $cov -lt 90 ]; then
    print_yellow "[BARE MINIMUM] \t $out_str"
  elif [ $cov -ge 90 ] && [ $cov -lt 95 ]; then
    print_green "[GOOD] \t\t $out_str"
  elif [ $cov -ge 95 ] && [ $cov -lt 98 ]; then
    print_green "[VERY GOOD] \t $out_str"
  elif [ $cov -ge 98 ]; then
    print_green "[EXCELLENT] \t $out_str"
  fi

}

#############################################################
#### COMPILE SOURCE FILES FOR MIXED-LANGUAGE SIMULATION  ####
#############################################################
# Delete work directories in all subdirs before recompiling
[ -d "$SRC_DIR/work" ] && rm -rf "$SRC_DIR/work"
[ -d "$TB_DIR/work" ] && rm -rf "$TB_DIR/work"
[ -d "$SIM_DIR/work" ] && rm -rf "$SIM_DIR/work"

# Create new work directory
vlib work
vmap work work

# Compile VHDL Source Files if present
compile_files $SRC_DIR VHDL SOURCE
# Compile Verilog Source Files if present
compile_files $SRC_DIR VERILOG SOURCE

## SYNTHESIS:
# vlog -timescale=1ns/1ps -work work /eda/dk/nangate45/verilog/NangateOpenCellLibrary.v
# vlog -timescale=1ns/1ps -work work ../syn/IFID_EX.v

###############################################
#### COMPILE SYSTEMVERILOG TESTBENCH FILES ####
###############################################
compile_files $TB_DIR SYSTEMVERILOG TESTBENCH

############################################################
#### DEFINE COVERAGE TYPES AND ENABLE COVERAGE TRACKING ####
############################################################
# NOTE: Branch, Condition, Expression, Statement, Fsm, Toggle ('t' 2-stage, 'x' 4-state)

# Commands to report coverage of every type in a corresponding file
REPORT_ALL="coverage report -all -details -output $COV_DIR/cov_all.txt"
REPORT_BRANCH="coverage report -code b -details -output $COV_DIR/cov_branch.txt"
REPORT_COND="coverage report -code c -details -output $COV_DIR/cov_cond.txt"
REPORT_EXPR="coverage report -code e -details -output $COV_DIR/cov_expr.txt"
REPORT_STMT="coverage report -code s -details -output $COV_DIR/cov_stmt.txt"
REPORT_FSM="coverage report -code f -details -output $COV_DIR/cov_fsm.txt"
REPORT_TOG="coverage report -code t -details -output $COV_DIR/cov_toggle.txt"
# vsim command to simulate and report coverage to .txt files
VSIM_REPORT_TEXT_COVERAGE="$REPORT_ALL; $REPORT_BRANCH; $REPORT_COND; $REPORT_EXPR; $REPORT_STMT; $REPORT_FSM; $REPORT_TOG"
# vsim command to save coverage to UCDB and later retreive it and show in HTML page
COV_DB_NAME="coverage.ucdb"
VSIM_REPORT_HTML_COVERAGE="coverage save -onexit $COV_DB_NAME"

# vsim command to run the simulation and report coverage in both ways
VSIM_RUN_AND_REPORT_COV="$VSIM_REPORT_HTML_COVERAGE; run -all; $VSIM_REPORT_TEXT_COVERAGE; quit"

#########################################################
#### OPTIMIZE THE DESIGN ENABLING COVERAGE REPORTING ####
#########################################################
print_green "############ OPTIMIZATION AND COVERAGE COLLECTION: ############ "
# Get top-level TB module name
top_level_tb_file=$(find $TB_DIR -type f -name "*top*.sv" | head -n 1)
#top_level_tb_file="$TB_DIR/simple_tb.sv"
tb_module="$(get_systemverilog_testbench_module $top_level_tb_file)"
# Optimized top-level module name (by vopt)
tb_module_opt="toptb_opt"

# Optimize the design enabling all coverage tracking
colorize vopt +cover=bcesft "work.$tb_module" -o "$tb_module_opt"

######################################################
#### SIMULATE USING RANDOM CONSTRAINED GENERATION ####
######################################################
print_green "############ SIMULATION: ############ "
########## vsim parameters ##########
SIM_TIMESCALE="10ps"
SIM_OPTIONS="-sv_seed random -onfinish stop +UVM_NO_RELNOTES"
NUM_SEQITEMS="10" # Default value, can be overridden by cmdline

# Override number of sequence items by passing in an argument to the script
if [[ $# -eq 1 ]]; then
  NUM_SEQITEMS="$1"
fi

SIM_SEQITEMS="+NUM_SEQITEMS=${NUM_SEQITEMS}"

# Simulate using Questa and report both text and HTML coverage in their
# respective directories ($COV_DIR and $COV_HTML_DIR)
colorize vsim -c -coverage "$tb_module_opt" -t $SIM_TIMESCALE $SIM_SEQITEMS \
  $SIM_OPTIONS -do "$VSIM_RUN_AND_REPORT_COV"
#
# colorize vsim -c -coverage "$tb_module_opt" -t $SIM_TIMESCALE $SIM_SEQITEMS \
#   $SIM_OPTIONS -do "$VSIM_RUN_AND_REPORT_COV" -sdftyp /Module_topTestbench/ifid_toplevel/DP_IFID_inst=../syn/DP_IFID.sdf

# Create "covhtmlreport" dir from .ucdb coverage file
[[ -d "$COV_HTML_DIR" ]] && rm -rf $COV_HTML_DIR
vcover report -details -html $COV_DB_NAME

# vsim -cvgperinstance -viewcov $COV_DB_NAME

########### CLEAN EMPTY COVERAGE FILES ###########
if [[ -d "$COV_DIR" ]]; then
  pushd "$COV_DIR" >/dev/null
  find . -type f -empty -exec rm -f {} +
  popd >/dev/null
fi

##################################################
####  FUNCTIONAL AND CODE COVERAGE REPORTING  ####
##################################################
# Print Code Coverage
print_green "############ COVERAGE STATISTICS (n=${NUM_SEQITEMS}): ############ "
cov_print "$COV_DIR/cov_all.txt"
cov_print "$COV_DIR/cov_branch.txt"
cov_print "$COV_DIR/cov_cond.txt"
cov_print "$COV_DIR/cov_expr.txt"
cov_print "$COV_DIR/cov_stmt.txt"
cov_print "$COV_DIR/cov_fsm.txt"
cov_print "$COV_DIR/cov_toggle.txt"

# Print Functional Coverage
func_cov_line=$(grep "^# Functional Coverage:" transcript)
if [ -n "$func_cov_line" ]; then
  echo "$func_cov_line" >"$COV_DIR/cov_functional.txt"
  cov_print "$COV_DIR/cov_functional.txt"
fi

########### CLEAN SIMULATION JUNK ###########
[ -f transcript ] && rm transcript
[ -f vsim.wlf ] && rm vsim.wlf
[ -f vish_stacktrace.vstf ] && rm vish_stacktrace.vstf
[ -f vsim_stacktrace.vstf ] && rm vsim_stacktrace.vstf

