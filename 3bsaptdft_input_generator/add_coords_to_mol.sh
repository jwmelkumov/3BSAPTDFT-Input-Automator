#!/bin/bash

# utility script to add atomic coordinates
# to dalton mol files for 3SAPTDFT, after
# generating all trimer mol files
# - John Melkumov

if [ $# -eq 0 ]; then
    echo "No NAME argument provided."
    exit 1
fi

NAME=$1

mapfile -t coords < tempcoords
for X in A B C AB BC AC ABC; do
    j=-1
    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:alnum:]]+[[:space:]]+0\.0000000000000[[:space:]]+0\.0000000000000[[:space:]]+0\.0000000000000$ ]]; then
            echo "${coords[$((++j))]}"
        else
            echo "$line"
        fi
    done < "${NAME}${X}.mol" > "modified_${NAME}${X}.mol"
done 

for X in A B C AB BC AC ABC; do
    mv "modified_${NAME}${X}.mol" "${NAME}${X}.mol" 
done 
