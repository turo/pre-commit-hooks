#!/bin/bash
# Exits with status code 1 if a yalc dependency is present in the package manifest
set -e

yalc check
