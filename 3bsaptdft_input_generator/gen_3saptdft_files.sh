#!/bin/bash

# Utility script to generate all necessary files
# for running 3SAPTDFT. User need only prepare
# ${NAME}*.dal files, corr file, ${NAME}P.data file,
# and trimer.info file with the following
# scripts/programs present in the working directory:
#
# (1) gen_trimer_cnf, (2) add_coords_to_mol.sh
#
# - John W. Melkumov

MAIN_SAPT_DIR=/data/melkumov/SAPT2020.1

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

# check if dimer.cnf file exists
# if not throw error 'dimer.cnf not found.'
if [ -f "dimer.cnf" ]; then
    continue
else
    echo 'dimer.cnf file not found.'
    exit
fi

###############################################

# run gen_trimer_cnf (no arguments necessary)
# with trimer.info present in working directory
# this will generate trimer.cnf
./gen_trimer_cnf

# create dimer input files
$MAIN_SAPT_DIR/misc/daltutil/createinputs $NAME $TYPE $BASIS

# run createtrimers from $SAPTDIR/misc/daltutils/
# this will generate trimer *.dal and *.mol files
$MAIN_SAPT_DIR/misc/daltutil/createtrimers $NAME 0 $BASIS

# run add_coords_to_mol.sh with NAME argument
# to add coordinates to all mol files (they are
# all 0 after createtrimers)
./add_coords_to_mol.sh $NAME

# check if ${NAME}C.dal file exists
# if not, copy ${NAME}A.dal to C
# as there is no difference
if [ -f "${NAME}C.dal" ]; then
    cp "${NAME}A.dal" "${NAME}C.dal" 
    continue
else
    exit
fi

for X in A B C AB BC AC ABC; do
    mv "modified_${NAME}${X}.mol" "${NAME}${X}.mol" 
done 
