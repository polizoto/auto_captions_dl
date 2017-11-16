# auto_captions_dl
Download the auto captions file from a YouTube video, convert to plain text, and add punctuation.

## Dependencies
Python 2.7 + (should be installed already on a Mac)

sed, rename, mv (should be installed already on a Mac)

youtube-dl: https://rg3.github.io/youtube-dl/

Aeneas: https://github.com/readbeyond/aeneas

N.B. we recommend brew installation for Mac: https://github.com/danielbair/homebrew-tap

(The Aeneas portion of the script is for converting the VTT file from YouTube to SRT format as an intermediate step.)

## Usage
1) Open terminal (Mac)

2) CD to directory with scripts. (YouTube.sh and Punctuate.sh scripts must be in the same directory.)

3) Enter path to YouTube.sh script and add the URL to the YouTube video.

`YouTube.sh YouTube_URL`

4) You will receive a MP4 of the YouTube video and a TXT file of the Auto CCs from the YouTube video.

## Notes

These scripts have been designed to work on a Macintosh computer. For scripts that work on a PC, please contact Joseph Polizzotto at jpolizzotto@htctu.net.

