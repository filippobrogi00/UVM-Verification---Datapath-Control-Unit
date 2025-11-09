############################################
#### VHDL COMPILATION UTILITY FUNCTIONS ####
############################################

#### @name: get_vhdl_testbench_entity
#### @inputs:
####   List of VHDL design files, with testbench as last one
#### @return:
####   Returns the VHDL Top Level testbench module's name
#### @desc:
####   Extracts the last VHDL file's testbench module name
get_vhdl_testbench_entity() {
  # 0) Grab the LAST argument (the test bench file)
  local tb_file="${@:$#}"

  # 1) Check if last argument is a configuration name (doesn't contain .vhd)
  if [[ "$tb_file" != *".vhd"* ]]; then
    echo "$tb_file"
    return
  fi

  # 2) Try extracting the FIRST configuration name from the file
  #    - Looks for "configuration CONFIG_NAME of"
  local tb_config
  tb_config="$(
    awk '
      /^[[:space:]]*[Cc][Oo][Nn][Ff][Ii][Gg][Uu][Rr][Aa][Tt][Ii][Oo][Nn][[:space:]]+/ {
        print $2;
        exit
      }
    ' "$tb_file"
  )"

  # 3) If a configuration is found, return it
  if [[ -n "$tb_config" ]]; then
    echo "$tb_config"
    return
  fi

  # 4) Otherwise, look for the entity name
  local tb_entity
  tb_entity="$(
    awk '
      /^[[:space:]]*[Ee][Nn][Tt][Ii][Tt][Yy][[:space:]]+/ {
        print $2;
        exit
      }
    ' "$tb_file"
  )"

  # 5) If no entity is found, print an error and exit
  if [[ -z "$tb_entity" ]]; then
    echo "[Error] No configuration or entity found in '$tb_file'"
    return 1
  fi

  # 6) Warn about missing configuration and return the entity name
  echo "[Warning] No configuration found, using entity '$tb_entity'"
  echo "$tb_entity"
}

# @name      : get_vhdl_testbench_entity_and_arch
# @arguments : list of .vhd design files to scan, with last one being the testbench to use
# @return    : if last argument is not a file, it uses that as the testbench configuration name and returns it.
#              else it fetches from the testbench file the entity and architecture names and returns them concatenated.
get_vhdl_testbench_entity_and_arch() {
  # 0) Grab the LAST .vhd file among arguments (the test bench file)
  # local tb_file
  local tb_file="${@:$#}"
  # for ((i = ${#args[@]} - 1; i >= 0; i--)); do
  #   if [[ ${args[i]} == *.vhd ]]; then
  #     tb_file="${args[i]}"
  #     break
  #   fi
  # done

  local subdir=""
  local tb_entity=""
  local tb_arch=""

  # 0) If last argument is a configuration name (doesn't contain .vhd)
  #    simply build the string as that configuration

  # No file specified, then it's the configuration name to use, return it
  if [[ "$tb_file" != *".vhd"* ]]; then
    echo "$tb_file"
    return
  fi

  # Testbench inside sub-directory, get correct filename string and subdir for later use
  #if [[ "$tb_file" == */* ]]; then
  #  tb_file="${tb_file#*/}"  # remove everything before '/'
  #  subdir="${tb_file%/*}"   # remove everything after '/'
  #fi

  # From here on, we search the testbench's ENTITY and ARCHITECTURE

  # 1) Look for the entity name
  local tb_entity
  tb_entity="$(
    awk '
      /^[[:space:]]*[Ee][Nn][Tt][Ii][Tt][Yy][[:space:]]+/ {
        print $2;
        exit
      }
    ' "$tb_file"
  )"

  if [[ -z "$tb_entity" ]]; then
    echo "[Error] No entity found in '$tb_file'"
    return "NO_ENTITY_FOUND NO_ARCH_STOPPED"
  fi

  # 2) Look for architecture corresponding to the entity
  local tb_arch
  tb_arch="$(
    awk -v entity="$tb_entity" '
      /^[[:space:]]*[Aa][Rr][Cc][Hh][Ii][Tt][Ee][Cc][Tt][Uu][Rr][Ee][[:space:]]+/ {
        for(i=1;i<=NF;i++){
          if($i == "of" && $(i+1) == entity){
            print $2; exit
          }
        }
      }
    ' "$tb_file"
  )"

  # Fallback if architecture not found
  if [[ -z "$tb_arch" ]]; then
    echo "[Warning] No architecture found for entity '$tb_entity', using 'NO_ARCH_FOUND'"
    tb_arch="NO_ARCH_FOUND"
  fi

  # 3) Return entity and architecture names
  echo "$tb_entity $tb_arch"
}
