#!/usr/bin/env bash

source ./util.sh


# Ensure XDG_CONFIG_HOME is set, default to ~/.config if not set
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Ensure the Zsh dotfiles directory is set and used
ZDOTDIR="$XDG_CONFIG_HOME/zsh"
mkdir -p "$ZDOTDIR"
export ZDOTDIR

# Define where Oh My Zsh and its custom plugins should be installed
ZSH="$XDG_CONFIG_HOME/oh-my-zsh"
ZSH_CUSTOM="$ZSH/custom"
mkdir -p "$ZSH_CUSTOM/plugins"

# Install Zsh and plugins
if sudo nala install zsh zsh-autosuggestions zsh-syntax-highlighting -y > /dev/null 2>&1; then
    echo "Zsh and plugins installed successfully."
else
    ehighlight "Error installing Zsh and plugins." >&2
fi

# Install Oh My Zsh
if sh -c "ZSH=$ZSH ZDOTDIR=$ZDOTDIR sh -c \$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null 2>&1; then
    highlight "Oh My Zsh installed successfully in $ZSH."
else
    ehighlight "Error installing Oh My Zsh." >&2
fi

# Clone necessary plugins
if git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions" > /dev/null 2>&1 &&
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" > /dev/null 2>&1 &&
   git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" > /dev/null 2>&1 &&
   git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git "$ZSH_CUSTOM/plugins/zsh-autocomplete" > /dev/null 2>&1; then
    highlight "Plugins cloned successfully."
else
    ehighlight "Error cloning one or more plugins." >&2
fi

# Update the .zshrc to use the new plugins
NEW_STRING="source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh\nsource $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh\nsource $ZSH_CUSTOM/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh\nsource $ZSH_CUSTOM/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
if [ -f "$ZDOTDIR/.zshrc" ]; then
    if sed -i "s|source .*|${NEW_STRING}|" "$ZDOTDIR/.zshrc"; then
        highlight ".zshrc updated successfully."
    else
        ehighlight "Error updating .zshrc." >&2
    fi
else
    if echo "$NEW_STRING" > "$ZDOTDIR/.zshrc"; then
        highlight ".zshrc created and updated successfully."
    else
        ehighlight "Error creating .zshrc." >&2
    fi
fi
