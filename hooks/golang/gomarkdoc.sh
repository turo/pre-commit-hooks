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
    echo "DEBUG Using environment repository"
    gomarkdoc --output '{{.Dir}}/README.md' -vv \
        --repository.url "${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY%%/}" \
        --repository.default-branch "${GITHUB_DEFAULT_BRANCH:-main}" ./...
else
    gomarkdoc --output '{{.Dir}}/README.md' -vv ./...
fi
