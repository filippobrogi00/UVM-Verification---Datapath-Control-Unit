#!/bin/bash

########### PROLOGUE ###########
# Check correct number of args
if [ $# != 1 ]; then
  echo "Usage: $0 <assembly_program_to_test>.asm"
  exit 1
fi

# Exit on any error
set -e

########### VARIABLES ###########
source ./colors.sh     # for print_<color> functions
source ./vhdl_utils.sh # for using get_vhdl_testbench_entity_and_arch()
BASE_DIR="$(dirname $(pwd))"
IRAM_FILE="$BASE_DIR/a.c-IRAM.vhd"
PROGRAM_DIR="$BASE_DIR/programs"
TESTBENCH_DIR="$BASE_DIR/test_bench"
RUN_DIR="$BASE_DIR/run"
RESULT_PROG="$BASE_DIR/Result.bin.mem"
ASMFILE=$(echo $1 | sed s/[.].*//g)

########### REMOVE PREVIOUS FILES  ###########
cd $PROGRAM_DIR
rm -f $ASMFILE.bin.*
[ -f $ASMFILE.list ] && rm $ASMFILE.list
[ -f $RESULT_PROG ] && rm $RESULT_PROG

########### ASSEMBLE ###########
perl $BASE_DIR/assembler.bin/dlxasm.pl -o $ASMFILE.bin -list $ASMFILE.list "./$1" 2>&1 |
  while IFS= read -r line; do
    case "$line" in
    "Illegal"*) print_red "$line" ;;
    "Last"*) print_blue "$line" ;;
    *) echo "$line" ;;
    esac
  done

########### OUTPUT ASSEMBLY PROGRAM ###########
print_green "############ ASSEMBLY PROGRAM: ############ "
cat $ASMFILE.list

########### CONVERT TO MEMORY FILE ###########
$BASE_DIR/assembler.bin/conv2memory $ASMFILE.bin >$ASMFILE.bin.mem

########### ! UPDATE IRAM FILE DYNAMICALLY BASED ON ASSEMBLY PROGRAM ! ###########
# Escape forward slashes for sed
ASMFILE_NAME=$(printf '%s\n' "$ASMFILE" | sed 's/[&/\]/\\&/g')
ASMFILE="$ASMFILE_NAME.asm"
ASMFILE_LINE_COUNT=$(wc -l $ASMFILE | sed -E 's#([0-9]+)[[:space:]][a-zA-z_.-]+#\1#g')
MEMFILE="$ASMFILE_NAME.bin.mem"
MEMFILE_LINE_COUNT=$(wc -l $MEMFILE | sed -E 's#([0-9]+)[[:space:]][a-zA-z_.-]+#\1#g')
# ASMFILE_LINE_COUNT_v2=$(wc -l <"$ASMFILE.asm")

# Update FILENAME_BASIC and FILENAME_MEM_BASIC at runtime
sed -i "s#^\(\s*constant\s\+FILENAME_ASM_BASIC\s*:\s*string\s*:=\s*\)\".*\";#\1\"$PROGRAM_DIR/$ASMFILE\";#" "$IRAM_FILE"
sed -i "s#^\(\s*constant\s\+FILENAME_ASM_BASIC_LENGTH\s*:\s*integer\s*:=\s*\).*;#\1$ASMFILE_LINE_COUNT;#" "$IRAM_FILE"
sed -i "s#^\(\s*constant\s\+FILENAME_MEM_BASIC\s*:\s*string\s*:=\s*\)\".*\";#\1\"$PROGRAM_DIR/$MEMFILE\";#" "$IRAM_FILE"
sed -i "s#^\(\s*constant\s\+FILENAME_MEM_BASIC_LENGTH\s*:\s*integer\s*:=\s*\).*;#\1$MEMFILE_LINE_COUNT;#" "$IRAM_FILE"

########### CLEAN COMPILATION FILES ###########
[ -f $ASMFILE.bin.hdr ] && rm $ASMFILE.bin.hdr

