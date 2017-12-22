#!/bin/bash
# Joseph Polizzotto
# 408-996-6044

# check dependencies 

set -e

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

# Check if caption tracks were downloaded

count=`ls -1 *.vtt 2>/dev/null | wc -l`

if [ $count != 0 ] ; then

echo -e "Done"

else

	touch log2.txt

      echo -e "\nauto_captions_log for transcripts downloaded at "$(date +%H:%M/%m/%d/%Y) | cat - log2.txt > temp && mv temp log2.txt

   echo -e "\nThese videos did not contain any caption tracks:" >> log2.txt
    
    echo -e "\033[31m" >> log2.txt
    
    grep "WARNING: Couldn't find automatic captions for" ./log.txt >> log2.txt
   
   sed -i "s/WARNING: Couldn't find automatic captions for /\https:\/\/youtu.be\//" log2.txt
   
   echo -e "\033[0m" >> log2.txt
   
   echo -ne $(cat ./log2.txt | sed  's/$/\\n/' | sed 's/ /\\a /g')
   
   mv ./log2.txt ./log.txt
   
# Clean Up Color Codes in Report
sed -i 's/\x1b\[[0-9;]*[a-zA-Z]//g' log.txt
sed -i 's/\\033//g' log.txt
sed -i 's/\[32m//g' log.txt
sed -i 's/\[33m//g' log.txt
sed -i 's/\[0m//g' log.txt

# delete empty white space at top of document
sed -i '/./,$!d' log.txt

mv ./log.txt log_$(date +%H%M:%m:%d:%Y).txt
    
    exit 1
    
fi

# Print Warning message about overriding files in 'Completed' folder
# read -p "Transcripts will be placed in a 'Completed' folder. Please check that you will not be overriding duplicate files. Click 'Y' to continue or 'N' to abort." -n 1 -r
# echo    # (optional) move to a new line
# if [[ ! $REPLY =~ ^[Yy]$ ]]
# then
#	rm -r ./*.vtt
#    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
# fi

./playlist.sh

done