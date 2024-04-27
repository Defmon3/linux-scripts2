#!/bin/bash

highlight() {
    echo -e "\033[1m\033[43m$1\033[0m"
}

ehighlight() {
    echo -e "\033[1m\033[41m$1\033[0m"
}

# Ensure the script is run with superuser privileges
if [[ $EUID -ne 0 ]]; then
    ehighlight "This script must be run as root."
    exit 1
fi

# Install git
highlight "Installing Git..."
if sudo apt-get install git -y > /dev/null 2>&1; then
    highlight "Git installed successfully."
else
    ehighlight "Failed to install Git."
    exit 1
fi

# Change to the .config directory, create if it does not exist
cd "$HOME"
if mkdir -p .config && cd .config; then
    highlight "Navigated to .config directory."
else
    ehighlight "Failed to navigate to or create .config directory."
    exit 1
fi

# Clone the repository
highlight "Cloning the repository..."
if git clone https://github.com/Defmon3/linux-scripts2.git > /dev/null 2>&1; then
    highlight "Repository cloned successfully."
else
    ehighlight "Failed to clone the repository."
    exit 1
fi

# Change directory to the cloned repository
if cd linux-scripts2; then
    highlight "Navigated to the linux-scripts2 directory."
else
    ehighlight "Failed to navigate to the linux-scripts2 directory."
    exit 1
fi

# Execute the main script
highlight "Running the main script..."
if bash ./main.sh; then
    highlight "Main script executed successfully."
else
    ehighlight "Failed to execute the main script."
    exit 1
fi
