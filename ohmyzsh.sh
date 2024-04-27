#!/usr/bin/env bash

highlight() { echo -e "\033[1m\033[43m$1\033[0m"; }
ehighlight() { echo -e "\033[1m\033[41m$1\033[0m"; }

# Default XDG_CONFIG_HOME if not set
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH="$XDG_CONFIG_HOME/oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"


sudo nala install zsh zsh-autosuggestions zsh-syntax-highlighting -y > /dev/null 2>&1
highlight "Zsh and plugins installed successfully."


sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended

git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" > /dev/null 2>&1
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" > /dev/null 2>&1
git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git "$ZSH_CUSTOM/plugins/zsh-autocomplete" > /dev/null 2>&1

highlight "Plugins cloned successfully."

# Update the .zshrc to use the new plugins


echo -e "source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zshG" | tee -a "$ZDOTDIR/.zshrc"
echo -e "source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zshG" | tee -a "$ZDOTDIR/.zshrc"
echo -e "source $ZSH_CUSTOM/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" | tee -a "$ZDOTDIR/.zshrc"
echo -e "source $ZSH_CUSTOM/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh" | tee -a "$ZDOTDIR/.zshrc"

highlight ".zshrc created and updated successfully."

# Update /etc/zsh/zshenv to ensure it knows about ZDOTDIR
sudo tee -a /etc/zsh/zshenv <<EOF
export XDG_CONFIG_HOME="$XDG_CONFIG_HOME"
export ZDOTDIR="$ZDOTDIR"
EOF


# Change the default shell to zsh
chsh -s $(which zsh)
