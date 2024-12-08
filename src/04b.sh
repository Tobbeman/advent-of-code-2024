#!/bin/bash

set -e

declare -A map

function is_valid_mas() {
    if [[ 
        "$1" == "MS" ||
        "$1" == "SM" ||
        "$(echo "$1" | rev)" == "MS" ||
        "$(echo "$1" | rev)" == "SM"
    ]]; then
        return 0;
    fi
    return 1;
}

line_length=0
char_index=0
line_index=0
while read -r line; do
    line_length="$char_index"
    char_index=0
    while IFS= read -rn1 char; do
        map[$line_index,$char_index]="$char"
        (( char_index += 1 ))
    done <<< "$line"
    (( line_index += 1 ))
done < "$1"

sum=0
for (( y=0 ; y <= line_index ; y++ )); do
    for (( x=0 ; x <= line_length ; x++ )); do
        if [[ "${map[$y,$x]}" != "A" ]]; then
            continue
        fi
        
        left="${map[$((y-1)),$((x-1))]}${map[$((y+1)),$((x+1))]}"
        right="${map[$((y+1)),$((x-1))]}${map[$((y-1)),$((x+1))]}"
        if is_valid_mas "$left" && is_valid_mas "$right"; then
            (( sum+=1 ))
        fi
    done
done
echo "$sum"
