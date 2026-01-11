
source ./utils/sim_colors.sh
source ./utils/systemverilog_utils.sh

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
  if [[ $cov_type == "Functional" ]]; then
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

print_cvg_summary() {
	print_green "############ $2 COVERAGE STATISTICS (n=${NUM_SEQITEMS}): ############ "
	cov_print "$1/cov_all.txt"
	cov_print "$1/cov_branch.txt"
	cov_print "$1/cov_cond.txt"
	cov_print "$1/cov_expr.txt"
	cov_print "$1/cov_stmt.txt"
	cov_print "$1/cov_fsm.txt"
	cov_print "$1/cov_toggle.txt"
}


NUM_SEQITEMS="10"

if [[ $# -eq 1 ]]; then 
	NUM_SEQITEMS="$1"
fi

########### RUN RTL SIMULATION ###########
[ -d "work" ] && rm -rf "work"
[ -d "covhtmlreport" ] && rm -rf "covhtmlreport"
./run_rtl.sh ${NUM_SEQITEMS}
#
# ############ SAVE RTL COVERAGE #########
# rtl_txtcov_dir="./coverage/rtl_txt"
# rtl_htmlcov_dir="./coverage/rtl_html"
# [ -d "$rtl_txtcov_dir" ] && rm -rf "$rtl_txtcov_dir" && mkdir -p "$rtl_txtcov_dir"
# [ -d "$rtl_htmlcov_dir" ] && rm -rf "$rtl_htmlcov_dir" && mkdir -p "$rtl_htmlcov_dir"
# mv ./coverage/*.txt "$rtl_txtcov_dir"
# mv ./covhtmlreport "$rtl_htmlcov_dir"

########### RUN POST-SYNTH SIMULATION ###########
[ -d "work" ] && rm -rf "work"
[ -d "../syn/work" ] && rm -rf "../syn/work"
[ -d "covhtmlreport" ] && rm -rf "covhtmlreport"
./run_syn.sh ${NUM_SEQITEMS}
#
# ########## REPORT BOTH COVERAGES ########
# syn_txtcov_dir="./coverage/syn_txt"
# syn_htmlcov_dir="./coverage/syn_html"
# [ -d "$syn_txtcov_dir" ] && rm -rf "$syn_txtcov_dir" && mkdir -p "$syn_txtcov_dir"
# [ -d "$syn_htmlcov_dir" ] && rm -rf "$syn_htmlcov_dir" && mkdir -p "$syn_htmlcov_dir"
# mv ./coverage/*.txt "$syn_txtcov_dir"
# mv ./covhtmlreport "$syn_htmlcov_dir"

print_cvg_summary "./coverage/rtl_txt" "RTL"
print_cvg_summary "./coverage/syn_txt" "POSTSYN"




