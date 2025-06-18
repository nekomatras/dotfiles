#!/bin/bash
[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ -z $DISPLAY ]] && [[ $(tty) =~ ^/dev/tty[0-9]+$ ]]; then
    alias | cut -d '=' -f1 | awk '{print $2}' >> ~/.cache/dmenu_run
    sleep 1 && startx
fi

export PATH=$PATH:/opt/clion-2024.1/bin
export STEAM_COMPAT_DATA_PATH=~/.local/share/Steam/steamapps/compatdata
export STEAM_COMPAT_CLIENT_INSTALL_PATH=~/.local/share/Steam/steamapps/compatdata
export EDITOR=vim
