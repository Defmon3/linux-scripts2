#!/bin/bash

highlight() {
    echo -e "\033[1m\033[43m$1\033[0m"
}

ehighlight() {
    echo -e "\033[1m\033[41m$1\033[0m"
}

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi


# Check if the user exists
if id "$USERNAME" &>/dev/null; then
    echo "Configuring auto-login for $USERNAME..."
else
    ehighlight "Error: User does not exist."
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