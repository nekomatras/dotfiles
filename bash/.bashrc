#!/bin/bash
[[ $- != *i* ]] && return

### Aliases
#
alias ls='ls --color=auto -lh'
alias grep='grep --color=auto'
#
alias mc='mc -S ~/.config/mc/modarin256root-defbg.ini'
#
alias proton="~/.local/share/Steam/steamapps/common/Proton\ 9.0\ \(Beta\)/proton run"
alias guitar_pro='wine ~/.wine/drive_c/Program\ Files/Arobas\ Music/Guitar\ Pro\ 8/GuitarPro.exe'

###
PS1='[\u@\h \W]\$ '
