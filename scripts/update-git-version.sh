#!/bin/bash

VERSION_FILE=../version.py

BRANCH=$(git rev-parse --abbrev-ref HEAD)
HASH=$(git rev-parse --short HEAD)

echo "branch='${BRANCH}'" > ${VERSION_FILE}
echo "hash='${HASH}'" >> ${VERSION_FILE}

echo "${BRANCH}@${HASH}"