#!/bin/bash

# Define the path to .bashrc
BASHRC="$HOME/.bashrc"

# Define the line to add
XDG_CONFIG_LINE="export XDG_CONFIG_HOME=\"\${XDG_CONFIG_HOME:-\$HOME/.config}\""

# Check if .bashrc exists. If not, create it.
if [ ! -f "$BASHRC" ]; then
    echo "#!/bin/bash" > "$BASHRC"
    echo "# .bashrc: executed by bash(1) for non-login shells." >> "$BASHRC"
    echo "export PS1='\h:\w\$ '" >> "$BASHRC"
    echo "Created new .bashrc file."
fi

# Check if XDG_CONFIG_HOME is already set in .bashrc
if grep -q "XDG_CONFIG_HOME" "$BASHRC"; then
    echo "XDG_CONFIG_HOME already set in $BASHRC"
else
    # Add the environment variable setting to .bashrc
    echo "$XDG_CONFIG_LINE" >> "$BASHRC"
    echo "Added XDG_CONFIG_HOME to $BASHRC"
fi
