#!/bin/bash

DIR="$(dirname "$0")"

. ${DIR}/common.sh

function print_help() {
    print_info "bla bla"
}

check_base_dir

while getopts :h flag
do
    case "${flag}" in
        h) print_help;;
        *) echo "Command not found"
           print_help;;
    esac
done