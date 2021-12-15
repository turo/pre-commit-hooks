#!/bin/dash
# There's a ton of available linters: https://golangci-lint.run/usage/linters
# We're using a large subset in addition to the defaults
lint_all () {
    golangci-lint run \
        --fix \
        --verbose \
        --out-format colored-line-number \
        --color always \
        --enable asciicheck \
        --enable durationcheck \
        --enable errcheck \
        --enable exportloopref \
        --enable gci \
        --enable gocognit \
        --enable goconst \
        --enable gocritic \
        --enable gocyclo \
        --enable gofmt \
        --enable gofumpt \
        --enable goimports \
        --enable gosec \
        --enable gosimple \
        --enable govet \
        --enable ifshort \
        --enable ineffassign \
        --enable prealloc \
        --enable predeclared \
        --enable sqlclosecheck \
        --enable staticcheck \
        --enable structcheck \
        --enable tagliatelle \
        --enable typecheck \
        --enable unconvert \
        --enable unparam \
        --enable unused \
        --enable varcheck \
        --enable wastedassign \
        --enable whitespace \
        --enable wrapcheck  \
        "$@"
    return $?
}

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
