#!/bin/bash
# main.sh and others

PACKAGES=(tmux fzf curl)
yellow() { echo -e "\033[1m\033[43m$1\033[0m"; }

red() { echo -e "\033[1m\033[41m$1\033[0m"; }

green() { echo -e "\033[1m\033[42m$1\033[0m"; }
green "\nStarting main.sh"

#echo $SUDOPASS | sudo -S sh -c "echo '${SUDO_USER:-$(whoami)} ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/temp_nopasswd"

if [ $? -ne 0 ]; then
    red "Failed to authenticate with sudo."
    exit 1
fi


yellow "<<< Installing Nala >>>"

echo $SUDOPASS | sudo -S apt install nala -y > /dev/null 2>&1 || { red "Failed to install Nala"; exit 1; }
echo "Updating Nala..."
echo $SUDOPASS | sudo -S nala update > /dev/null 2>&1 || { red "Failed to update Nala"; exit 1; }
echo $SUDOPASS | sudo -S nala upgrade > /dev/null 2>&1 || { red "Failed to update Nala"; exit 1; }

yellow "<<< Installing $PACKAGES >>>"
echo $SUDOPASS | sudo -S nala install "${PACKAGES[@]}" -y > /dev/null 2>&1 || {
    echo "Failed to install $PACKAGES" >&2  # using echo for error message
    exit 1
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

