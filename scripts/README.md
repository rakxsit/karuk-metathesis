# Scripts

- This folder contains scripts for 
1) Getting the Karuk data into the right form for forced alignment
1) Creating the metadata
1) Running the Montreal Forced Aligner
1) Adding the tiers and segmentation that we need
1) Reshaping the data
1) Analyzing the data

- The scripts should be carried out in the following order
1) Download audio files and XML metadata from http://linguistics.berkeley.edu/~karuk/
1) get_karuk.ipynb : Extract metadata from the XML file and create textgrids
1) mfa_mult.sh : Must have the Montreal Forced Aligner (https://montreal-forced-aligner.readthedocs.io/en/latest/ ) downloaded . Run on relevant folders to align audio files
1) segment_targets.ipynb : Add tiers and segment the target phones we want to look at
1) reshape_data.ipynb : Reshape the data for the purposes of analysis and visualization
1) analyze.R : Analyze and visualize the data