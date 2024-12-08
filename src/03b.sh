#!/bin/bash

set -e

sum=0
do=1
while read -r line; do
    case "$line" in
        "do") do=1 ;;
        "don't") do=0 ;;
    esac

    if [[ "$do" -eq 0 ]]; then
        continue
    fi

    k="${line:4:-1}"
    value1="${k%,*}"
    value2="${k#*,}"
    (( sum+= (value1*value2) ))
done < <(grep -oP "(don't|do)|mul\(\d+,\d+\)" "$1")
echo "$sum"
