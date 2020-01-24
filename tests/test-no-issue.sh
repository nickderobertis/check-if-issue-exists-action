#!/bin/bash

export INPUT_REPO=nickderobertis/pypi-sphinx-quickstart
export INPUT_LABELS="wontfix, dummy label"
export INPUT_TITLE="asdkjaskdj"


output=$(docker run --rm -e INPUT_REPO -e INPUT_TOKEN -e INPUT_TITLE -e INPUT_LABELS check-if-issue-exists:latest)

echo "$output"

if [[ "$output" != *"::set-output name=exists::false"* ]]; then
  echo "Test did not return false as was supposed to. Got output: $output"
  exit 1;
fi;

echo "Test to return false passed."