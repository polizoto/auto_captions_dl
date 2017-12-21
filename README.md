# auto_captions_dl
Download the auto captions file from a YouTube video, convert to plain text, and add punctuation.

## Dependencies

youtube-dl:
`brew install youtube-dl`

rename
`brew install rename`

sed
`brew install gnu-sed --with-default-names`

pcregrep
`brew install pcre`

## Usage
1) Download or clone auto_captions_dl repository

2) Open terminal (Mac)

3) CD to directory with scripts. (all scripts must be in the same directory.)

4) Make the scripts executable (one-time-only step)

`chmod +x path/to/playlist.sh`

`chmod +x path/to/punctuate.sh` etc.

5) Enter path to playlist.sh script; then add the URL to the YouTube video or playlist.

`path/to/playlist.sh YouTube_URL`

6) You will receive a transcript(s) of the YouTube video(s) in a "Completed" folder along with a log file that reports the following info: 1) Edited CCs downloaded 2) Auto CCs downloade and 3) Videos that had no CC track.

## Notes

- Scripts can be used on a single YouTube video or a playlist.
- Remove `--skip download` from `playlist.sh` if you wish to download the YouTube video along with the CCs 
- These scripts have been designed for use on a Mac. For scripts that will work on a PC, see this repo: https://github.com/polizoto/auto_captions_dl_pc
- For more information, please contact jpolizzotto@htctu.net
