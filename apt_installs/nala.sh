#!/bin/bash
APP="nala"
[ -z "$1" ] && echo "Argument is empty or not provided" || echo "Argument provided: $1"

# Colors
yellow() { echo -e "\033[1m\033[30m\033[43m$1\033[0m"; }
red() { echo -e "\033[1m\033[41m$1\033[0m"; }
green() { echo -e "\033[1m\033[42m$1\033[0m"; }

# Base install
yellow "<<< Installing $APP >>>"
[ -n "$SUDOPASS" ] || { read -sp "Enter your sudo password: " sudopass; export SUDOPASS=$sudopass; }
which nala > /dev/null 2>&1 &&
echo " $APP already installed" ||
echo $SUDOPASS | sudo -S apt install  $APP -y > /dev/null 2>&1
green "$APP installed"

# Extra
yellow " $APP updating..."
echo $SUDOPASS | sudo -S nala update > /dev/null 2>&1

yellow " $APP upgrading"
echo $SUDOPASS | sudo -S nala upgrade > /dev/null 2>&1

echo $SUDOPASS | sudo -S nala fetch --auto > /dev/null 2>&1