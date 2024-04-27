#!/bin/bash

# Ensure the script is run with superuser privileges
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root."
    exit 1
fi

# Install git
echo "Installing Git..."
sudo apt-get install git -y

# Change to the .config directory, create if it does not exist
cd "$HOME"
mkdir -p .config && cd .config

# Clone the repository
echo "Cloning the repository..."
git clone https://github.com/Defmon3/linux-scripts2.git

# Change directory to the cloned repository
cd linux-scripts2

# Execute the main script
echo "Running the main script..."
bash ./main.sh
