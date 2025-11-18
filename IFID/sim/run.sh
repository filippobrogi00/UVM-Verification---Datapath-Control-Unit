#!/bin/bash
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

# Script variables - Working directories
BASENAME_CWD="$(basename $(pwd))"
ROOT_DIR=""
SIM_DIR="sim"
SRC_DIR="src"
TB_DIR="tb"
COV_DIR="$SIM_DIR/coverage"

if [[ $BASENAME_CWD == "$SIM_DIR" || $BASENAME_CWD == "$SRC_DIR" || $BASENAME_CWD == "$TB_DIR" ]]; then
  SIM_DIR="../$SIM_DIR"
  SRC_DIR="../$SRC_DIR"
  TB_DIR="../$TB_DIR"
  COV_DIR="$SIM_DIR/coverage"
  ROOT_DIR="../"
fi

# Create dirs
mkdir -p $SIM_DIR
mkdir -p $SRC_DIR
mkdir -p $TB_DIR
mkdir -p $COV_DIR

# Script variables - Compilation
SV_COMPILE_LIST="$TB_DIR/Iface_IFID.sv $TB_DIR/Module_IFID_Wrapper.sv $TB_DIR/Module_topTestbench.sv"

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
  total_cov_line="$(grep "^Total Coverage" $1)"

  # Get total coverage
  total_cov_str="${total_cov_line#*:}"

  # Get percent digits from the line and convert them into a number
  cov=${total_cov_str%.*}

  # Output string
  out_str="Total $cov_type Coverage:\t $total_cov_str"

  if [ $cov -lt 70 ]; then
    print_red "[INSUFFICIENT] \t $out_str"
  elif [ $cov -ge 70 ] && [ $cov -lt 80 ]; then
    print_yellow "[BARE MINIMUM] \t $out_str"
  elif [ $cov -ge 80 ] && [ $cov -lt 90 ]; then
    print_yellow "[ACCEPTABLE] \t $out_str"
  elif [ $cov -ge 90 ] && [ $cov -lt 95 ]; then
    print_green "[GOOD] \t\t $out_str"
  else # cov >= 95
    print_green "[VERY GOOD] \t $out_str"
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
REPORT_COVERAGE="$REPORT_ALL; $REPORT_BRANCH; $REPORT_COND; $REPORT_EXPR; $REPORT_STMT; $REPORT_FSM; $REPORT_TOG"
# vsim command to simulate and report coverage to .txt files
VSIM_SIMULATE_AND_REPORT_COVERAGE="run -all; $REPORT_COVERAGE; quit"
# vsim command to save coverage to UCDB and later retreive it and show in HTML page
COV_DB_NAME="coverage.ucdb"
VSIM_HTML_COVERAGE="coverage save -onexit $COV_DB_NAME; run -all; quit"

#########################################################
#### OPTIMIZE THE DESIGN ENABLING COVERAGE REPORTING ####
#########################################################
print_green "############ OPTIMIZATION AND COVERAGE COLLECTION: ############ "
# Get top-level TB module name
top_level_tb_file=$(find $TB_DIR -type f -name "*top*.sv" | head -n 1)
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
if [ -n "$1" ]; then
  NUM_SEQITEMS="$1"
fi

SIM_SEQITEMS="+NUM_SEQITEMS=${NUM_SEQITEMS}"

# Always simulate using Questasim (vsim is Questa's internal simulator tool)

## Simulate and report coverage in coverage/cov_xxx.txt report files
alias vsim_simulate="
  colorize vsim -c -coverage \"$tb_module_opt\" -t $SIM_TIMESCALE $SIM_SEQITEMS
  $SIM_OPTIONS -do \"$VSIM_SIMULATE_AND_REPORT_COVERAGE\""
## Simulate and report coverage in covhtmlreport/ dir for browser use (more detailed)
alias vsim_gen_html_cov_report="\
  colorize vsim -c -coverage \"$tb_module_opt\" -t $SIM_TIMESCALE $SIM_SEQITEMS \
  $SIM_OPTIONS -do \"$VSIM_HTML_COVERAGE\"
  && \
  vcover report -details -html $COV_DB_NAME"

vsim_gen_html_cov_report

# vsim -cvgperinstance -viewcov $COV_DB_NAME

########### CLEAN SIMULATION JUNK ###########
[ -f transcript ] && rm transcript
[ -f vsim.wlf ] && rm vsim.wlf
[ -f vish_stacktrace.vstf ] && rm vish_stacktrace.vstf
[ -f vsim_stacktrace.vstf ] && rm vsim_stacktrace.vstf

##################################################
####  FUNCTIONAL AND CODE COVERAGE REPORTING  ####
##################################################
print_green "############ COVERAGE STATISTICS (n=${NUM_SEQITEMS}): ############ "
cov_print "$COV_DIR/cov_all.txt"
cov_print "$COV_DIR/cov_branch.txt"
cov_print "$COV_DIR/cov_cond.txt"
cov_print "$COV_DIR/cov_expr.txt"
cov_print "$COV_DIR/cov_stmt.txt"
cov_print "$COV_DIR/cov_fsm.txt"
cov_print "$COV_DIR/cov_toggle.txt"
