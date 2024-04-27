#!/bin/bash

# main.sh and others
source ./util.sh

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Define the target user for auto-login, here assumed to be the current user or set manually
target_user=$USER  # or set manually e.g., target_user="username"

echo "Configuring auto-login for $target_user..."
if output=$(id "$target_user" 2>&1); then
    echo "User $target_user exists, proceeding with configuration..."
else
    echo "Error: $output"
    exit 1
fi

# Path to GDM3 custom configuration
GDM_CUSTOM_CONF="/etc/gdm3/custom.conf"

# Check if the GDM custom configuration file exists
if [[ -f "$GDM_CUSTOM_CONF" ]]; then
    # Backup the original configuration file
    cp "$GDM_CUSTOM_CONF" "${GDM_CUSTOM_CONF}.bak"
    echo "Backup of the original GDM configuration created at ${GDM_CUSTOM_CONF}.bak"

    # Setting up auto-login
    if ! grep -q "AutomaticLoginEnable=True" "$GDM_CUSTOM_CONF"; then
        sed -i '/\[daemon\]/a AutomaticLoginEnable=True' "$GDM_CUSTOM_CONF"
        sed -i "/AutomaticLoginEnable=True/a AutomaticLogin=$target_user" "$GDM_CUSTOM_CONF"
        highlight "Auto-login configured successfully for $target_user."
    else
        highlight "Auto-login is already configured for $target_user."
    fi
else
    ehighlight "Error: GDM3 configuration file does not exist."
    exit 1
fi

# Inform user to reboot the system
echo "Please reboot your system to apply the changes."
