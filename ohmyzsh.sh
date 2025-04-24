#!/usr/bin/env bash
set -euo pipefail

highlight()   { echo -e "\033[1m\033[43m$1\033[0m"; }
ehighlight()  { echo -e "\033[1m\033[41m$1\033[0m"; }

highlight "<<< Installing Zsh and plugins >>>"

export ZSH="$HOME/.config/oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

echo "$SUDOPASS" | sudo -S nala install -y zsh zsh-autosuggestions zsh-syntax-highlighting unzip wget curl git

# Install Oh My Zsh to custom location
ZSH="$ZSH" RUNZSH=no KEEP_ZSHRC=yes \
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Clone plugins
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete "$ZSH_CUSTOM/plugins/zsh-autocomplete"

highlight "<<< Installing Nerd Font (Hack) >>>"

mkdir -p ~/.local/share/fonts
wget -P ~/.local/share/fonts "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip"
cd ~/.local/share/fonts
unzip -o Hack.zip
rm Hack.zip
fc-cache -fv

highlight "<<< Installing icons-in-terminal >>>"

cd ~
git clone https://github.com/sebastiencs/icons-in-terminal.git
cd icons-in-terminal
./install-autodetect.sh
cd ~

highlight "<<< Setting Zsh as default shell >>>"
chsh -s "$(command -v zsh)"

# Set ZDOTDIR so Zsh loads from .config
mkdir -p ~/.config/zsh
cat <<EOF > ~/.zshenv
export ZDOTDIR="\$HOME/.config/zsh"
EOF

highlight "✅ Done. Start a new terminal session or run 'exec zsh' to activate Zsh."
