#!/bin/bash

set -e

yaml_file="$1"

main() {
    if [[ ! -f "$yaml_file" ]]; then
        echo "Error: $yaml_file not found"
        exit 1
    fi
    if ! command -v yq &> /dev/null; then
        echo "Error: yq is required but not installed"
        echo "Install with: brew install yq"
        exit 1
    fi

    temp_file=$(mktemp)

    yq eval 'sort_keys(.)' "$yaml_file" > "$temp_file"

    if [[ $? -eq 0 ]]; then
        mv "$temp_file" "$yaml_file"
        echo "Sorted top-level keys in $yaml_file."
        git add "$yaml_file"
        exit 0
    else
        echo "Error: Failed to sort YAML file"
        rm -f "$temp_file"
        exit 1
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
