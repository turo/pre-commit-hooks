#!/bin/dash
#
# Capture and print stdout, since gofmt doesn't use proper exit codes
#
set -e

# Provide a default for this because it's easier than a check/replace
GITHUB_SERVER_URL="${GITHUB_SERVER_URL:-https://github.com}"
# We switch behavior if we're running on GitHub Actions because we can't
# autodetect the GitHub remote URI correctly
if [ -n "$GITHUB_REPOSITORY" ]; then
    # Trim trailing slash if it's present
    GITHUB_REPOSITORY="${GITHUB_REPOSITORY%%/}"
    # Build the CLI arg for manually setting the repo
    REPOSITORY="--repository.url ${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}"
fi

# shellcheck disable=SC2086
output="$(gomarkdoc --output '{{.Dir}}/README.md' $REPOSITORY ./...)"
[ -z "$output" ]
