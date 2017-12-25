# auto_captions_dl
Download the auto captions file from a YouTube video, convert to plain text, and add punctuation.

## Dependencies

youtube-dl:
`brew install youtube-dl`

rename:
`brew install rename`

sed:
`brew install gnu-sed --with-default-names`

pcregrep:
`brew install pcre`

## Usage
1) Download or clone auto_captions_dl repository

2) Open terminal (Mac)

3) CD to directory with scripts.

4) Make scripts executable (one-time step)

`chmod +x ./YouTube.sh`

`chmod +x ./playlist.sh`

`chmod +x ./punctuate.sh`

`chmod +x ./punctuate_playlist.sh`

`chmod +x ./punctuate_2.sh`

5) Type `./YouTube.sh`; then add the URL to the YouTube video/ playlist:

`./YouTube.sh YouTube_video/playlist_URL`

6) You will receive a transcript(s) of the YouTube video(s) in a "Transcripts" folder. A log file will report the following info: 1) Edited CCs downloaded 2) Videos that had no CC track and 3) Auto CCs downloaded.

## Notes

- If you don't have Homebrew installed on your MacOS (which is recommended for installing dependencies), you can install it by pasting the following into a terminal and pressing Enter: 

`/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

- Remove `--skip download` from `YouTube.sh` if you wish to download the YouTube video along with the CCs 
- These scripts have been designed for use on a Mac. For scripts that will work on a PC, see this repo: https://github.com/polizoto/auto_captions_dl_pc
- For more information, please contact jpolizzotto@htctu.net
