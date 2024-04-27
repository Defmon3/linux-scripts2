#!/usr/bin/env bash

# Ensure XDG_CONFIG_HOME is set, default to ~/.config if not set
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Define where Oh My Zsh and its custom plugins should be installed
ZSH_CUSTOM="$XDG_CONFIG_HOME/oh-my-zsh/custom"

# Create the directories if they do not exist
mkdir -p "$ZSH_CUSTOM/plugins"

# Install Zsh and plugins
sudo apt install zsh zsh-autosuggestions zsh-syntax-highlighting

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Clone necessary plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git "$ZSH_CUSTOM/plugins/zsh-autocomplete"

# Update the .zshrc to use the new plugins
OLD_STRING="plugins=(git)"
NEW_STRING="plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)"

# Ensure .zshrc exists and then perform the substitution
if [ -f "$HOME/.zshrc" ]; then
    sed -i "s/$OLD_STRING/$NEW_STRING/g" "$HOME/.zshrc"
else
    echo "$NEW_STRING" > "$HOME/.zshrc"
fi
