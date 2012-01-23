#!/bin/bash

#V zadanem adresari nalezne vsechna avi videa a prekonvertuje je
#do 3gp. Pokud neni zadan adresar, ale soubor, zkonvertuje ten.

RES="720x480"
FORMAT="mp4"

if [ $# -ne 1 ]; then
  echo "Pouziti: avi23gp.sh [adresar | soubor]"
  exit 1
fi

#If SIGINT then skip all remainings
BREAK=0
trap 'BREAK=1' SIGINT

WHAT=$1

#Convert video file to 3gp 
function convert() {

  if [ $BREAK == 1 ]; then
    return
  fi

  if [ $# -ne 1 ]; then
    echo "Use: convert /path/to/file.avi"
    return
  fi

  if [ -e "$1.$FORMAT" ]; then
    echo "File $1.$FORMAT already exists! Skip.";
    return
  fi

  #ffmpeg -y -i $1 -vcodec mpeg4 -s $RES -r 15 -b 700k -acodec aac -strict experimental -ac 2 -ar 32000 -ab 64k -f $FORMAT "$1.$FORMAT"
  ffmpeg -i "$1" -s 480x320 -vcodec mpeg4 -acodec aac -strict experimental -ac 1 -ar 16000 -r 13 -ab 32000 -aspect 3:2 "$1.$FORMAT"
}

#Parameter is single file
if [ -f $WHAT ]; then
  convert "$WHAT"

#Parameter is directory
elif [ -d $WHAT ]; then

  #Remove last / if exists
  WHAT=`echo "$WHAT" | sed 's/\/$//'`

  for FILE in $WHAT/*[aA][vV][iI]; do
    convert "$FILE"
  done

fi
