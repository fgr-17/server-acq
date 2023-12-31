#!/bin/bash

PYLINT_MAX_LINE_LENGTH=200
PYLINT_MAX_ARGS=6
SOURCE_PATH='..'
CURRENT_DIR=$(pwd)
PACKAGE_PATH='/workspace/views'

bold=$(tput bold)
normal=$(tput sgr0)

packages=(
    "app.py"
    "views/views.py"
)

function check_base_dir() {

    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

    if [ $CURRENT_DIR != $SCRIPT_DIR ]; then
        printf "Error: run this script from its folder, please\n"
        exit 1
    fi

    return 0
}

function style() {
    printf "\n${bold}Checking code style ...${normal}\n"
    # pycodestyle --show-source --show-pep8 --format=pylint ../

    for package in ${packages[@]}; do
        printf "\t> Checking $package..."
        pycodestyle --format=pylint --max-line-length=$PYLINT_MAX_LINE_LENGTH "${SOURCE_PATH}/$package" --exclude='*build*'

        if [ $? -ne 0 ]; then
            return 1
        fi

        printf "OK\n"

    done
    return 0
}

function lint() {
    printf "\n${bold}Linting source files ...${normal}\n"

    GOOD_NAMES='f'

    for package in ${packages[@]}; do
        printf "\t> Checking $package..."
        pylint --max-line-length=$PYLINT_MAX_LINE_LENGTH --max-args=$PYLINT_MAX_ARGS --good-names=$GOOD_NAMES $SOURCE_PATH/$package

        if [ $? -ne 0 ]; then
            return 1
        fi

    done
    return 0
}

function test_suite() {
    printf "\n${bold}Running unit tests ...${normal}\n"
    cd "${SOURCE_PATH}"
    echo $PWD 
    pytest
    return $?
}

MAIN_FILE="app.py"

INIT_PATH=$PWD

check_base_dir

style
if [ $? -ne 0 ]; then
    printf "Please check code style before continue...\n"
    exit 1
fi

lint
if [ $? -ne 0 ]; then
    printf "Please check linter issues before continue...\n"
    exit 1
fi

test_suite
if [ $? -ne 0 ]; then
    printf "Please check test cases before continue...\n"
    exit 1
fi


# printf "Building  Package"
# cd $CURRENT_DIR
# cd $PACKAGE_PATH
# # python3 -m build
# pip install --upgrade .
# if [ $? -ne 0 ]; then
#     printf "Couldn't build package, exiting...\n"
#     exit 1
# fi


cd "${INIT_PATH}"
cd ..
echo $PWD
./${MAIN_FILE}
