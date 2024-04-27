#!/bin/bash

# Exit on any error
set -e

# Define the installation directories
FONT_DIR=$HOME/.local/share/fonts
THEME_DIR=/etc/oh-my-posh/themes  # Custom theme directory

# Create directories if they do not exist
sudo mkdir -p $FONT_DIR
sudo mkdir -p $THEME_DIR

# Download and install Fira Code Nerd Font
echo "Downloading Fira Code Nerd Font..."
wget -qO- "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/FiraCode.zip" > FiraCode.zip
unzip FiraCode.zip -d $FONT_DIR
rm FiraCode.zip
echo "Fira Code Nerd Font installed."

# Update the font cache
fc-cache -fv

# Download and install Oh My Posh
echo "Installing Oh My Posh..."
sudo wget -qO /usr/local/bin/oh-my-posh "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64"
sudo chmod +x /usr/local/bin/oh-my-posh
echo "Oh My Posh installed."

# Download and extract themes
echo "Setting up Oh My Posh themes..."
wget -qO- "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip" > themes.zip
sudo unzip themes.zip -d $THEME_DIR
rm themes.zip
echo "Themes installed."

# Add Oh My Posh to Zsh configuration
SHELL_CONFIG="$ZDOTDIR/.zshrc"

echo "autoload -U promptinit; promptinit" >> $SHELL_CONFIG
echo "function prompt_command() {" >> $SHELL_CONFIG
echo "PROMPT='$(oh-my-posh --config $THEME_DIR/jandedobbeleer.omp.json)'" >> $SHELL_CONFIG
echo "}" >> $SHELL_CONFIG
echo "precmd_functions+=(prompt_command)" >> $SHELL_CONFIG

echo "Oh My Posh setup complete. Please restart your terminal or source your .zshrc file."
