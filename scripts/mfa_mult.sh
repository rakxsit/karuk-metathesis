#!/bin/bash

# Usage: bash mfa_mult.sh directory
# Align multiple folders within a directory
dir=$1

# First argument should be directory
for folder in "$dir"/*/;
do
	/opt/montreal-forced-aligner/bin/mfa_validate_dataset "$folder" dictionary.txt;
	/opt/montreal-forced-aligner/bin/mfa_align "$folder" dictionary.txt english output/"$folder";
done