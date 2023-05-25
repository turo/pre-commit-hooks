#!/usr/bin/env bash
FILES=$(go list ./...  | grep -v -e /vendor/ -e /node_modules/)

# We don't use build tags commonly enough, so we're just going to run all tests
# locally and let the tests use environment flags to run integration tests.
# go test -tags=unit -timeout 30s -short -v ${FILES}
# shellcheck disable=SC2086
go test -parallel 1 -timeout 30s -short -v ${FILES}

returncode=$?
if [ $returncode -ne 0 ]; then
  echo "unit tests failed"
  exit 1
fi
