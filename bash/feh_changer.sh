#!/bin/bash

#1st=Wallpapper folder
#2nd=Change period in seconds

if [ "$#" -lt 2 ]; then
    >&2 echo "Error: Illegal number of arguments"
    exit -1
fi

changeWallpaper()
{
    pic=$(find "${commandline_args[0]}" -maxdepth 1 -mindepth 1 | shuf -n1)
    feh --bg-scale $pic
}

commandline_args=("$@")

while true
do
  changeWallpaper
  sleep $2
done
