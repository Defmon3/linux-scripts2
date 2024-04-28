#!/bin/bash
# main.sh and others
highlight() {
    echo -e "\033[1m\033[43m$1\033[0m"
}

ehighlight() {
    echo -e "\033[1m\033[41m$1\033[0m"
}

if [ $? -ne 0 ]; then
    echo "Failed to authenticate with sudo."
    exit 1
fi

# If the script reaches this point, the sudo authentication was successful
echo "Sudo authentication successful."


# Main script begins
highlight "<<< Updating system >>>"

highlight "<<< Sudo update && upgrade >>>"
sudo apt-get update -y >/dev/null 2>&1 || { ehighlight "Update failed"; exit 1; }
sudo apt-get upgrade -y >/dev/null 2>&1 || { ehighlight "Upgrade failed"; exit 1; }

highlight "<<< Installing Nala >>>"
sudo apt install nala -y > /dev/null 2>&1 || { ehighlight "Failed to install Nala"; exit 1; }
echo "Updating Nala..."
echo $SUDOPASS | sudo -S nala update > /dev/null 2>&1 || { ehighlight "Failed to update Nala"; exit 1; }

highlight "<<< Installing Curl >>>"
echo $SUDOPASS | sudo -S nala install curl -y || { ehighlight "Failed to install Curl"; exit 1; }

highlight "<<< Installing terminator >>>"
chmod +x ./install-terminator.sh
bash ./install-terminator.sh || { ehighlight "oh-my-zsh installation failed"; exit 1; }


highlight "<<< Installing oh-my-zsh >>>"
chmod +x ./ohmyzsh.sh
bash ./ohmyzsh.sh || { ehighlight "oh-my-zsh installation failed"; exit 1; }


highlight "<<< Installing Sublime >>>"
chmod +x ./sublime.sh
./sublime.sh || { ehighlight "Sublime installation failed"; exit 1; }

highlight "<<< Setting up auto login >>>"
chmod +x ./auto_login.sh
echo $SUDOPASS | sudo -S bash ./auto_login.sh || { echo 'Auto login setup failed'; exit 1; }



# reboot

#
# Speed up Ubuntu boot
# https://itsfoss.com/speed-up-ubuntu-131
