#!/bin/bash

# Prompt for the root password
read -sp "Enter root password: " rootpass

# Switch to root user and add the current user to the sudo group
echo "$rootpass" | su -c "usermod -aG sudo $(whoami)"

# Verify if the user has been added successfully
groups $(whoami)

# Inform the user to reboot the system
echo "Reboot your system to apply the changes."