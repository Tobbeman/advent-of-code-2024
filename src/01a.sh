#!/bin/bash

set -e
set -o pipefail

input=$(cat "$1")
mapfile -t left < <(echo "$input" | awk '{print $1}' | sort)
mapfile -t right < <(echo "$input" | awk '{print $2}' | sort)

sum=0
for index in "${!left[@]}"; do
    distance=$(( left[index] - right[index] ))
    distance="${distance#-}"
    sum=$(( sum + distance ))
done

echo "$sum"
