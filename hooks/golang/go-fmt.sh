#!/bin/dash
#
# Capture and print stdout, since gofmt doesn't use proper exit codes
#
set -e

output="$(gofmt -l -w "$@" 2>&1)"
[ -z "$output" ]
