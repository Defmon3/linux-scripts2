#!/bin/bash
echo $SUDOPASS | sudo -S nala install terminator -y || { ehighlight "Failed to install Curl"; exit 1; }
mkdir -p "$HOME/.config/terminator" > /dev/null
symlinkPath="$HOME/.config/terminator/config"
dotfilePath="$HOME/.config/linux-scripts2/terminator/config"
ln -s "$dotfilePath" "$symlinkPath"
echo "Symlink created: $symlinkPath -> $(readlink -f $symlinkPath)"