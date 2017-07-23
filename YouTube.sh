#!/bin/bash
#
# Downloads YouTube captions and cleans them up (makes them a text file and adds punctuation)

for file in "$@"

do
  extension="${file##*.}"
  basename=`basename "$file" .$extension`
  newfile="$basename.txt"
  
# Step 1
# If you don't have the audio file remove "skip download" options

# youtube-dl --write-auto-sub "$@"

youtube-dl --write-auto-sub --skip-download "$@"

# Step 2

aeneas_convert_syncmap *.vtt out.srt

## Step #3
# remove angle brackets

sed -i 's/<[^<>]*>//g' out.srt

## Step #4 
# Remove spaces 

sed -i '/^\s*$/d' out.srt

# Step #5
# Remove all lines that begin with a zero (video must be < 1 hour)

sed -i '/^0/ d' out.srt

# Step #6 
# Delete every odd number line

sed -i -n '1~2!p' out.srt

# Step Step #7 
# Remove line breaks

sed -i ':a;N;$!ba;s/\n/ /g' out.srt

# Step #8
# Clean up unicode error related to angle brackets

sed -i 's/&gt;/>/g' out.srt

# Step #9
# Uncapitalize each word and then capitalize first word in each sentence (for some foreign language files)

# sed -i 's/\(.*\)/\L\1/' out.txt
# sed -i 's/\.\s*./\U&\E/g' out.txt

# Step #10 replace CONTENTS section of punctuator with transcript
# Replace contents of punctuator

sed -ri "s/CONTENTS/$(cat out.srt)/g" ./punctuate.sh

# Step #11 Run punctuator

./punctuate.sh

# Step #12 Merge TEXT file into VTT file

mv *.txt *.vtt

# Step # 13 Rename the VTT file (remove number IDs)

rename 's/-.*.en//' *.vtt
# rename 's/.mp4/.en.mp4/' *.mp4
# rename 's/-.*.en//' *.mp4

# Step #14 Rename VTT as a TXT File

rename 's/.vtt/.txt/g' *.vtt

# Step # 15 Clean Up Punctuate script (remove transcript data)

sed -i 's/"text=.*"/"text=CONTENTS"/g' ./punctuate.sh

# Step # 16 Clean up Transcript

sed -i 's/\[,\ Music\ \]/\[\ Music\ \]/g' *.txt
sed -i 's/\[\ Music,\ \]/\[\ Music\ \]/g' *.txt

# #Step #17 Remove SRT file

rm out.srt

done
