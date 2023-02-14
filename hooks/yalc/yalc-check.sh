#!/bin/bash
# Exits with status code 1 if a yalc dependency is present in the package manifest
set -e

for file in "$@" ; do
    if egrep "(file|link):\.yalc" $file; then
        exit 1
    fi
done
