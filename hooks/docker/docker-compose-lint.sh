#!/bin/dash
# Verifies that files passed in are valid for docker-compose
set -e

check_file() {
    # out=$($CMD --file "$1" config --quiet 2>&1)
    docker-compose --file "$1" config --quiet 2>&1
    res=$?
    # out=$(echo "$out" | sed "/variable is not set. Defaulting/d")
    # echo "$out"
    return "$res"
}

check_files() {
    has_error=0
    for file in "$@" ; do
        if [ -f "$file" ]; then
            if ! check_file "$file" ; then
                echo "ERROR: $file" >&2
                has_error=1
            fi
        fi
    done
    return $has_error
}

if ! check_files "$@" ; then
    echo "Some compose files failed"
fi

exit $has_error
