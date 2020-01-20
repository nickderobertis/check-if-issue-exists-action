#!/bin/bash

export INPUT_REPO=whoopnip/pypi-sphinx-quickstart
export INPUT_LABELS=wontfix
export INPUT_TITLE="An example issue raised by todo-actions"


output=$(docker run --rm -e INPUT_REPO -e INPUT_TOKEN -e INPUT_TITLE -e INPUT_LABELS check-if-issue-exists:latest)

echo "$output"

if [[ "$output" != *"::set-output name=exists::true"* ]]; then
  echo "Test did not return true as was supposed to. Got output: $output"
  exit 1;
fi;

echo "Test to return true passed."