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


function print_line() {
    printf "$1\n"
}

function print_error() {
    print_line "${RED}Error:${NC} $1"
}

function print_info() {
    print_line "${YELLOW}Info:${NC} $1"
}

function check_base_dir() {

    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

    if [ $CURRENT_DIR != $SCRIPT_DIR ]; then
        print_error "Run this script from its folder\n"
        exit 1
    fi

    return 0
}

function valid_ip() {
    local ip=$1
    local stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}