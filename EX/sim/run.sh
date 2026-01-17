#!/bin/bash

#############################################
###### USAGE AND PARAMETERS PROCESSING ######
#############################################
# Use case 1: ./run.sh                       run RTL simulation with default (100) sequence items
# Use case 2: ./run.sh 1000                  run RTL simulation with 1000 sequence items 
# Use case 3: ./run.sh 1000 postsyn          run post-synthesis GLN simulation with 1000 sequence items 
# Use case 4: ./run.sh 1000 faultsim         run fault simulation with 1000 sequence items and fault list file

# Print usage 
if [[ $# -ne 1 && $# -ne 2 ]]; then
  echo "Usage: $0 <number of sequence items per sequence to generate> [<sim|postsyn|faultsim>]"
  exit 1
fi

# If first arg is a string, default to 100 sequence items
if [[ "$1" =~ ^[a-zA-Z]+$ ]]; then
  NUM_SEQITEMS=100
fi 

# Check second argument allowed values 
if [[ $# -eq 2 && "$2" != "postsyn" && "$2" != "faultsim" ]]; then 
  print_red "Error: second argument must be either 'postsyn' or 'faultsim'"
  exit 1
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
source ./sim_colors.inc.sh
source ./systemverilog_utils.inc.sh # get_systemverilog_testbench_module()
source ./parser.inc.sh

# Script variables - Working directories
BASENAME_CWD="$(basename $(pwd))"
ROOT_DIR=""
SIM_DIR="sim"
SRC_DIR="src"
TB_DIR="tb"
SYN_DIR="syn"
COV_DIR="$SIM_DIR/coverage"
COV_HTML_DIR="$SIM_DIR/covhtmlreport"

if [[ $BASENAME_CWD == "$SIM_DIR" || $BASENAME_CWD == "$SRC_DIR" || $BASENAME_CWD == "$TB_DIR" ]]; then
  SIM_DIR="../$SIM_DIR"
  SRC_DIR="../$SRC_DIR"
  TB_DIR="../$TB_DIR"
  SYN_DIR="../$SYN_DIR"
  COV_DIR="$SIM_DIR/coverage"
  COV_HTML_DIR="$SIM_DIR/covhtmlreport"
  ROOT_DIR="../"
fi

# Create dirs
mkdir -p $SIM_DIR
mkdir -p $SRC_DIR
mkdir -p $TB_DIR
mkdir -p $SYN_DIR
mkdir -p $COV_DIR

# Script variables - Compilation
SV_COMPILE_LIST="$TB_DIR/Iface_EX.sv $TB_DIR/Module_EX_Wrapper.sv $TB_DIR/Module_topTestbench.sv"

#########################################################
####       POST-SYNTHESIS SIMULATION VARIABLES       ####
#########################################################
# Post-synthesis simulation flag
postsyn_sim_enabled=0
if [[ $# -eq 2 && ("$2" == "postsyn" || "$2" == "faultsim") ]]; then 
  postsyn_sim_enabled=1  
fi

# Macro defined for compilation use for post-synthesis simulation
POSTSYN_SIMULATION=""
if [[ postsyn_sim_enabled -eq 1 ]]; then 
  export POSTSYN_SIMULATION="+define+POSTSYN_SIMULATION"
fi

#########################################################
####   FAULT INJECTION CAMPAIGN VARIABLES - BASH     ####
#########################################################
# Bash flag to indicate if user wants to fault simulate
faultsim_enabled=0
if [[ $# -eq 2 && "$2" == "faultsim" ]]; then 
  faultsim_enabled=1
fi

# File path in which Detected Faults count will be stored by UVM 
# after fault simulation
if [[ $faultsim_enabled -eq 1 ]]; then 
  export CLASSIFIED_FAULTS_FILE="$SIM_DIR/classified_faults.txt"
  [[ -f "$CLASSIFIED_FAULTS_FILE" ]] && rm $CLASSIFIED_FAULTS_FILE
fi 

# Path to fault list file passed to UVM testbench as ENVVAR_FAULT_LIST_FILE environment variable
export ENVVAR_FAULT_LIST_FILE=""
if [[ $faultsim_enabled -eq 1 ]]; then 
  export ENVVAR_FAULT_LIST_FILE="$SIM_DIR/fault_list.txt"
fi 

### Build bash variables to export to UVM testbench ###
# Get top-level TB module name
top_level_tb_file=$(find $TB_DIR -type f -name "*top*.sv" | head -n 1)
export ENVVAR_TB_TOPLEVEL_NAME="$(get_systemverilog_testbench_module $top_level_tb_file)"

##############################################################################
####   FAULT INJECTION CAMPAIGN VARIABLES - SYSTEMVERILOG COMPILATION     ####
##############################################################################
# Fault injection SV #define 
FAULT_INJECTION_CAMPAIGN="" # Fault-free simulation default value

# Macro defined for compilation use for fault simulation
if [[ $faultsim_enabled -eq 1 ]]; then 
  FAULT_INJECTION_CAMPAIGN="+define+FAULT_INJECTION_CAMPAIGN"
	# Create single-line temporary fault list file 
  export ENVVAR_FAULT_LIST_FILE_TEMP="$SIM_DIR/fault_list_temp.txt"
	echo "$ENVVAR_FAULT_LIST_FILE_TE"	
fi

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

        # Compile testbench files adding optional post-synthesis and 
        # fault simulation macros if needed
        if [[ $postsyn_sim_enabled -eq 1 ]]; then 
          compiler="$compiler $POSTSYN_SIMULATION"

          if [[ $faultsim_enabled -eq 1 ]]; then 
            compiler="$compiler $FAULT_INJECTION_CAMPAIGN"
          fi

        fi

        # Compile SV Testbench files 
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


# Classify coverage metrics based on thresholds and print them colored
# @param $1 : coverage percentage
# @param $2 : output string to print (already formatted)
classify_and_print_coverage() {

  cov="$1"
  out_str="$2"

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

  classify_and_print_coverage "$cov" "$out_str"
}

# @brief: Prints fault coverage based on Number of Detected Faults
fault_cov_print() {

  # Check if detected faults output file has been created by UVM testbench
  detected=0
  if [[ ! -f "$CLASSIFIED_FAULTS_FILE" ]]; then
    print_red "Error: UVM Testbench did not create detected faults output file $CLASSIFIED_FAULTS_FILE!"
    return
  fi

  # Get number of detected and total faults 
  detected=$(grep "DETECTED" $CLASSIFIED_FAULTS_FILE | wc -l)
  total_faults=$(wc -l < $ENVVAR_FAULT_LIST_FILE)
  total_cov=$(( $detected * 100 / $total_faults ))

  # Print Fault Coverage 
  print_green "============= FAULT COVERAGE REPORT ============="
  classify_and_print_coverage "$total_cov" "Fault Coverage: $total_cov%"
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

# Check for RTL or post-synthesis simulation
if [[ postsyn_sim_enabled -eq 1 || faultsim_enabled -eq 1 ]]; then 
  # ---- POST-SYNTHESIS SIMULATION ----

  # Compile gate library
  vlog -timescale=1ns/1ps -work work /eda/dk/nangate45/verilog/NangateOpenCellLibrary.v
  # Compile postsyn netlist
  vlog -timescale=1ns/1ps -work work ../syn/DP_EX.v
 
fi 

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
# Optimized top-level module name (by vopt)
tb_module_opt="toptb_opt"

# Optimize the design enabling all coverage tracking
colorize vopt +cover=bcesft "work.$ENVVAR_TB_TOPLEVEL_NAME" -o "$tb_module_opt"

###############################################################
####   FAULT INJECTION CAMPAIGN VARIABLES - SIMULATION     ####
###############################################################
# Simulation exit after first `uvm_error macro used
EXIT_AFTER_UVM_ERROR="" # Fault-free simulation default value
if [[ $faultsim_enabled -eq 1 ]]; then
  EXIT_AFTER_UVM_ERROR="+UVM_MAX_QUIT_COUNT=1" # Exit after first uvm_error
fi 

######################################################
#### SIMULATE USING RANDOM CONSTRAINED GENERATION ####
######################################################
print_green "############ SIMULATION: ############ "
########## vsim parameters ##########
SIM_TIMESCALE="10ps"
SIM_OPTIONS="-sv_seed random -onfinish stop +UVM_NO_RELNOTES"
NUM_SEQITEMS="100" # Default value, can be overridden by cmdline

# Sequence Items override
if [[ $# -eq 1 ]]; then
  # Override by passing in an argument to the script
  NUM_SEQITEMS="$1"
elif [[ $# -eq 2 && faultsim_enabled -eq 1 ]]; then 
  # If fault simulation enabled, set it to 1 for faster simulation
  NUM_SEQITEMS=1
fi

SIM_SEQITEMS="+NUM_SEQITEMS=${NUM_SEQITEMS}"

# Simulate using Questa and report both text and HTML coverage in their
# respective directories ($COV_DIR and $COV_HTML_DIR).

if [[ postsyn_sim_enabled -eq 1 ]]; then 
  
  # Get wrapper instance from top level TB 
  wrapper_inst=$(extract_wrapper_from_topleveltb "$top_level_tb_file")

  # Get DUT instantiation name from Wrapper TB file 
  wrapper_file=$(grep "[Ww]rapper" $TB_DIR/*.sv | head -n 1 | cut -d: -f1)
  dut_inst=$(extract_dut_from_wrappertb "${wrapper_file}")

  # If fault simulation is enabled, fault simulate for every line of the fault list file.
  # Else, run a single post-synthesis simulation.
  if [[ $faultsim_enabled -eq 1 ]]; then 

     # ---- POST-SYNTHESIS FAULT SIMULATION ----

    SIM_FAULTSIM_OPTIONS="$EXIT_AFTER_UVM_ERROR $FAULT_INJECTION_CAMPAIGN"

    # Initialization
    sim_cycle_count=1
    total_faults=$(wc -l < $ENVVAR_FAULT_LIST_FILE)

    # Loop over all faults in the fault list file
    for i in $(seq 1 $total_faults); do 
      print_green "==== FAULT SIMULATION (#$i / $total_faults) ===="

      # Read next fault from file 
      current_fault_line=$(sed -n "${sim_cycle_count}p" "$ENVVAR_FAULT_LIST_FILE")

      # Create temporary fault file with the current fault to be injected
      [[ -f "$ENVVAR_FAULT_LIST_FILE_TEMP" ]] && rm "$ENVVAR_FAULT_LIST_FILE_TEMP"
      echo "$current_fault_line" > "$ENVVAR_FAULT_LIST_FILE_TEMP"

      # Run fault simulation
      colorize vsim -c -coverage "$tb_module_opt" \
        -t $SIM_TIMESCALE $SIM_SEQITEMS $SIM_OPTIONS \
         $SIM_FAULTSIM_OPTIONS \
        -do "$VSIM_RUN_AND_REPORT_COV"         
				#-sdftyp /${ENVVAR_TB_TOPLEVEL_NAME}/${wrapper_inst}/${dut_inst}=${SYN_DIR}/DP_EX.sdf # specify SDF file

      sim_cycle_count=$((sim_cycle_count + 1))
    done 

  else 
    # ---- POST-SYNTHESIS RTL SIMULATION ----

    # Run post-synthesis simulation with SDF back-annotation
    colorize vsim -c -coverage "$tb_module_opt" \
    -t $SIM_TIMESCALE $SIM_SEQITEMS $SIM_OPTIONS \
    -do "$VSIM_RUN_AND_REPORT_COV" \
    -sdftyp /${ENVVAR_TB_TOPLEVEL_NAME}/${wrapper_inst}/${dut_inst}=${SYN_DIR}/DP_EX.sdf # specify SDF file

  fi # faultsim_enabled -eq 1

else 

   # ---- FAULT-FREE RTL SIMULATION ----
  colorize vsim -c -coverage "$tb_module_opt" \
  -t $SIM_TIMESCALE $SIM_SEQITEMS $SIM_OPTIONS \
  -do "$VSIM_RUN_AND_REPORT_COV"

fi  # postsyn_sim_enabled -eq 1

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


###############################################
####  FUNCTIONAL FAULT COVERAGE REPORTING  ####
###############################################
if [[ $faultsim_enabled -eq 1 ]]; then 
  fault_cov_print
  print_blue "The list of injected and classified faults can be found in: $CLASSIFIED_FAULTS_FILE"
fi

