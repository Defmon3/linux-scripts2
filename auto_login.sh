#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" >&2
   exit 1
fi

# Determine the correct username
username=${SUDO_USER:-$(whoami)}

# Validate the username
if ! id "$username" &>/dev/null; then
    echo "Error: User '$username' does not exist on the system." >&2
    exit 1
fi

# Backup the original configuration file with a timestamp
backup_file="/etc/gdm3/custom.conf.$(date +%Y%m%d%H%M%S).bak"
cp /etc/gdm3/custom.conf "$backup_file"
echo "Backup of the original GDM configuration created at $backup_file"

# Write the new configuration using the validated username
cat <<EOF | sudo tee /etc/gdm3/custom.conf
# GDM configuration storage
#
# See /usr/share/gdm/gdm.schemas for a list of available options.

[daemon]
# Uncomment the line below to force the login screen to use Xorg
#WaylandEnable=false

# Enabling automatic login
AutomaticLoginEnable = true
AutomaticLogin = $username

# Enabling timed login
# TimedLoginEnable = true
# TimedLogin = user1
# TimedLoginDelay = 10

[security]

[xdmcp]

[chooser]

[debug]
# Uncomment the line below to turn on debugging
# More verbose logs
# Additionally lets the X server dump core if it crashes
#Enable=true
EOF

echo "GDM configuration updated for user $username. Please reboot your system to apply the changes."
