# auto_captions_dl
Download the auto captions file from a YouTube video, convert to plain text, and add punctuation.

## Dependencies

Python 2.7 + (should be installed already on a Mac)

Homebrew: https://brew.sh/
- we recommend installing this package manager for macOS, since it makes installing YouTube-dl and Aeneas easier.
- paste the following code into a mac Terminal and press Return
`/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

youtube-dl: https://rg3.github.io/youtube-dl/
`brew install youtube-dl`

rename
`brew install rename`

sed
`brew install gnu-sed --with-default-names`

Aeneas: https://github.com/readbeyond/aeneas
- To install Aeneas and all its dependencies on macOS X 10.7 and up, we recommend the aeneas-installer method provided by Daniel Bair (https://github.com/danielbair/aeneas-installer_)
  - Download the repository and extract the Mac_OSX_Installer folder
  - cd to Mac_OSX_Installer folder
  - run `build_setup.sh`
  - run `build_packages.sh`

N.B. You may also be prompted to run `brew install ffmpeg`

(The Aeneas portion of the script is for converting the VTT file from YouTube to SRT format as an intermediate step.)

## Usage
1) Download or clone auto_captions_dl repository

2) Open terminal (Mac)

3) CD to directory with scripts. (YouTube.sh and Punctuate.sh scripts must be in the same directory.)

4) Make the scripts executable (one-time-only step)

`chmod +x ./YouTube.sh`

`chmod +x ./punctuate.sh`

5) Enter path to YouTube.sh script and add the URL to the YouTube video.

`YouTube.sh YouTube_URL`

6) You will receive a MP4 of the YouTube video and a TXT file of the Auto CCs from the YouTube video.

## Notes

- These scripts have been designed for use on a Mac. For scripts that will work on a PC, see this repo: https://github.com/polizoto/auto_captions_dl_pc
- For more information, please contact jpolizzotto@htctu.net
