#!/bin/dash

. "$(dirname "${0}")/golangci-lint-common.sh"

# Run golangci-lint in each of the passed files
main (){
    echo "Linting: all"
    lint_all
    exit $?
}

main "$@"
