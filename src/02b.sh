#!/bin/bash

set -e
set -o nounset

wrong_index_return=0
function wrong_index() {
    local line="$1"
    prev=-1
    sign=0
    prev_sign=0
    index=-1
    wrong_index_return=-1
    for value in $line; do
        index=$(( index + 1 ))
        if [[ "$prev" == -1 ]]; then
            prev="$value"
            continue
        fi
        difference=$(( value - prev ))

        if [[ "$difference" -eq 0 ]]; then
            wrong_index_return="$index"
            break
        fi

        if [[ "$difference" -gt 0 ]]; then
            sign=1
        else
            sign=-1
        fi

        difference="${difference#-}"
        if [[ "$difference" -gt 3 || ("$prev_sign" != 0 && "$sign" != "$prev_sign") ]]; then
            wrong_index_return="$index"
            break
        fi
        prev="$value"
        prev_sign="$sign"
    done
}

mapfile -t input < <(cat "$1")

correct=0
for line in "${input[@]}"; do
    wrong_index "$line"
    if [[ "$wrong_index_return" -eq -1 ]]; then
        correct=$(( correct + 1 ))
        continue
    else
        arr=($line)
        unset 'arr[wrong_index_return]'
        wrong_index "${arr[*]}"
        if [[ "$wrong_index_return" -eq -1 ]]; then
            correct=$(( correct + 1 ))
            continue
        fi

        arr=($line)
        unset 'arr[$((wrong_index_return - 1))]'
        wrong_index "${arr[*]}"
        if [[ "$wrong_index_return" -eq -1 ]]; then
            correct=$(( correct + 1 ))
            continue
        fi
        
        arr=($line)
        unset 'arr[0]'
        wrong_index "${arr[*]}"
        if [[ "$wrong_index_return" -eq -1 ]]; then
            correct=$(( correct + 1 ))
            continue
        fi
    fi
done

echo "$correct"
