#########################################################
####   FAULT INJECTION CAMPAIGN UTILITY FUNCTIONS    ####
#########################################################


# @brief: removes comments from the specified file 
# @params: $1 -> file to process 
remove_comments() {
  file="$1"
  
  # Remove single-line comments (// ...)
  sed -i 's://.*$::' "$file"

  # Remove multi-line inline comments (/* ... */)
  sed -i 's:/\*.*\*/::g' "$file"

  ### Remove multi-line block comments (/* ... */) ###
  sed -i 's:/\*.*::g' "$file" # remove opening /* and everything after it
  sed -i ':a;N;$!ba;s:.*\*/::g' "$file" # remove everything before closing (loop until pattern found) */

}

# @brief: removes tabs and spaces from the specified file 
# @params: $1 -> file to process 
remove_emptychars() {
  file="$1"
  
  # Remove leading and trailing whitespaces and tabs
  sed -i 's/^[ \t]*//;s/[ \t]*$//' "$file"
  
  # Remove empty lines
  sed -i '/^$/d' "$file"

  # Remove UNIX-style newlines 
  tr -d '\n' < "$file" > "${file}_temp" && mv "${file}_temp" "$file"

  # Remove Windows-style newlines
  tr -d '\n\r' < "$file" > "${file}_temp" && mv "${file}_temp" "$file"
}

# @brief: extracts DUT instantiation name from TB DUT Wrapper file 
# @params: $1 -> TB Wrapper file
extract_dut_instantiation_name() {
  tb_wrapper_file="$1"

  remove_comments "$tb_wrapper_file"
  remove_emptychars "$tb_wrapper_file"

  # Extract and return the DUT instantiation name
  result=$(grep -oP '^module.*?;.*?\)\s*(\w+)\s*\(' $tb_wrapper_file | sed -E 's/.*\)\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*\(.*/\1/')
  echo "$result"
}


# @brief: Extracts the Wrapper instance name from the top level testbench,
#         given a special comment in the same line
# @params: $1 -> top-level TB file
extract_wrapper_instance_name() {
  top_tb_file="$1"

  # Extract the first line containing the specific comment
  target_line=$(grep "// WARN: PARSER COMMENT, DO NOT CHANGE/REMOVE" "$top_tb_file" | head -n 1)

  # Extract the instance name before the parentheses
  instance_name=$(echo "$target_line" | sed -E 's/.*\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\(.*/\1/')

  # Output the result
  echo "$instance_name"
}


extract_wrapper_instance_name ../tb/toptbcopy.sv

