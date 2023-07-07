NC='\033[0;0m'
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
STATUS_COLOR="$CYAN"
ERROR_COLOR="$RED"
WHITE="\033[1;37m"
CURRENT_DIR=$(pwd)

function print_error() {
    printf "${RED}Error:${NC} $1\n"
}

function print_info() {
    printf "${YELLOW}Info:${NC} $1\n"

}

function check_base_dir() {

    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

    if [ $CURRENT_DIR != $SCRIPT_DIR ]; then
        print_error "Run this script from its folder\n"
        exit 1
    fi

    return 0
}