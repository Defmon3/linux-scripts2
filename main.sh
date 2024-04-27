#!/bin/bash
echo "<<< Updating system>>>"

chmod +x ./system-setup.sh
./system-setup.sh

echo "<<< Sudo update && upgrade >>>"
sudo apt-get update -y && sudo apt-get upgrade -y

echo "<<< Installing Nala >>>"
sudo apt-get install nala  -y
sudo nala update -y

echo "<<< Installing Curl >>>"
sudo nala install curl

echo "<<< Installing oh-my-zsh >>>"
chmod +x ./ohmyzsh.sh
./ohmyzsh.sh

echo "<<< Installing sublime >>>"
chmod +x ./sublime.sh
./sublime.sh

# Speed up Ubuntu boot
# https://itsfoss.com/speed-up-ubuntu-1310/