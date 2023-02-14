#!/bin/bash
# Verifies no yalc dependency is present
set -e

check_files() {
    has_error=0
    for file in "$@" ; do
        if egrep "(file|link):\.yalc" $file; then
            echo "ERROR: $file should not have a yalc dependency"
            has_error=1
        fi
    done
}

check_files "$@"
exit $has_error
