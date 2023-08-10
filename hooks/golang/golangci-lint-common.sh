#!/bin/dash
# There's a ton of available linters: https://golangci-lint.run/usage/linters
# We're using a large subset in addition to the defaults
lint_all() {
  golangci-lint run \
    --allow-parallel-runners \
    --fix \
    --verbose \
    --out-format colored-line-number \
    --color always \
    --enable errcheck \
    --enable gosimple \
    --enable govet \
    --enable ineffassign \
    --enable staticcheck \
    --enable unused \
    ./...
  return $?
}

# Walks up the file path looking for go.mod
# Prunes paths with /vendor/ in them
find_module_roots() {
  local path
  for path in "$@"; do
    if case "$path" in vendor/*) true ;; */vendor/*) true ;; */vendor) true ;; *) false ;; esac then
      continue
    fi
    if [ "${path}" = "" ]; then
      path="."
    elif [ -f "${path}" ]; then
      path=$(dirname "${path}")
    fi
    while [ "${path}" != "." ] && [ ! -f "${path}/go.mod" ]; do
      path=$(dirname "${path}")
    done
    if [ -f "${path}/go.mod" ]; then
      printf "%s\n" "${path}"
    fi
  done
}
