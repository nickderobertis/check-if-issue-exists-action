#!/bin/bash
# NOTE: Run from main project directory

source env.sh

# Build image if necessary
./build.sh

# Test success
./tests/test-find-issue.sh

# Test fail
./tests/test-no-issue.sh