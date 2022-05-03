#!/bin/bash
# Verifies that yaml files have the right extension
set -e

check_files() {
    has_error=0
    for file in "$@" ; do
       # if filename ends with .yml then fail
       if [[ "$file" =~ \.yml$ ]] ; then
           echo "ERROR: $file should not have .yml extension"
           has_error=1
       fi
    done
    return $has_error
}

if ! check_files "$@" ; then
    echo "Some compose files failed"
fi

exit $has_error
