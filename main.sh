#!/bin/bash

# Function to highlight text
highlight() {
    echo -e "\033[1m\033[43m$1\033[0m"
}

ehighlight() {
    echo -e "\033[1m\033[41m$1\033[0m"
}


# Main script begins
highlight "<<< Updating system >>>"

chmod +x ./system-setup.sh
./system-setup.sh || { ehighlight "System setup failed"; exit 1; }

highlight "<<< Sudo update && upgrade >>>"
sudo apt-get update -y >/dev/null 2>&1 || { ehighlight "Update failed"; exit 1; }
sudo apt-get upgrade -y >/dev/null 2>&1 || { ehighlight "Upgrade failed"; exit 1; }

highlight "<<< Installing Nala >>>"
sudo apt-get install nala -y || { ehighlight "Failed to install Nala"; exit 1; }
sudo nala update

highlight "<<< Installing Curl >>>"
sudo nala install curl -y || { ehighlight "Failed to install Curl"; exit 1; }

highlight "<<< Installing oh-my-zsh >>>"
chmod +x ./ohmyzsh.sh
./ohmyzsh.sh || { ehighlight "oh-my-zsh installation failed"; exit 1; }

highlight "<<< Installing Sublime >>>"
chmod +x ./sublime.sh
./sublime.sh || { ehighlight "Sublime installation failed"; exit 1; }

# Speed up Ubuntu boot
# https://itsfoss.com/speed-up-ubuntu-131
