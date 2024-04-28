#!/usr/bin/env bash

highlight() { echo -e "\033[1m\033[43m$1\033[0m"; }
ehighlight() { echo -e "\033[1m\033[41m$1\033[0m"; }


export ZSH="$HOME/.config/oh-my-zsh"
ZSH_CUSTOM="$HOME/.config/oh-my-zsh/custom"
mkdir -p "$ZSH_CUSTOM" > /dev/null 2>&1
sudo nala install zsh zsh-autosuggestions zsh-syntax-highlighting -y

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions" > /dev/null 2>&1
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" > /dev/null 2>&1
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" > /dev/null 2>&1
git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git "$ZSH_CUSTOM/plugins/zsh-autocomplete" > /dev/null 2>&1

highlight "Plugins cloned successfully."


# Change the default shell to zsh


dotfilePath="$HOME/.config/linux-scripts2/zsh/.zshrc"

symlinkPath="$HOME/.zshrc"
ln -s "$dotfilePath" "$symlinkPath"
echo "Symlink created: $symlinkPath -> $(readlink -f $symlinkPath)"

chsh -s $(which zsh)
