#!/bin/bash
# Joseph Polizzotto
# Script used in captioning workflow (playlists)
# This script has been tested to work on MacOS; please contact me for any questions about use on other platforms
# This script should be run after each sentence has been placed on its own line (use sentenceboundary.pl script)
# 408-996-6044

# check dependencies 
command -v aeneas_execute_task >/dev/null 2>&1 || { echo >&2 "aeneas_execute_task not found please install from https://github.com/readbeyond/aeneas/blob/master/wiki/INSTALL.md)"; exit 1; }

command -v rename >/dev/null 2>&1 || { echo >&2 "rename dependency not found. Please install using 'brew install rename'"; exit 1; }
 
###### SCRIPT #######

exec > >(tee -a $HOME/desktop/youtube_test/log.txt) 2>&1

for f in ./
do
# Get the full file PATH without the extension
filepathWithoutExtension="${f%.*}"

# Make a tmp directory
mkdir tmp
mkdir punctuate

# Add Transcripts directory if missing
if [ ! -d ./Transcripts ]; then

mkdir Transcripts

fi

mv log.txt ./Transcripts

# Find Auto CC files and move to 'Punctuate' directory
pcregrep -Mnol 'Language:\ en.*\n\n' ./*.vtt . | xargs -I{} mv {} ./tmp
# grep -i -Z -r -l 'rgb(229,229,229)' --include=\*.vtt . | xargs -I{} mv {} ./punctuate

# Move all files with auto CCs to Punctuate directory for processing
count=`ls -1 *.vtt 2>/dev/null | wc -l`

if [ $count != 0 ] ; then

mv *.vtt ./punctuate

fi

# Find videos and move them
count=`ls -1 *.mp4 2>/dev/null | wc -l`
	
if [ $count != 0 ] ; then

mv ./*.mp4 ./Transcripts

fi

if [ "$(ls -A ./tmp)" ]; then

# Change the name so that there is the title only
find ./tmp -type f -exec rename 's/.en.vtt/.txt/' {} \;

# Make a list of the Edited CC tracks
cd ./tmp 

ls >> EditedCCList.txt

sed -i 's/.txt//' EditedCCList.txt

sed -i 's/EditedCCList//' EditedCCList.txt

# Remove empty lines
sed -i '/^$/d' EditedCCList.txt

echo '\033[32m' | cat - EditedCCList.txt > temp && mv temp EditedCCList.txt

echo "\033[0m" >> EditedCCList.txt

cd ..

mv ./tmp/EditedCCList.txt ./Transcripts

echo -e "Converting Edited CCs to plain TXT..."

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

echo -e "Done"

# Move files back to current working directory
mv ./tmp/*.txt ./Transcripts

rm -r ./tmp 

else
	rm -r ./tmp

fi

if [ "$(ls -A ./punctuate)" ]; then

mkdir Punctuated

# Change the name so that there is the title only
find ./punctuate -type f -exec rename 's/.en.vtt/.txt/' {} \;

# Make a list of the Edited CC tracks
cd ./punctuate

ls >> PunctuatedCCList.txt

sed -i 's/.txt//' PunctuatedCCList.txt

sed -i 's/PunctuatedCCList//' PunctuatedCCList.txt

# remove empty lines
sed -i '/^$/d' PunctuatedCCList.txt

# Add Yellow color code for Auto CCs
echo '\033[33m' | cat - PunctuatedCCList.txt > temp && mv temp PunctuatedCCList.txt

# echo "\033[0m" >> PunctuatedCCList.txt

cd ..

mv ./punctuate/PunctuatedCCList.txt ./Transcripts

# Print Message
echo -e "Converting Auto CCs to plain TXT..."

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

echo -e "Done"
echo -e "Punctuating transcripts..."

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

# add punctation to end of document
find ./Punctuated -type f -exec sed -i 's/\([a-zA-Z]\)$/\1./g' {} \;

mv ./Punctuated/*.txt ./Transcripts/

rm -r ./punctuate
rm -r ./Punctuated

else
	rm -r ./punctuate

fi

# Move to Completed directory and run reports

cd ./Transcripts

touch report2.txt

# Add a List of Edited CCs
if [ -f "./EditedCCList.txt" ]; then

   echo -e "\nThese Videos contained Edited CCs:" >> report2.txt
   
   cat ./EditedCCList.txt >> report2.txt
   
   rm -r ./EditedCCList.txt
   
   else
   
   echo -e "\nThese Videos contained Edited CCs:\n" >> report2.txt
   
   echo -e "No Edited CCs were downloaded" >> report2.txt
   
   sed -i "s/No Edited CCs were downloaded/\nNo Edited CCs were downloaded\n/" report2.txt
   
 fi
 
# Show which videos contained no Auto CCs or Edited CCs
if grep -q "WARNING: Couldn't find automatic captions for" ./log.txt; then

   echo -e "\nThese videos did not contain any caption tracks:" >> report2.txt

  echo -e "\033[31m" >> report2.txt

   grep "WARNING: Couldn't find automatic captions for" ./log.txt >> report2.txt
   
   sed -i "s/WARNING: Couldn't find automatic captions for /\https:\/\/youtu.be\//" report2.txt
   
   echo -e "\033[0m" >> report2.txt
   
   else
   
   echo -e "These videos did not contain any caption tracks:" >> report2.txt
   
   echo -e "\033[32m\nNo caption tracks were missing \033[0m\n" >> report2.txt
   
 fi
 
# Show which videos contained Auto CCs
# PunctuatedCCList.txt
if [ -f "./PunctuatedCCList.txt" ]; then

   echo -e "These videos contained AutoCCs and were punctuated:" >> report2.txt

   cat ./PunctuatedCCList.txt >> report2.txt
   
   # echo "\n" >> report2.txt
   
   rm -r ./PunctuatedCCList.txt
   
   else
   
   echo -e "\nThese videos contained AutoCCs and were punctuated:\n" >> report2.txt
   
   echo -e "\nNo AutoCCs downloaded\n" >> report2.txt
   
 fi

# remove duplicate values in the report and remove empty lines
awk '!seen[$0]++' ./report2.txt > ./report.txt
sed -i '/^$/d' report.txt

# Add spaces between group items in the report

if grep -q "No AutoCCs downloaded" ./report.txt; then

sed -i "s/No AutoCCs downloaded/\nNo AutoCCs downloaded/" report.txt

fi

if grep -q "No Edited CCs were downloaded" ./report.txt; then

sed -i "s/No Edited CCs were downloaded/\nNo Edited CCs were downloaded\n/" report.txt

fi

if grep -q "No caption tracks were missing" ./report.txt; then

sed -i "s/No caption tracks were missing/No caption tracks were missing\n/" report.txt

fi

# Display error message in report if it exists

if grep -q "ERROR:" ./log.txt; then

echo -e "\033[39m" >> report.txt

echo -e "YouTube-dl Error Messages:\033[0m" >> report.txt

echo -e "\033[31m" >> report.txt

grep "ERROR:" ./log.txt >> report.txt

sed -i "s/ERROR: /ERROR: \https:\/\/youtu.be\//" report.txt
 
fi

# Clean up files
rm -r ./report2.txt
rm -r ./log.txt

echo -e "\nauto_captions_log for transcripts downloaded at "$(date +%H:%M/%m/%d/%Y)"\n" | cat - report.txt > temp && mv temp report.txt

# Add New line to end of the report
echo "" >> report.txt

# Display Report
echo -ne $(cat ./report.txt | sed  's/$/\\n/' | sed 's/ /\\a /g')

# Clean Up Color Codes in Report
sed -i 's/\x1b\[[0-9;]*[a-zA-Z]//g' report.txt
sed -i 's/\\033//g' report.txt
sed -i 's/\[32m//g' report.txt
sed -i 's/\[33m//g' report.txt
sed -i 's/\[0m//g' report.txt

# delete empty white space at top of document
sed -i '/./,$!d' report.txt

# delete triple blank lines at end of document
sed -i '1N;N;/^\n\n$/d;P;D' report.txt

mv ./report.txt ../

cd ..

if [ ! -d ./Logs ]; then

mkdir Logs

fi

mv ./report.txt ./Logs

mv ./Logs/report.txt ./Logs/auto_caption_log_$(date +%H%M:%m:%d:%Y).txt

done