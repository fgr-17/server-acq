#!/bin/bash

DIR="$(dirname "$0")"

. ${DIR}/common.sh

function print_help() {
    print_line "Usage: "
    print_line "\t to deploy files on the target: $0 -a <remote ip>"
    print_line "\t to clean files on the target: $0 -a <remote ip> -c"
    print_line "\t to show this message: $0 -h"
    print_line
    print_info "This script needs an authorized key with sudo user and nopassw allowance"
    exit 0
}

check_base_dir

clean=0

while getopts ha:p:c flag
do
    case "${flag}" in
        h) print_help;;
        a) remote_ip=$OPTARG ;;
        c) clean=1 ;;
        *) echo "Command not found"
           print_help;;
    esac
done

if valid_ip $remote_ip; then
    print_info "Remote IP:  $remote_ip"
else
    print_error "IP $remote_ip is invalid."
fi

./update-git-version.py

files=($(cd .. && ls *.py server_acq/*.py))

if (( clean == 1 )); then
    print_info "Cleaning deployed files"
    ssh ${DEFAULT_BB_USER}@${remote_ip} "cd ${DEPLOY_DEST_DIR} && rm -rf ${files[@]}" > /dev/null 2>&1
    exit 0
fi

print_info "Compressing local files:"
print_line
cd .. && tar -czvf ${DEPLOY_FILENAME} "${files[@]}"
print_line

print_info "Copying the files to the target ${DEFAULT_BB_USER}@${remote_ip} on dir ${DEPLOY_DEST_DIR}"
ssh ${DEFAULT_BB_USER}@${remote_ip} "mkdir -p ${DEPLOY_DEST_DIR}" > /dev/null 2>&1
rsync -av --progress $DEPLOY_FILENAME "${DEFAULT_BB_USER}@${remote_ip}":${DEPLOY_DEST_DIR} > /dev/null 2>&1
ssh ${DEFAULT_BB_USER}@${remote_ip} "tar -xzvf ${DEPLOY_DEST_DIR}/${DEPLOY_FILENAME} -C ${DEPLOY_DEST_DIR} && rm ${DEPLOY_DEST_DIR}/${DEPLOY_FILENAME}" > /dev/null 2>&1
ssh ${DEFAULT_BB_USER}@${remote_ip} "sudo systemctl restart server_acq" > /dev/null 2>&1

print_info "Deleting compressed file"
rm ${DEPLOY_FILENAME}
exit 0