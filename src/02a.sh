#!/bin/bash

set -e
set -o pipefail

mapfile -t input < <(cat "$1")

correct=0
for line in "${input[@]}"; do
    prev=-1
    valid=1
    sign=0
    last_sign=0
    for value in $line; do
        if [[ "$prev" == -1 ]]; then
            prev="$value"
            continue
        fi
        difference=$(( value - prev ))

        if [[ "$difference" -eq 0 ]]; then
            valid=0
            break
        fi

        if [[ "$difference" -gt 0 ]]; then
            sign=1
        else
            sign=-1
        fi

        difference="${difference#-}"
        if [[ "$difference" -gt 3 || ("$last_sign" != 0 && "$sign" != "$last_sign") ]]; then
            valid=0
            break
        fi
        prev="$value"
        last_sign="$sign"
    done

    if [[ "$valid" == 1 ]]; then
        correct=$(( correct + 1 ))
    fi
done

echo "$correct"
