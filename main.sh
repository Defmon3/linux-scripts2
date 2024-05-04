#!/bin/bash
# main.sh and others
#Working
PACKAGES=(tmux fzf curl)
yellow() { echo -e "\033[1m\033[43m$1\033[0m"; }
red() { echo -e "\033[1m\033[41m$1\033[0m"; }
green() { echo -e "\033[1m\033[42m$1\033[0m"; }
green "\nStarting main.sh"

[ $? -ne 0 ] && { red "Failed to add NOPASSWD to sudoers"; exit 1; }


yellow "<<< Installing Nala >>>"

echo $SUDOPASS | sudo -S apt install nala -y
echo "Updating Nala..."
echo $SUDOPASS | sudo -S nala update
echo $SUDOPASS | sudo -S nala upgrade

yellow "<<< Installing $PACKAGES >>>"
echo $SUDOPASS | sudo -S nala install "${PACKAGES[@]}" -y > /dev/null 2>&1 || {
  echo "Failed to install $PACKAGES" >&2; exit 1;
}


yellow "<<< Installing terminator >>>"
chmod +x ./install-terminator.sh
bash ./install-terminator.sh || { red "oh-my-zsh installation failed"; exit 1; }

yellow "<<< Installing oh-my-zsh >>>"
chmod +x ./ohmyzsh.sh
bash ./ohmyzsh.sh || { red "oh-my-zsh installation failed"; exit 1; }


yellow "<<< Installing Sublime >>>"
chmod +x ./sublime.sh
./sublime.sh || { red "Sublime installation failed"; exit 1; }

yellow "<<< Setting up auto login >>>"
chmod +x ./auto_login.sh
echo $SUDOPASS | sudo -S bash ./auto_login.sh || { echo 'Auto login setup failed'; exit 1; }

