#!/bin/bash

PACKAGES=(tmux fzf curl exa <)



# Install nala first for speed and convenience
bash ./apt_installs/nala.sh

# Install the rest of the packages
yellow "<<< Installing $PACKAGES >>>"
echo $SUDOPASS | sudo -S nala install "${PACKAGES[@]}" -y > /dev/null 2>&1 || {
  echo "Failed to install $PACKAGES" >&2; exit 1;
}
