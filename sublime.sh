#!/usr/bin/env bash

# Source common functions for highlighting
source ./util.sh

# Import the Sublime Text repository GPG key
if wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null; then
    highlight "Sublime Text repository GPG key imported successfully."
else
    ehighlight "Error importing Sublime Text repository GPG key." >&2
    exit 1
fi

# Add the Sublime Text repository
if echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list > /dev/null; then
    highlight "Sublime Text repository added successfully."
else
    ehighlight "Error adding Sublime Text repository." >&2
    exit 1
fi

# Update package lists with Nalaó
highlight "Updating package lists..."
if sudo nala update > /dev/null 2>&1; then
    highlight "Package lists updated successfully."
else
    ehighlight "Failed to update package lists." >&2
    exit 1
fi

# Install Sublime Text with Nala
highlight "Installing Sublime Text..."
if sudo nala install sublime-text -y > /dev/null 2>&1; then
    highlight "Sublime Text installed successfully."
else
    ehighlight "Failed to install Sublime Text." >&2
    exit 1
fi
