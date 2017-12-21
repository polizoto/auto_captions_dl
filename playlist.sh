#!/bin/bash
# Joseph Polizzotto
# 408-996-6044

# check dependencies 

command -v youtube-dl >/dev/null 2>&1 || { echo >&2 "youtube-dl not found please install from https://rg3.github.io/youtube-dl/)"; exit 1; }

command -v rename >/dev/null 2>&1 || { echo >&2 "rename dependency not found. Please install using 'brew install rename'"; exit 1; }

command -v pcregrep >/dev/null 2>&1 || { echo >&2 "pcregrep dependency not found. Please install using 'brew install pcre'"; exit 1; }

###### SCRIPT #######

# exec > >(tee -a $HOME/desktop/youtube_test/terminal_output.txt) 2>&1

for f in "$@"
do

# Get the full file PATH without the extension
filepathWithoutExtension="${f%.*}"

echo Downloading caption tracks from YouTube...

# Download playlist
youtube-dl "$@" --yes-playlist --skip-download --write-sub --sub-lang en --write-auto-sub --output "%(title)s" >> log.txt 2>&1
echo Done

# Make a tmp directory
mkdir tmp
mkdir punctuate
mkdir Completed
# mv terminal_output.txt ./Completed
mv log.txt ./Completed

# Find Auto CC files and move to 'Punctuate' directory
pcregrep -Mnol 'Language:\ en.*\n\n' ./*.vtt . | xargs -I{} mv {} ./tmp
# grep -i -Z -r -l 'rgb(229,229,229)' --include=\*.vtt . | xargs -I{} mv {} ./punctuate

# Move all files with auto CCs to Punctuate directory for processing
count=`ls -1 *.vtt 2>/dev/null | wc -l`

if [ $count != 0 ] ; then

mv *.vtt ./punctuate

fi

if [ "$(ls -A ./tmp)" ]; then

echo "Edited CCs were downloaded...converting to plain TXT..."
# Delete lines until blank line
find ./tmp -type f -exec sed -i '1,/^$/d' {} \;

# remove angle brackets
find ./tmp -type f -exec sed -i 's/<[^<>]*>//g' {} \;

# delete lines beginning with 0
find ./tmp -type f -exec sed -i '/^0/ d' {} \;

# remove empty lines
find ./tmp -type f -exec sed -i '/^$/d' {} \;

# remove extra spaces
find ./tmp -type f -exec sed -i 's/[[:space:]]\+/ /g' {} \;

# remove line breaks
find ./tmp -type f -exec sed -i ':a;N;$!ba;s/\n/ /g' {} \;

# Change the name so that there is the title only
find ./tmp -type f -exec rename 's/.en.vtt/.txt/' {} \;

echo "Done"

# Make a list of the Edited CC tracks
cd ./tmp 

ls >> EditedCCList.txt

cd ..

# Move files back to current working directory
mv ./tmp/*.txt ./Completed

rm -r ./tmp 

else
	rm -r ./tmp
    echo "(No Edited CCs were downloaded)"

fi

if [ "$(ls -A ./punctuate)" ]; then

mkdir Punctuated

echo "Auto CCs were downloaded...converting to plain TXT..."
# Delete lines until blank line
find ./punctuate -type f -exec sed -i '1,/^$/d' {} \;

# remove angle brackets
find ./punctuate -type f -exec sed -i 's/<[^<>]*>//g' {} \;

# delete lines beginning with 0
find ./punctuate -type f -exec sed -i '/^0/ d' {} \;

# remove empty lines
find ./punctuate -type f -exec sed -i '/^$/d' {} \;

# remove extra spaces
find ./punctuate -type f -exec sed -i 's/[[:space:]]\+/ /g' {} \;

# remove line breaks
find ./punctuate -type f -exec sed -i ':a;N;$!ba;s/\n/ /g' {} \;

# Change the name so that there is the title only
find ./punctuate -type f -exec rename 's/.en.vtt/.txt/' {} \;

echo "Done"
echo "Punctuating Auto CCs..."

# copy Punctuate files
cp punctuate.sh ./punctuate
cp punctuate_2.sh ./punctuate

# Create subdirectories for all files in Punctuate folder
./punctuate_playlist.sh

rm -r ./punctuate/punctuate
rm -r ./punctuate/punctuate_2

# Move to Punctuate directory and perform Punctuate script on subdirectories
cd ./punctuate && ./punctuate_2.sh

# Go back to Home working directory
cd ..

# Make a list of the Edited CC tracks
cd ./Punctuated

ls >> PunctuatedCCList.txt

cd .. 

mv ./Punctuated/*.txt ./Completed/

rm -r ./punctuate
rm -r ./Punctuated

else
	echo "(No Auto CCs were downloaded)"
	rm -r ./punctuate

fi

# Move to Completed directory and run reports

cd ./Completed

touch report2.txt

# Add a List of Edited CCs
if [ -f "./EditedCCList.txt" ]; then

   echo -e "These Videos contained Edited CCs:" >> report2.txt
   
   cat ./EditedCCList.txt >> report2.txt
   
   sed -i 's/.txt//' report2.txt
   
   sed -i 's/EditedCCList//' report2.txt
   
   rm -r ./EditedCCList.txt
   
   else
   
   echo -e "These Videos contained Edited CCs:" >> report2.txt
   
   echo -e "No Edited CCs were downloaded" >> report2.txt
   
 fi
 
# Show which videos contained no Auto CCs or Edited CCs
if grep -q "WARNING: Couldn't find automatic captions for" ./log.txt; then

   echo -e "These videos did not contain any caption tracks:" >> report2.txt

   grep "WARNING: Couldn't find automatic captions for" ./log.txt >> report2.txt
   
   sed -i "s/WARNING: Couldn't find automatic captions for /https:\/\/youtu.be\//" report2.txt
   
   else
   
   echo -e "These videos did not contain any caption tracks:" >> report2.txt
   
   echo -e "No caption tracks were missing" >> report2.txt
   
 fi
 
# Show which videos contained Auto CCs
# PunctuatedCCList.txt
if [ -f "./PunctuatedCCList.txt" ]; then

   echo -e "These videos contained AutoCCs and were punctuated:" >> report2.txt

   cat ./PunctuatedCCList.txt >> report2.txt
   
   sed -i 's/.txt//' report2.txt
   
   sed -i 's/PunctuatedCCList//' report2.txt
   
   rm -r ./PunctuatedCCList.txt
   
   else
   
   echo -e "These videos contained AutoCCs and were punctuated:" >> report2.txt
   
   echo -e "No AutoCCs downloaded" >> report2.txt
   
 fi

# remove duplicate values in the report and remove empty lines
awk '!seen[$0]++' ./report2.txt > ./report.txt
sed -i '/^$/d' report.txt

# Add spaces between group items in the report
if grep -q "These videos did not contain any caption tracks:" ./report.txt; then

sed -i "s/These videos did not contain any caption tracks:/\nThese videos did not contain any caption tracks:\n/" report.txt

fi

if grep -q "These videos contained AutoCCs and were punctuated:" ./report.txt; then

sed -i "s/These videos contained AutoCCs and were punctuated:/\nThese videos contained AutoCCs and were punctuated:\n/" report.txt

fi

if grep -q "These Videos contained Edited CCs:" ./report.txt; then

sed -i "s/These Videos contained Edited CCs:/\nThese Videos contained Edited CCs:\n/" report.txt

fi

# Clean up files
rm -r ./report2.txt
rm -r ./log.txt

echo -e "\n**Remember to remove transcripts and 'log' file from the 'Completed' folder and delete the 'Completed' folder before running the script again**\n" >> report.txt

echo -e "\nauto_captions_log for transcripts created at "$(date +%H:%M/%m/%d/%Y) | cat - report.txt > temp && mv temp report.txt

# Display Report
cat ./report.txt

sed -i "s/\*\*Remember to remove transcripts and 'log' file from the 'Completed' folder and delete the 'Completed' folder before running the script again\*\*//" report.txt

# delete empty white space at top of document
sed -i '/./,$!d' report.txt

# delete triple blank lines at end of document
sed -i '1N;N;/^\n\n$/d;P;D' report.txt

mv ./report.txt log_$(date +%H%M:%m:%d:%Y).txt

done
