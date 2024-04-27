#!/bin/bash
echo "<<< Updating system >>>"

chmod +x ./system-setup.sh
./system-setup.sh || { echo "System setup failed"; exit 1; }

echo "<<< Sudo update && upgrade >>>"
sudo apt-get update -y >/dev/null 2>&1 || { echo "Update failed"; exit 1; }
sudo apt-get upgrade -y >/dev/null 2>&1 || { echo "Upgrade failed"; exit 1; }

echo "<<< Installing Nala >>>"
sudo apt-get install nala -y || { echo "Failed to install Nala"; exit 1; }
sudo nala update -y

echo "<<< Installing Curl >>>"
sudo nala install curl -y || { echo "Failed to install Curl"; exit 1; }

echo "<<< Installing oh-my-zsh >>>"
chmod +x ./ohmyzsh.sh
./ohmyzsh.sh || { echo "oh-my-zsh installation failed"; exit 1; }

echo "<<< Installing sublime >>>"
chmod +x ./sublime.sh
./sublime.sh || { echo "Sublime installation failed"; exit 1; }

# Speed up Ubuntu boot
# https://itsfoss.com/speed-up-ubuntu-1310/
