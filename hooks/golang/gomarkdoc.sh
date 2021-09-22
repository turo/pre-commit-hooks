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
    # Trim trailing slash if it's present
    GITHUB_REPOSITORY="${GITHUB_REPOSITORY%%/}"
    # Build the CLI arg for manually setting the repo
    REPOSITORY="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}"
    echo "DEBUG REPOSITORY=${REPOSITORY}"
    ARG_REPO="--repository.url"
    # Configure the default branch
    BRANCH="${GITHUB_DEFAULT_BRANCH:-main}"
    ARG_BRANCH="--repository.default-branch"
fi

gomarkdoc --output '{{.Dir}}/README.md' "$ARG_BRANCH" "$BRANCH" "$ARG_REPO" "$REPOSITORY" -vv ./...
