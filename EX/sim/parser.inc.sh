#########################################################
####   FAULT INJECTION CAMPAIGN UTILITY FUNCTIONS    ####
#########################################################


# @brief: removes comments from the specified file 
# @params: $1 -> temporary file to process 
remove_comments() {
  tmpfile="$1"
  
  # Remove single-line comments (// ...)
  sed -i 's://.*$::' "$tmpfile"

  # Remove multi-line inline comments (/* ... */)
  sed -i 's:/\*.*\*/::g' "$tmpfile"

  ### Remove multi-line block comments (/* ... */) ###
  sed -i 's:/\*.*::g' "$tmpfile" # remove opening /* and everything after it
  sed -i ':a;N;$!ba;s:.*\*/::g' "$tmpfile" # remove everything before closing (loop until pattern found) */
}


# @brief: removes tabs and spaces from the specified file 
# @params: $1 -> temporary file to process 
remove_emptychars() {
  tmpfile="$1"
  
  # Remove leading and trailing whitespaces and tabs
  sed -i 's/^[ \t]*//;s/[ \t]*$//' "$tmpfile"
  
  # Remove empty lines
  sed -i '/^$/d' "$tmpfile"

  # Remove UNIX-style newlines 
  tr -d '\n' < "$tmpfile" 

  # Remove Windows-style newlines
  tr -d '\n\r' < "$tmpfile" 
}

# @brief: extracts DUT instantiation name from TB DUT Wrapper file,
#         using a special comment in the same line
# @params: $1 -> TB Wrapper file
extract_dut_from_wrappertb() {
  top_tb_file="$1"

  # Extract the first line containing the specific comment
  target_line=$(grep "// WARN: PARSER COMMENT, DO NOT CHANGE/REMOVE" "$top_tb_file" | head -n 1)

  # Extract the instance name before the parentheses
  instance_name=$(echo "$target_line" | sed -E 's/.*\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\(.*/\1/')

  # Output the result
  echo "$instance_name"
}

# @brief: Extracts the Wrapper instance name from the top level testbench,
#         using a special comment in the same line
# @params: $1 -> top-level TB file
extract_wrapper_from_topleveltb() {
  top_tb_file="$1"

  # Extract the first line containing the specific comment
  target_line=$(grep "// WARN: PARSER COMMENT, DO NOT CHANGE/REMOVE" "$top_tb_file" | head -n 1)

  # Extract the instance name before the parentheses
  instance_name=$(echo "$target_line" | sed -E 's/.*\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\(.*/\1/')

  # Output the result
  echo "$instance_name"
}

extract_dut_from_wrappertb ../tb/Module_EX_Wrapper.sv
extract_wrapper_from_topleveltb ../tb/Module_topTestbench.sv