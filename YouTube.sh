#!/bin/bash
#
# Downloads YouTube captions and cleans them up

for file in "$@"
do
  extension="${file##*.}"
  basename=`basename "$file" .$extension`
  newfile="$basename.txt"
  
# Step 1
youtube-dl --write-auto-sub --skip-download "$@"

# Step 2

aeneas_convert_syncmap *.vtt out.srt

# Step 3
# Rename a file

rename 's/.srt/.txt/g' *.srt

## Step #3
# remove angle brackets

sed -i 's/<[^<>]*>//g' out.txt

## Step #4 
# Remove spaces 

sed -i '/^\s*$/d' out.txt

# Step #5
# Remove all lines that begin with a zero (video must be < 1 hour)

sed -i '/^0/ d' out.txt

# Step #6 
# Delete every odd number line

sed -i -n '1~2!p' out.txt

# Step Step #7 
# Remove line breaks

sed -i ':a;N;$!ba;s/\n/ /g' out.txt

# Step #8
# Clean up unicode error related to angle brackets

sed -i 's/&gt;/>/g' out.txt

# Uncapitalize each word and then capitalize first word in each sentence 

# sed -i 's/\(.*\)/\L\1/' out.txt
# sed -i 's/\.\s*./\U&\E/g' out.txt

# Step #9
# Remove VTT file

rm *.vtt

done