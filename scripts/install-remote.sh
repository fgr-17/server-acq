#!/bin/bash

INSTALL_DEST_DIR="/home/debian/installation"
INSTALL_LOCAL_DIR="target"
INSTALL_FILENAME="${INSTALL_LOCAL_DIR}.tar.gz"
INSTALL_SCRIPT_PRE="install_deps_pre.sh"
INSTALL_SCRIPT_POST="install_deps_post.sh"

DIR="$(dirname "$0")"

. ${DIR}/common.sh

function print_help() {
    print_line "Usage: "
    print_line "\t to install deps on the target: $0 -a <remote ip>"
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
        *) echo "Command not found"
           print_help;;
    esac
done

if valid_ip $remote_ip; then
    print_info "Remote IP:  $remote_ip"
else
    print_error "IP $remote_ip is invalid."
fi

print_info "Compressing local installation files:"
print_line
cd .. && tar -czvf ${INSTALL_FILENAME} ${INSTALL_LOCAL_DIR} > /dev/null 2>&1
print_line


print_info "Copying the installation files to the target ${DEFAULT_BB_USER}@${remote_ip} on dir ${INSTALL_DEST_DIR}"
ssh ${DEFAULT_BB_USER}@${remote_ip} "mkdir -p ${INSTALL_DEST_DIR}" > /dev/null 2>&1
rsync -av --progress ${INSTALL_FILENAME} "${DEFAULT_BB_USER}@${remote_ip}":${INSTALL_DEST_DIR} > /dev/null 2>&1
ssh ${DEFAULT_BB_USER}@${remote_ip} "tar -xzvf ${INSTALL_DEST_DIR}/${INSTALL_FILENAME} -C ${INSTALL_DEST_DIR}" > /dev/null 2>&1

print_info "Installing dependencies on remote target ${DEFAULT_BB_USER}@${remote_ip}"
ssh ${DEFAULT_BB_USER}@${remote_ip} "cd ${INSTALL_DEST_DIR}/${INSTALL_LOCAL_DIR} && chmod +x $INSTALL_SCRIPT_PRE && sudo ./${INSTALL_SCRIPT_PRE}"

print_info "Deploying files to remote"
cd scripts
./deploy-remote.sh -a ${remote_ip}

print_info "Installing dependencies on venv post-deploy"
ssh ${DEFAULT_BB_USER}@${remote_ip} "cd ${INSTALL_DEST_DIR}/${INSTALL_LOCAL_DIR} && chmod +x $INSTALL_SCRIPT_POST && sudo ./${INSTALL_SCRIPT_POST}"

ssh ${DEFAULT_BB_USER}@${remote_ip} "rm -rf ${INSTALL_DEST_DIR}" > /dev/null 2>&1

print_info "Removing local files"
cd .. && rm ${INSTALL_FILENAME}
exit 0
