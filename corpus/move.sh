#!/bin/bash

# Usage: bash move.sh folder
# Extract only left channel

dir=$1

for file in "$dir"/*.wav; 
do
	cp $file ../force-aligned/"$dir"
done