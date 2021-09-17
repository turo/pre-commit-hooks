#!/bin/dash
#
# Capture and print stdout, since gofmt doesn't use proper exit codes
#
set -e

output="$(gomarkdoc --output '{{.Dir}}/README.md' ./...)"
[ -z "$output" ]
