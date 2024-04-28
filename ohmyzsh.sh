#!/usr/bin/env bash

highlight() { echo -e "\033[1m\033[43m$1\033[0m"; }
ehighlight() { echo -e "\033[1m\033[41m$1\033[0m"; }


export ZSH="$HOME/.config/oh-my-zsh"
echo $SUDOPASS | sudo -S nala install zsh zsh-autosuggestions zsh-syntax-highlighting -y

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
mkdir -p "$ZSH_CUSTOM" > /dev/null 2>&1

git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH/custom/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH/custom/plugins/zsh-autocomplete


dotfilePath="$HOME/.config/linux-scripts2/zsh/.zshrc"
rm -f "$HOME/.zshrc"
symlinkPath="$HOME/.zshrc"
ln -s "$dotfilePath" "$symlinkPath"
echo "Symlink created: $symlinkPath -> $(readlink -f $symlinkPath)"

wget -P ~/.local/share/fonts "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip" \
&& cd ~/.local/share/fonts \
&& unzip Hack.zip \
&& rm Hack.zip \
&& fc-cache -fv

git clone https://github.com/sebastiencs/icons-in-terminal.git &&
cd icons-in-terminal &&
./install-autodetect.sh &&
cd .. && rm -rf icons-in-terminal
echo $SUDOPASS | sudo -S chsh -s $(which zsh)
