#!/bin/bash

VERSION_FILE=../version.py

BRANCH=$(git rev-parse --abbrev-ref HEAD)
HASH=$(git rev-parse --short HEAD)

echo "git_branch='${BRANCH}'" > ${VERSION_FILE}
echo "git_hash='${HASH}'" >> ${VERSION_FILE}

echo "${BRANCH}@${HASH}"