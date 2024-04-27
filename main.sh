#!/bin/bash
# main.sh and others

highlight() {
    echo -e "\033[1m\033[43m$1\033[0m"
}

ehighlight() {
    echo -e "\033[1m\033[41m$1\033[0m"
}

# Ask for the sudo password at the beginning of the script to ensure sudo access
sudo -v

# Keep sudo alive throughout the execution of this script
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

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

highlight "<<< Installing oh-my-zsh >>>"
bash ohmyzsh.sh || { ehighlight "oh-my-zsh installation failed"; exit 1; }

highlight "<<< Installing oh-my-posh >>>"
bash ohmyposh.sh || { ehighlight "oh-my-posh installation failed"; exit 1; }

highlight "<<< Installing Sublime >>>"
bash sublime.sh || { ehighlight "Sublime installation failed"; exit 1; }

highlight "<<< Setting up auto login >>>"
bash auto_login.sh || { echo 'Auto login setup failed'; exit 1; }

# End of main script execution
highlight "All installations complete! Consider rebooting the system."

# Stop the sudo keep-alive background job
kill "$!"
