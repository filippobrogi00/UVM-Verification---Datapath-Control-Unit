# @brief: removes comments from the specified file 
# @params: $1 -> file to process 
remove_comments() {
  file="$1"
  
  # Remove single-line comments (// ...)
  sed -i 's://.*$::' "$file"

  # Remove multi-line inline comments (/* ... */)
  sed -i 's:/\*.*\*/::g' "$file"
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

# @brief: extracts Wrapper instance name from top level TB 
# @params: $1 -> top level TB file
extract_wrapper_instance_name() {
  top_tb_file="$1"

  remove_comments "$top_tb_file"
  remove_emptychars "$top_tb_file"

  # Extract and return the Wrapper instance name
  result=$(grep -oP '^\s*\w+\s*#\s*\(.*?\)\s*(\w+)\s*\(.*?\);\s*$' $top_tb_file | sed -E 's/^\s*\w+\s*#\s*\(.*?\)\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*\(.*?\);\s*$/\1/')
  echo "$result"
}

extract_wrapper_instance_name ../tb/Module_topTestbench.sv