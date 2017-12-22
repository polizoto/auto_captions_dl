#!/bin/bash
# Joseph Polizzotto
# move files to their own directories and Punctuate these files

for d in */; 

do

sed -ri "s@CONTENTS@$(cat "$d"*.txt)@g" "$d"punctuate.sh

echo punctuating "$d"...

"$d"punctuate.sh

sed -i 's@"text=.*"@"text=CONTENTS"@g' "$d"punctuate.sh

mv out.vtt "$d"*.txt

echo Done

mv "$d"*.txt ../Punctuated/

done