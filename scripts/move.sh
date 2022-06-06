#!/bin/bash

# Usage: bash move.sh folder
# Moves files to a force-aligned folder 

dir=$1

for file in "$dir"/*.wav; 
do
	cp $file ../force-aligned/"$dir"
done