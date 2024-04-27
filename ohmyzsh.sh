#!/usr/bin/env bash
set -euo pipefail

highlight() { echo -e "\033[1m\033[43m$1\033[0m"; }
ehighlight() { echo -e "\033[1m\033[41m$1\033[0m"; }

# Default XDG_CONFIG_HOME if not set
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH="$XDG_CONFIG_HOME/oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

# Ensure necessary directories exist
mkdir -p "$ZDOTDIR" "$ZSH_CUSTOM/plugins" || {
    ehighlight "Error creating directories." >&2
    exit 1
}

# Update /etc/zsh/zshenv to ensure it knows about ZDOTDIR
sudo tee -a /etc/zsh/zshenv <<EOF
export XDG_CONFIG_HOME="$XDG_CONFIG_HOME"
export ZDOTDIR="$ZDOTDIR"
EOF

# Install Zsh and plugins
if ! sudo nala install zsh zsh-autosuggestions zsh-syntax-highlighting -y > /dev/null 2>&1; then
    ehighlight "Error installing Zsh and plugins." >&2
    exit 1
fi
highlight "Zsh and plugins installed successfully."

# Install Oh My Zsh unattendedly
if ! sh -c "ZSH=$ZSH ZDOTDIR=$ZDOTDIR sh -c \$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null 2>&1; then
    ehighlight "Error installing Oh My Zsh." >&2
    exit 1
fi
highlight "Oh My Zsh installed successfully in $ZSH."

# Clone necessary plugins
plugins=(
    zsh-autosuggestions
    zsh-syntax-highlighting
    fast-syntax-highlighting
    zsh-autocomplete
)
for plugin in "${plugins[@]}"; do
    git_url="https://github.com/zsh-users/$plugin.git"
    git_url=${git_url/fast-syntax-highlighting=https://github.com/zdharma-continuum/fast-syntax-highlighting.git}
    git_url=${git_url/zsh-autocomplete=https://github.com/marlonrichert/zsh-autocomplete.git}
    if ! git clone --depth 1 "$git_url" "$ZSH_CUSTOM/plugins/$plugin" > /dev/null 2>&1; then
        ehighlight "Error cloning $plugin." >&2
        exit 1
    fi
done
highlight "Plugins cloned successfully."

# Update the .zshrc to use the new plugins
NEW_STRING="source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh\nsource $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh\nsource $ZSH_CUSTOM/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh\nsource $ZSH_CUSTOM/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
echo -e "$NEW_STRING" > "$ZDOTDIR/.zshrc"
highlight ".zshrc created and updated successfully."

# Change the default shell to zsh
chsh -s $(which zsh)
