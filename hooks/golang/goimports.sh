#!/bin/dash
#
# Capture and print stdout, since goimports doesn't use proper exit codes
#
set -e

output="$(goimports -l -w "$@" 2>&1)"
[ -z "$output" ]
