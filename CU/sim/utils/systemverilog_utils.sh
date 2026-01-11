# Get SystemVerilog testbench module name
get_systemverilog_testbench_module() {
  local sv_file="$1"

  # Check file exists
  if [[ ! -f "$sv_file" ]]; then
    echo "[Error] File '$sv_file' not found"
    return 1
  fi

  # Extract the first module name
  local tb_module
  tb_module="$(awk '/^[[:space:]]*module[[:space:]]+/ {print $2; exit}' "$sv_file" | sed 's/[;(].*//')"

  if [[ -z "$tb_module" ]]; then
    echo "[Error] No module found in '$sv_file'"
    return 1
  fi

  echo "$tb_module"
}