##################################
#### COMPILE VHDL & SIMULATE  ####
##################################
print_green "############ COMPILATION: ############ "
# Reset to "sources" dir
cd $BASE_DIR
# Create work library
if [[ -d "work" ]]; then
  vdel -all work
fi
vlib work
vmap work work

# Define files to compile hierarchically
COMPILE_SUBLIST_PKG="000-pkg-globals.vhd 001-pkg-registerfile.vhd"
COMPILE_SUBLIST_CU="a.a-CU_HW.vhd"                              # a.a CU
COMPILE_SUBLIST_ALU="a.b.a.a-generic_shifter.vhd a.b.a-ALU.vhd" # a.b.a.* shifter -> a.b.a ALU
COMPILE_SUBLIST_DP="
    a.b.b-DRAM.vhd a.b.c-SignExtender26-32.vhd
    a.b.d-MUX.vhd a.b.e-PC_Add.vhd  a.b.f-RegisterFile.vhd
    a.b.g-FlipFlop.vhd a.b.h-SignExtender16-32.vhd a.b.i-ZeroComparator.vhd
    $COMPILE_SUBLIST_ALU
    a.b-DataPath.vhd"               # a.b.* -> a.b DP
COMPILE_SUBLIST_IRAM="a.c-IRAM.vhd" # a.c IRAM
COMPILE_SUBLIST_TB="$TESTBENCH_DIR/TB_DLX.vhd"
COMPILE_LIST_DLX="$COMPILE_SUBLIST_PKG
  $COMPILE_SUBLIST_CU $COMPILE_SUBLIST_DP $COMPILE_SUBLIST_IRAM
  a-DLX.vhd
  $COMPILE_SUBLIST_TB"

# For easier testing of just some sub-parts
COMPILE_LIST_DEBUG="
  a.c-IRAM.vhd
  $TESTBENCH_DIR/TB_IRAM.vhd"

# Dynamically update simulation time wait statement
# sed -i "s#^\(\s*constant\s\+TB_WAIT_CYCLES\s*:\s*integer\s*:=\s*\).*;#\1$ASMFILE_LINE_COUNT;#" "$COMPILE_SUBLIST_TB"

# Compile all VHDL files (vcom is Questasim's internal compiler)
cd $BASE_DIR
vcom -reportprogress 300 -2008 -work work $COMPILE_LIST_DLX 2>&1 |
  grep -v '^--\sCompiling' | grep -v '^--\sLoading' | sed 's#::>::#Compiled#g' |
  while IFS= read -r line; do
    case "$line" in
    "** Error"*) print_red "$line" ;;
    "** Warning"*) print_yellow "$line" ;;
    "** Info"* | "Compiled"*) print_blue "$line" ;;
    *) echo "$line" ;;
    esac
  done # Colorize output lines

# Continue with simulation only if there are no errors in vcom
if [ "${PIPESTATUS[0]}" -ne 0 ]; then # while runs in a subshell, PIPESTATUS captures pipe output
  exit
fi

# Simulate using Questasim (vsim is Questa's internal simulator tool)
print_green "############ SIMULATION: ############ "
read tb_entity tb_arch <<<"$(get_vhdl_testbench_entity_and_arch $COMPILE_LIST_DLX)"

# vsim parameters
SIM_RUNTIME="30ns"
SESSION_NAME="DLX_Session"

# Spawn a new QuestaSim window (GUI) and make it run
# the initialization tcl script vsim_run_sim.do
vsim "work.$tb_entity($tb_arch)" -t 10ps -voptargs=+acc \
  -do "set RUN_TIME $SIM_RUNTIME; do $RUN_DIR/vsim_run_sim.do" 2>&1 |
  grep -v '^#\s\+Time:' |
  while IFS= read -r line; do
    case "$line" in
    "# ** Error"* | "# ** Fatal"*) print_red "$line" ;;
    "# ** Warning"*) print_yellow "$line" ;;
    "# ** Note"*) print_blue "$line" ;;
    *) echo "$line" ;;
    esac
  done # Colorize output lines

########### CLEAN SIMULATION FILES ###########
[ -f transcript ] && rm transcript
[ -f vsim.wlf ] && rm vsim.wlf
