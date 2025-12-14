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
