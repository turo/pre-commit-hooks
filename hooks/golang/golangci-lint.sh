#!/bin/dash

. "$(dirname "${0}")/golangci-lint-common.sh"

# Run golangci-lint in each of the passed files
main (){
    ret=0
    for file in "$@"; do
        echo
        echo "Linting: $file"
        lint_all "$file"
        ret=$(($? + ret))
    done
    exit $ret
}

main "$@"
