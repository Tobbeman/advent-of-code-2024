#!/bin/bash

set -e
set -o pipefail

input=$(cat "$1")
mapfile -t left < <(echo "$input" | awk '{print $1}' | sort)
mapfile -t right < <(echo "$input" | awk '{print $2}' | sort)

declare -A occurences

for x in "${right[@]}"; do
    value="${occurences[$x]}"
    if [ "$value" == "" ]; then
        value=0
    fi
    value=$(( value + 1 ))
    occurences[$x]="$value"
done

sum=0
for x in "${left[@]}"; do
    occurence="${occurences[$x]}"
    if [ "$occurence" == "" ]; then
        occurence=0
    fi

    similarity=$(( x * occurence ))
    sum=$(( sum + similarity ))
done

echo "$sum"
