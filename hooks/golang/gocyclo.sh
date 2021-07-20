#!/bin/dash

# Hard codes the max complexity, we may want to make this configurable
exec gocyclo -over=15 "$@"
