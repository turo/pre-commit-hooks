#!/bin/dash

. "$(dirname "${0}")/golangci-lint-common.sh"

# Run golangci-lint in each of the module roots for each of the passed files
main() {
  ret=0
  cwd=$(pwd)
  for sub in $(find_module_roots "$@" | sort -u); do
    echo
    echo "Linting module: $sub"
    cd $sub
    lint_all
    ret=$(($? + ret))
    cd $cwd
  done
}

main "$@"
