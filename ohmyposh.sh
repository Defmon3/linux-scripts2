#!/bin/zsh

# Define the install directory
INSTALL_DIR="$HOME/.local/bin"
mkdir -p $INSTALL_DIR

# Download the latest Oh My Posh executable
curl -Lo $INSTALL_DIR/oh-my-posh https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64

# Make the binary executable
chmod +x $INSTALL_DIR/oh-my-posh

# Check if the local bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> $ZDOTDIR/.zshrc
    export PATH="$HOME/.local/bin:$PATH"
fi
