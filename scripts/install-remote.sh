#!/bin/bash

if ! [ -f common.sh ]; then
    printf "Error\n"
    exit 1
fi


. ./common.sh


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