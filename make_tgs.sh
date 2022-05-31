#!/bin/bash

# Usage: bash make_tgs.sh
# Make TextGrids for all the subfolders in the current folders

### Need to add lines to fix the fact that Praat changes periods in file names to underscores

for folder in *;
do
	/Applications/Praat.app/Contents/MacOS/Praat --run /Users/Raksit/Documents/Documents/Linguistics/Scripts/Praat/TextGridMaker.praat $(realpath $folder) "wav";
done