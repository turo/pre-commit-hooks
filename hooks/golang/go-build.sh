#!/usr/bin/env bash
FILES=$(go list ./...  | grep -v -e /vendor/ -e /node_modules/)
exec go build $FILES
