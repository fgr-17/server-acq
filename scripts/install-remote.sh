#!/bin/bash

DIR="$(dirname "$0")"

. ${DIR}/common.sh

function print_help() {
    print_info "bla bla"
}

check_base_dir

while getopts ha: flag
do
    case "${flag}" in
        h) print_help;;
        a) remote_ip=$OPTARG ;;
        *) echo "Command not found"
           print_help;;
    esac
done


if valid_ip $remote_ip; then
    print_info "Remote IP:  $remote_ip"
else
    print_error "IP $remote_ip is invalid."
fi

