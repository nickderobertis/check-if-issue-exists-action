#!/bin/sh -l

cd /

exists=$(python check_issue.py)

if [ $? -ne 0 ]; then
    echo "Error checking if issue exists" >&2;

    exit 1;
fi

echo ::set-output name=exists::$exists
