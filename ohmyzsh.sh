#!/usr/bin/env bash

ehighlight() {
    echo -e "\033[1m\033[41m$1\033[0m"
}


# Ensure XDG_CONFIG_HOME is set, default to ~/.config if not set
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Define where Oh My Zsh and its custom plugins should be installed
ZSH_CUSTOM="$XDG_CONFIG_HOME/oh-my-zsh/custom"

# Create the directories if they do not exist
mkdir -p "$ZSH_CUSTOM/plugins" 2>/dev/null

# Install Zsh and plugins
if sudo nala install zsh zsh-autosuggestions zsh-syntax-highlighting -y > /dev/null 2>&1; then
    echo "Zsh and plugins installed successfully."
else
    ehighlight "Error installing Zsh and plugins." >&2
fi

# Install Oh My Zsh
if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>&1; then
    echo "Oh My Zsh installed successfully."
else
    echo "Error installing Oh My Zsh." >&2
fi

# Clone necessary plugins
if git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions" > /dev/null 2>&1 &&
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" > /dev/null 2>&1 &&
   git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" > /dev/null 2>&1 &&
   git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git "$ZSH_CUSTOM/plugins/zsh-autocomplete" > /dev/null 2>&1; then
    echo "Plugins cloned successfully."
else
    echo "Error cloning one or more plugins." >&2
fi

# Update the .zshrc to use the new plugins
if [ -f "$HOME/.zshrc" ]; then
    if sed -i "s/$OLD_STRING/$NEW_STRING/g" "$HOME/.zshrc"; then
        echo ".zshrc updated successfully."
    else
        echo "Error updating .zshrc." >&2
    fi
else
    if echo "$NEW_STRING" > "$HOME/.zshrc"; then
        echo ".zshrc created and updated successfully."
    else
        echo "Error creating .zshrc." >&2
    fi
fi
