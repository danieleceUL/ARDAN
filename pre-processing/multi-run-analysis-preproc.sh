#!/bin/bash
# This script is used to combine the horizontal and vertical csv files for a multi-run
# into a single file for each type of data.
# The script takes one argument, the directory containing the subdirectories for each run.
# The script will create a new directory called combination in the passed directory and
# copy the horizontal and vertical csv files from each run into the combination directory.
# The script will then concatenate the horizontal and vertical csv files into a single file
# Author: Daniel Jakab, 18th July 2024
PASSED=$1
if [[ ! -d $PASSED ]]; then
    echo "$PASSED is not a directory"
    exit 1
fi

results=./results
if [ ! -e "$results" ];
then
    ln -s "$PASSED" "$results"
fi
mkdir "$PASSED"/combination
# Copy the common files from the first run to the combination directory
substring="exp_1"
cp "$results"/"$substring"*/tt_img.png "$PASSED"/combination
cp "$results"/"$substring"*/roi.mat "$PASSED"/combination
cp "$results"/"$substring"*/ROIMask.png "$PASSED"/combination

results=./results/
fd=$(find "$results" -iname "horizontal.csv")
printf "%s\n" "$fd"
declare -i i=1
for file in $fd; do
    cp "$file" "$PASSED"/combination/horizontal-"$i".csv
    i+=1
done
fd=$(find "$results" -iname "vertical.csv")
printf "%s\n" "$fd"
declare -i i=1
for file in $fd; do
    cp "$file" "$PASSED"/combination/vertical-"$i".csv
    i+=1
done
cd "$PASSED"/combination

# Concatenate the horizontal and vertical csv files into a single file
cat horizontal-*.csv > horizontal.csv
cat vertical-*.csv > vertical.csv

# Remove the individual csv files
rm horizontal-*.csv
rm vertical-*.csv
