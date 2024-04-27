#!/bin/bash

# main.sh and others
source ./util.sh

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo "Configuring auto-login for $USERNAME..."
if output=$(id "$USERNAME" 2>&1); then
    echo "Configuring auto-login for $USERNAME..."
else
    echo "Error: $output"
    exit 1
fi
# Path to GDM3 custom configuration
GDM_CUSTOM_CONF="/etc/gdm3/custom.conf"

# Check if the GDM custom configuration file exists
if [[ -f "$GDM_CUSTOM_CONF" ]]; then
    # Backup the original configuration file
    cp $GDM_CUSTOM_CONF "${GDM_CUSTOM_CONF}.bak"
    echo "Backup of the original GDM configuration created at ${GDM_CUSTOM_CONF}.bak"

    # Setting up auto-login
    sed -i '/\[daemon\]/a AutomaticLoginEnable=True' $GDM_CUSTOM_CONF
    sed -i "/AutomaticLoginEnable=True/a AutomaticLogin=$USERNAME" $GDM_CUSTOM_CONF

    highlight "Auto-login configured successfully."
else
    ehighlight "Error: GDM3 configuration file does not exist."
    exit 1
fi

# Inform user to reboot the system
echo "Please reboot your system to apply the changes."
