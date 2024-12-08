#!/bin/bash

set -e

sum=0
while read -r line; do
    k="${line:4:-1}"
    value1="${k%,*}"
    value2="${k#*,}"
    (( sum+= (value1*value2) ))
done < <(grep -oP 'mul\(\d+,\d+\)' "$1")
echo "$sum"
