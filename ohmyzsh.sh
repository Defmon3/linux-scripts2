#!/usr/bin/env bash

highlight() {
    echo -e "\033[1m\033[43m$1\033[0m"
}

ehighlight() {
    echo -e "\033[1m\033[41m$1\033[0m"
}

# Ensure XDG_CONFIG_HOME is set, default to ~/.config if not set
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

BASHRC="$HOME/.bashrc"
XDG_CONFIG_LINE="export XDG_CONFIG_HOME=\"\$XDG_CONFIG_HOME\""

# Check if .bashrc exists. If not, create it.
if [ ! -f "$BASHRC" ]; then
    echo "#!/bin/bash" > "$BASHRC"
    echo "# .bashrc: executed by bash(1) for non-login shells." >> "$BASHRC"
    echo "export PS1='\h:\w\$ '" >> "$BASHRC"
    echo "Created new .bashrc file."
fi

# Check if XDG_CONFIG_HOME is already set in .bashrc
if ! grep -q "XDG_CONFIG_HOME" "$BASHRC"; then
    echo "$XDG_CONFIG_LINE" >> "$BASHRC"
    echo "Added XDG_CONFIG_HOME to $BASHRC"
fi

# Define ZSH and ZDOTDIR environment
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH="$XDG_CONFIG_HOME/oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

mkdir -p "$ZDOTDIR" "$ZSH_CUSTOM/plugins" || {
    ehighlight "Error creating directories." >&2
    exit 1
}

# Install Zsh and plugins
if ! sudo nala install zsh zsh-autosuggestions zsh-syntax-highlighting -y > /dev/null 2>&1; then
    ehighlight "Error installing Zsh and plugins." >&2
    exit 1
fi

highlight "Zsh and plugins installed successfully."

# Install Oh My Zsh
if ! sh -c "ZSH=$ZSH ZDOTDIR=$ZDOTDIR sh -c \$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null 2>&1; then
    ehighlight "Error installing Oh My Zsh." >&2
    exit 1
fi

highlight "Oh My Zsh installed successfully in $ZSH."

# Clone necessary plugins
if ! git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions" > /dev/null 2>&1 ||
   ! git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" > /dev/null 2>&1 ||
   ! git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" > /dev/null 2>&1 ||
   ! git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git "$ZSH_CUSTOM/plugins/zsh-autocomplete" > /dev/null 2>&1; then
    ehighlight "Error cloning one or more plugins." >&2
    exit 1
fi

highlight "Plugins cloned successfully."

# Update the .zshrc to use the new plugins
NEW_STRING="source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh\nsource $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh\nsource $ZSH_CUSTOM/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh\nsource $ZSH_CUSTOM/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
if [ -f "$ZDOTDIR/.zshrc" ]; then
    echo "$NEW_STRING" >> "$ZDOTDIR/.zshrc"
    highlight ".zshrc updated successfully."
else
    echo "$NEW_STRING" > "$ZDOTDIR/.zshrc"
    highlight ".zshrc created and updated successfully."
fi
