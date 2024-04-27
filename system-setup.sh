# this script is used to setup the system for the first time
chmod +x ./ensure-xdg-config-home.sh
./ensure-xdg-config-home.sh

ZSH="$XDG_CONFIG_HOME/oh-my-zsh"
export ZSH

ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH ZDOTDIRls