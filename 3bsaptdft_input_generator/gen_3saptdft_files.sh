#!/bin/bash

#================================================
# Utility script to generate all necessary files
# for running 3SAPTDFT. User need only prepare
# ${NAME}A.dal, corr, ${NAME}P.data, and 
# trimer.info file with the following 
# programs present in the working directory:
#
# (1) gen_trimer_cnf, (2) gen_dimer_cnf, 
# (3) gen_tempcoords
#
# Author: John W. Melkumov
#================================================

MAIN_SAPT_DIR=/PATH/TO/SAPT2020.1

if [ $# -eq 0 ]; then
    echo "No NAME argument provided."
    exit 1
fi

if [ $# -eq 1 ]; then
    echo "No TYPE argument provided."
    exit 1
fi

if [ $# -eq 2 ]; then
    echo "No BASIS argument provided."
    exit 1
fi

NAME=$1
TYPE=$2
BASIS=$3

###############################################
# Check if necessary files present ...
###############################################

# check if ${NAME}A.dal file exists
# if not throw error '${NAME}A.dal file not found.'
if [ -f "${NAME}A.dal" ]; then
    continue
else
    echo "${NAME}A.dal file not found."
    exit
fi

# check if ${NAME}P.data file exists
# if not throw error '${NAME}P.data file not found.'
if [ -f "${NAME}P.data" ]; then
    continue
else
    echo "${NAME}P.data file not found."
    exit
fi

# check if trimer.info file exists
# if not throw error 'trimer.info file not found.'
if [ -f "trimer.info" ]; then
    continue
else
    echo 'trimer.info file not found.'
    exit
fi

# check if gen_trimer_cnf binary exists
# if not throw error 'gen_trimer_cnf not found.'
if [ -f "gen_trimer_cnf" ]; then
    continue
else
    echo 'gen_trimer_cnf binary not found.'
    exit
fi

# check if gen_dimer_cnf binary exists
# if not throw error 'gen_dimer_cnf not found.'
if [ -f "gen_dimer_cnf" ]; then
    continue
else
    echo 'gen_dimer_cnf binary not found.'
    exit
fi

# check if gen_tempcoords binary exists
# if not throw error 'gen_tempcoords not found.'
if [ -f "gen_tempcoords" ]; then
    continue
else
    echo 'gen_tempcoords binary not found.'
    exit
fi

###############################################
# Prepare inputs ...
###############################################

# run gen_trimer_cnf (no arguments necessary)
# with trimer.info present in working directory
# this will generate trimer.cnf
./gen_trimer_cnf

# run gen_dimer_cnf (no arguments necessary)
# with trimer.info present in working directory
# this will generate dimer.cnf
./gen_dimer_cnf

# run gen_tempcoords (no arguments necessary)
# with trimer.info present in working directory
# this will generate tempcoords
./gen_tempcoords

# generate dimer *.mol files
$MAIN_SAPT_DIR/misc/daltutil/createinputs $NAME $TYPE $BASIS

# run createtrimers from $MAIN_SAPT_DIR/misc/daltutil/
# this will generate trimer *.mol files
$MAIN_SAPT_DIR/misc/daltutil/createtrimers $NAME 0 $BASIS

# add coordinates to all mol files (they are
# all 0 after createtrimers)
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

# copy ${NAME}A.dal for the
# monomers, dimers, and trimer,
# since the files should be identical
for X in A B C AB BC AC ABC; do
    cp "${NAME}A.dal" "${NAME}${X}.dal"
done

