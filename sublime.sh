#!/usr/bin/env bash

# Ensure Nala is installed
if ! command -v nala &> /dev/null
then
    echo "Nala is not installed. Installing Nala..."
    sudo apt update && sudo apt install nala -y
fi

# Import the Sublime Text repository GPG key
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null

# Add the Sublime Text repository
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Update package lists with Nala
sudo nala update

# Install Sublime Text with Nala
sudo nala install sublime-text -y
