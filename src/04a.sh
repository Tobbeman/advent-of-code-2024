#!/bin/bash

set -e

function spells_xmas() {
    if [[ "$1" == "X" && "$2" == "M" && "$3" == "A" && "$4" == "S" ]]; then
        return 0
    fi
    return 1
}

declare -A map

line_length=0
char_index=0
line_index=0
while read -r line; do
    line_length=$char_index
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
        if [[ "${map[$y,$x]}" != "X" ]]; then
            continue
        fi
        
        # Right
        if  spells_xmas "${map[$y,$x]}" "${map[$y,$((x+1))]}" "${map[$y,$((x+2))]}" "${map[$y,$((x+3))]}"; then
            (( sum+=1 ))   
        fi
        # Down right
        if spells_xmas "${map[$y,$x]}" "${map[$((y+1)),$((x+1))]}" "${map[$((y+2)),$((x+2))]}" "${map[$((y+3)),$((x+3))]}"; then 
            (( sum+=1 ))   
        fi
        # Down
        if spells_xmas "${map[$y,$x]}" "${map[$((y+1)),$x]}" "${map[$((y+2)),$x]}" "${map[$((y+3)),$x]}"; then
            (( sum+=1 ))   
        fi
        # Down left
        if spells_xmas "${map[$y,$x]}" "${map[$((y+1)),$((x-1))]}" "${map[$((y+2)),$((x-2))]}" "${map[$((y+3)),$((x-3))]}"; then
            (( sum+=1 ))   
        fi
        # Left
        if spells_xmas "${map[$y,$x]}" "${map[$y,$((x-1))]}" "${map[$y,$((x-2))]}" "${map[$y,$((x-3))]}"; then
            (( sum+=1 ))   
        fi
        # Up left
        if spells_xmas "${map[$y,$x]}" "${map[$((y-1)),$((x-1))]}" "${map[$((y-2)),$((x-2))]}" "${map[$((y-3)),$((x-3))]}"; then
            (( sum+=1 ))   
        fi
        # Up
        if spells_xmas "${map[$y,$x]}" "${map[$((y-1)),$x]}" "${map[$((y-2)),$x]}" "${map[$((y-3)),$x]}"; then
            (( sum+=1 ))   
        fi
        # Up right
        if spells_xmas "${map[$y,$x]}" "${map[$((y-1)),$((x+1))]}" "${map[$((y-2)),$((x+2))]}" "${map[$((y-3)),$((x+3))]}"; then
            (( sum+=1 ))   
        fi
    done
done
echo "$sum"
