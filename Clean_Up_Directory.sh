#!/bin/bash
# Joseph Polizzotto
# move files to their own directories and Punctuate these files

for d in */; 

do

rm "$d"HONORIFICS
rm "$d"Segment_Only.sh
rm "$d"Segment+Align.sh
rm "$d"sentence-boundary.pl
rm "$d"Segment_Directory.sh
rm "$d"Clean_Up_Directory.sh

mv "$d" ../Completed

done