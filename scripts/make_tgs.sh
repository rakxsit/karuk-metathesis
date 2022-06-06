#!/bin/bash

# Usage: bash make_tgs.sh
# Make TextGrids for all the subfolders in the current folders
# TextGridMaker.praat should be in the same folder

for folder in */;
do
	/Applications/Praat.app/Contents/MacOS/Praat --run TextGridMaker.praat "$(realpath $folder)" "wav";
done