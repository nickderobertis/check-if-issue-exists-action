#!/bin/bash
# NOTE: Run from main project directory

if [ -f env.sh ]; then
  source env.sh
fi;

# Build image if necessary
./build.sh

# Test success
./tests/test-find-issue.sh

# Test fail
./tests/test-no-issue.sh