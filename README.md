# auto_captions_dl
Download the auto captions file from a YouTube video, convert to plain text, and add punctuation.

## Dependencies

Python 2.7 + (should be installed already on a Mac)

Aeneas: https://github.com/readbeyond/aeneas
1. To install Aeneas and all its dependencies on macOS X, we recommend the all-in-one installer provided by Daniel Bair: https://github.com/sillsdev/aeneas-installer/releases. The all-in-one installer will install Homebrew, a package manager for macOS, which will be used to install other dependences for these scripts.

2. If the first method does not work, we recommend using the steps Daniel Bair has provided at this github repo: https://github.com/danielbair/aeneas-installer_. These steps will also install Homebrew. Follow these steps (from the ReadMe document):
  - Download the repository and extract the Mac_OSX_Installer folder
  - cd to Mac_OSX_Installer folder
  - run `build_setup.sh`
  - run `build_packages.sh`

N.B. This second method does not install FFMPEG, an Aeneas dependency, so you will be prompted to run `brew install ffmpeg`

(The Aeneas portion of the script is for converting the VTT file from YouTube to SRT format as an intermediate step.)

youtube-dl: https://rg3.github.io/youtube-dl/
`brew install youtube-dl`

rename
`brew install rename`

sed
`brew install gnu-sed --with-default-names`

## Usage
1) Download or clone auto_captions_dl repository

2) Open terminal (Mac)

3) CD to directory with scripts. (YouTube.sh and Punctuate.sh scripts must be in the same directory.)

4) Make the scripts executable (one-time-only step)

`chmod +x path/to/YouTube.sh`

`chmod +x path/to/punctuate.sh`

5) Enter path to YouTube.sh script and add the URL to the YouTube video.

`path/to/YouTube.sh YouTube_URL`

6) You will receive a MP4 of the YouTube video and a TXT file of the Auto CCs from the YouTube video.

## Notes

- These scripts have been designed for use on a Mac. For scripts that will work on a PC, see this repo: https://github.com/polizoto/auto_captions_dl_pc
- For more information, please contact jpolizzotto@htctu.net
