#!/bin/bash

# Function to install a package if it's not already installed
install_package_if_needed() {
    package="$1"
    dpkg -s "$package" &> /dev/null
    if [ $? -ne 0 ]; then
        echo "Installing $package..."
        sudo apt install -y "$package"
    fi
}

# Check if the user is root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root or use sudo"
    exit 1
fi

# Install required packages
install_package_if_needed "dialog"
export DIALOGRC="B=green,default"

# Create a checklist using dialog
choices=$(dialog --title "Program Installer" --checklist  --colors - \
"Choose programs to install" 15 60 6 \
"vim" "Text editor" OFF \
"curl" "Data transfer utility" OFF \
"git" "Version control system" OFF \
"htop" "System monitor" OFF \
"tmux" "Terminal multiplexer" OFF \
"nmap" "Network scanner" OFF 3>&1 1>&2 2>&3)

# Remove double quotes from options for easier processing
choices=$(echo "$choices" | tr -d '"')
clear
# Check if no programs were selected
if [ -z "$choices" ]; then
    echo "No programs selected. Exiting..."
    exit 0
fi

# Inform the user about the installation
echo "Installing selected programs: $choices"
echo "Running: sudo apt update && sudo apt install -y $choices"

# Perform the installation
sudo apt update
sudo apt install -y $choices
