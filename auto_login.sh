#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" >&2
   exit 1
fi

# Backup the original configuration file
cp /etc/gdm3/custom.conf /etc/gdm3/custom.conf.bak

# Write the new configuration
cat <<EOF | sudo tee /etc/gdm3/custom.conf
# GDM configuration storage
#
# See /usr/share/gdm/gdm.schemas for a list of available options.

[daemon]
# Uncomment the line below to force the login screen to use Xorg
#WaylandEnable=false

# Enabling automatic login
AutomaticLoginEnable = true
AutomaticLogin = $USER

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

echo "GDM configuration updated. A backup was made at /etc/gdm3/custom.conf.bak"
