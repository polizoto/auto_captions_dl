#!/bin/bash
# Joseph Polizzotto
# move files to their own directories

PUNCTUATE="./punctuate/*"

for file in $PUNCTUATE
do
  dir=${file%.*}
  mkdir "$dir"
 newfile=$dir
  mv "$file" "$newfile"
  find ./punctuate -type d -exec cp punctuate.sh {} \;
 find ./punctuate -type d -exec cp punctuate_2.sh {} \;

done