#!/bin/bash

# Usage: bash mfa_mult.sh
# Align multiple folders

# First argument should be folder
for folder in *;
do
	/opt/montreal-forced-aligner/bin/mfa_validate_dataset "$folder" ../dictionary.txt;
	/opt/montreal-forced-aligner/bin/mfa_align "$folder" ../dictionary.txt english ../output/"$folder";
done