#!/bin/bash
# main.sh and others
highlight() {
    echo -e "\033[1m\033[43m$1\033[0m"
}

ehighlight() {
    echo -e "\033[1m\033[41m$1\033[0m"
}

read -sp "Enter your sudo password: " sudopass
export SUDOPASS=$sudopass
echo $SUDOPASS | sudo -S echo "Thank you for providing your password $SUDOPASS"
# Main script begins
highlight "<<< Updating system >>>"

highlight "<<< Sudo update && upgrade >>>"
sudo apt-get update -y >/dev/null 2>&1 || { ehighlight "Update failed"; exit 1; }
sudo apt-get upgrade -y >/dev/null 2>&1 || { ehighlight "Upgrade failed"; exit 1; }

highlight "<<< Installing Nala >>>"
sudo apt install nala -y > /dev/null 2>&1 || { ehighlight "Failed to install Nala"; exit 1; }
echo "Updating Nala..."
sudo nala update > /dev/null 2>&1 || { ehighlight "Failed to update Nala"; exit 1; }

highlight "<<< Installing Curl >>>"
sudo nala install curl terminator -y || { ehighlight "Failed to install Curl"; exit 1; }

ehighlight "<<< Exit early for nala>>>"

exit 1

highlight "<<< Installing oh-my-zsh >>>"
chmod +x ./ohmyzsh.sh
bash ./ohmyzsh.sh || { ehighlight "oh-my-zsh installation failed"; exit 1; }


highlight "<<< Installing oh-my-posh >>>"
chmod +x ./ohmyposh.sh
./ohmyposh.sh || { ehighlight "oh-my-posh installation failed"; exit 1; }

highlight "<<< Installing Sublime >>>"
chmod +x ./sublime.sh
./sublime.sh || { ehighlight "Sublime installation failed"; exit 1; }

highlight "<<< Setting up auto login >>>"
chmod +x ./auto_login.sh
echo $sudopass | sudo -S bash ./auto_login.sh || { echo 'Auto login setup failed'; exit 1; }



# reboot

#
# Speed up Ubuntu boot
# https://itsfoss.com/speed-up-ubuntu-131
