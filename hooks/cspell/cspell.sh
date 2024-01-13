#!/bin/bash
set -e

git diff --name-only | npx cspell --no-summary --no-progress --no-must-find-files --file-list stdin
