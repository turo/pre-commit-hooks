#!/usr/bin/env bash
set -e

# Just vet everything for now... maybe call out individual files later
go vet ./...
