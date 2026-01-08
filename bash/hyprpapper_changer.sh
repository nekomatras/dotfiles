#!/bin/bash

#1st=Wallpapper folder
#2nd=Change period in seconds
#3th+=Names of monitors



if [ "$#" -lt 3 ]; then
    >&2 echo "Error: Illegal number of arguments"
    exit -1
fi

checkHyprpaperCommandResult()
{
  if [ "$1" -ne "ok" ]
  then
    killall hyprpaper
    hyprpaper & disown
  fi
}

changeWallpaper()
{
  unload=$(hyprctl hyprpaper unload all)
  checkHyprpaperCommandResult $unload
  for monitor in "${commandline_args[@]:2}"
  do
    pic=$(find "${commandline_args[0]}" -maxdepth 1 -mindepth 1 | shuf -n1)
    preload=$(hyprctl hyprpaper preload $pic)
    checkHyprpaperCommandResult $preload
    load=$(hyprctl hyprpaper wallpaper "$monitor, $pic")
    checkHyprpaperCommandResult $load
    echo "$monitor:$pic"
  done
}

commandline_args=("$@")

hyprpaper & disown
while true
do
  changeWallpaper
  sleep $2
done
