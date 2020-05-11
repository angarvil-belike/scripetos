#!/bin/bash

input="./README.md"

IFS=$'\n' 

n=0
for j in $(cat $input); do
    lines[$n]="$j"
    ((n++))
done

i=0
founds=0
for line in ${lines[*]}; do
    if echo "$line" | grep -q '```'; then
        ((founds++))
        if [[ $((founds % 2)) == 1 ]]; then
            descriptions[$founds / 2]=${lines[$i-1]}
        fi
        if [[ $((founds % 2)) == 0 ]]; then
            commands[$founds / 2 - 1]=${lines[$i-1]/$'\r'/}
        fi
    fi
    ((i++))
done

select description in ${descriptions[*]}; do
    for i in "${!descriptions[@]}"; do
        if [[ "${descriptions[$i]}" = "${description}" ]]; then
            echo ${commands[$i]}
            eval "${commands[$i]}"
            break;
        fi
    done
    break;
done
