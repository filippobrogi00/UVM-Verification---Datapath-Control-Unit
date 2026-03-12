#!/bin/bash

####################################
####     COLOR ENCODINGS        ####
####################################
END='\033[0m'

BLACK='\033[30m'
WHITE='\033[97m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[1;33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
GRAY='\033[90m'

LGRAY='\033[37m'
LRED='\033[91m'
LGREEN='\033[92m'
LYELLOW='\033[93m'
LBLUE='\033[94m'
LMAGENTA='\033[95m'
LCYAN='\033[96m'

####################################
####     PRINT UTILITIES        ####
####################################
print_black() { echo -e "${BLACK}$1${END}"; }
print_white() { echo -e "${WHITE}$1${END}"; }
print_red() { echo -e "${RED}$1${END}"; }
print_green() { echo -e "${GREEN}$1${END}"; }
print_yellow() { echo -e "${YELLOW}$1${END}"; }
print_blue() { echo -e "${BLUE}$1${END}"; }
print_magenta() { echo -e "${MAGENTA}$1${END}"; }
print_cyan() { echo -e "${CYAN}$1${END}"; }
print_gray() { echo -e "${GRAY}$1${END}"; }

# Optional: reset color
reset_color() { echo -e "${END}"; }

########################################
########################################
####      COLORIZE UTILITIES        ####
########################################
########################################
colorize_usage() {
  cat <<'USAGE'
Usage: colorize <vcom|vsim|vlog> [arguments...]
Wraps the specified simulator command and colorizes its output like run.sh.
USAGE
}

colorize() {
  if [ $# -eq 0 ]; then
    colorize_usage >&2
    return 1
  fi

  local tool="$1"
  shift

  case "$tool" in
  vcom)
    vcom "$@" 2>&1 |
      grep -v '^--\sCompiling' | grep -v '^--\sLoading' | sed 's#::>::#Compiled#g' |
      while IFS= read -r line; do
        case "$line" in
        "** Error"*)
          if declare -f print_red >/dev/null; then print_red "$line"; else printf '%s\n' "$line"; fi
          ;;
        "** Warning"*)
          if declare -f print_yellow >/dev/null; then print_yellow "$line"; else printf '%s\n' "$line"; fi
          ;;
        "** Info"* | "Compiled"*)
          if declare -f print_blue >/dev/null; then print_blue "$line"; else printf '%s\n' "$line"; fi
          ;;
        *)
          printf '%s\n' "$line"
          ;;
        esac
      done
    if [ "${PIPESTATUS[0]}" -ne 0 ]; then
      exit 1
    fi
    ;;
  vsim)
    vsim "$@" 2>&1 |
      grep -v '^#\s\+Time:' |
      while IFS= read -r line; do
        case "$line" in
        "# ** Error"* | "# ** Fatal"* | "# UVM_ERROR"* | "# UVM_FATAL"*)
          if declare -f print_red >/dev/null; then print_red "$line"; else printf '%s\n' "$line"; fi
          ;;
        "# ** Warning"*)
          if declare -f print_yellow >/dev/null; then print_yellow "$line"; else printf '%s\n' "$line"; fi
          ;;
        "# ** Note"* | "# UVM_INFO"*)
          if declare -f print_blue >/dev/null; then print_blue "$line"; else printf '%s\n' "$line"; fi
          ;;
        *)
          printf '%s\n' "$line"
          ;;
        esac
      done
    if [ "${PIPESTATUS[0]}" -ne 0 ]; then
      exit 1
    fi
    ;;
  vlog)
    vlog "$@" 2>&1 |
      while IFS= read -r line; do
        case "$line" in
        "# ** Error"* | "** Error"*)
          if declare -f print_red >/dev/null; then print_red "$line"; else printf '%s\n' "$line"; fi
          ;;
        "# ** Warning"* | "** Warning"*)
          if declare -f print_yellow >/dev/null; then print_yellow "$line"; else printf '%s\n' "$line"; fi
          ;;
        "# ** Note"* | "** Note"* | "-- Compiling"*)
          if declare -f print_blue >/dev/null; then print_blue "$line"; else printf '%s\n' "$line"; fi
          ;;
        *)
          printf '%s\n' "$line"
          ;;
        esac
      done
    if [ "${PIPESTATUS[0]}" -ne 0 ]; then
      exit 1
    fi
    ;;
  vopt)
    vopt "$@" 2>&1 |
      while IFS= read -r line; do
        case "$line" in
        "# ** Error"* | "** Error"*)
          if declare -f print_red >/dev/null; then print_red "$line"; else printf '%s\n' "$line"; fi
          ;;
        "# ** Warning"* | "** Warning"*)
          if declare -f print_yellow >/dev/null; then print_yellow "$line"; else printf '%s\n' "$line"; fi
          ;;
        "# ** Note"* | "** Note"* | "-- Compiling"*)
          if declare -f print_blue >/dev/null; then print_blue "$line"; else printf '%s\n' "$line"; fi
          ;;
        *)
          printf '%s\n' "$line"
          ;;
        esac
      done
    if [ "${PIPESTATUS[0]}" -ne 0 ]; then
      exit 1
    fi
    ;;
  sccom)
  ;;
  *)
    echo "colorize: unsupported command '$tool' (expected vcom, vsim or vlog)" >&2
    colorize_usage >&2
    return 1
    ;;
  esac
}
