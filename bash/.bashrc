#!/bin/bash
[[ $- != *i* ]] && return

ELECTRON_FLAGS="--enable-features=WaylandWindowDecorations --ozone-platform-hint=auto"

### Aliases
#
alias ls='ls --color=auto -lh'
alias grep='grep --color=auto'
#
alias mc='mc -S ~/.config/mc/modarin256root-defbg.ini'
#
alias proton="~/.local/share/Steam/steamapps/common/Proton\ 10.0/proton run"
alias guitar_pro='wine ~/.wine/drive_c/Program\ Files/Arobas\ Music/Guitar\ Pro\ 8/GuitarPro.exe'
#
#alias chromium='chromium $ELECTRON_FLAGS'
#alias code='code $ELECTRON_FLAGS'
#alias slack='slack $ELECTRON_FLAGS'
###
PS1='[\u@\h \W]\$ '
