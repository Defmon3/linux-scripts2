#!/bin/bash

# Ask for the sudo password at the beginning of the script

# Define the installation directories
FONT_DIR="$HOME/.local/share/fonts"
THEME_DIR="$HOME/.local/oh-my-posh/themes"  # Corrected theme directory

# Create directories if they do not exist
sudo mkdir -p "$FONT_DIR"
sudo mkdir -p "$THEME_DIR"
sudo chown -R $(whoami):$(whoami) "$FONT_DIR"
sudo chown -R $(whoami):$(whoami) "$THEME_DIR"

# Download and install Fira Code Nerd Font
echo "Downloading Fira Code Nerd Font..."
wget -qO Hack.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip"
unzip Hack.zip -d "$FONT_DIR"
rm Hack.zip
echo "Hack Code Nerd Font installed."

# Update the font cache
fc-cache -fv

# Download and install Oh My Posh
curl -s https://ohmyposh.dev/install.sh | bash -s