#!/bin/bash
#
# punctuator script

for d in */; 

do

curl -sd "text=CONTENTS" http://bark.phon.ioc.ee/punctuator --progress-bar 2>&1 > out.vtt

done

