#!/bin/bash

# Ask for the sudo password at the beginning of the script

# Define the installation directories
BIN_DIR="$HOME/bin"


wget -P ~/.local/share/fonts "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip" \
&& cd ~/.local/share/fonts \
&& unzip Hack.zip \
&& rm Hack.zip \
&& fc-cache -fv


# Create directories if they do not exist
sudo mkdir -p "$BIN_DIR"
sudo chown -R $(whoami):$(whoami) "$BIN_DIR"
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$BIN_DIR"

echo 'eval "$(oh-my-posh init zsh)"' >> ~/.zshrc

