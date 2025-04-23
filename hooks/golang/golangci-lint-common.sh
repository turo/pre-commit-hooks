#!/bin/dash
# There's a ton of available linters: https://golangci-lint.run/usage/linters
# We're using a large subset in addition to the defaults
lint_all() {
  ## Lets first report what version of golangi-lint is being run since it will
  ## not otherwise provide that information.
  version_output=$(golangci-lint --version)
  echo "$version_output"

  ## Extract semver number (e.g., 1.54.2 or 2.1.2)
  version=$(echo "$version_output" | grep -oP 'version \K[0-9]+\.[0-9]+\.[0-9]+')

  ## Use correct format flag depending on version
  if [ "$(printf '%s\n' "$version" "1.55.0" | sort -V | head -n1)" = "1.55.0" ]; then
    # version >= 1.55.0 → use --format
    format_flag="--format"
  else
    # version < 1.55.0 → use --out-format
    format_flag="--out-format"
  fi

  golangci-lint run \
    --allow-parallel-runners \
    --fix \
    --verbose \
    "$format_flag" colored-line-number \
    --color always \
    --enable errcheck \
    --enable gosimple \
    --enable govet \
    --enable ineffassign \
    --enable staticcheck \
    --enable unused \
    --timeout 5m \
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
