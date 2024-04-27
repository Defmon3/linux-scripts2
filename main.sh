#!/bin/bash

chmod +x ./system-setup.sh
./system-setup.sh

sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install nala  -y

chmod +x ./ohmyzsh.sh
./ohmyzsh.sh

chmod +x ./sublime.sh
./sublime.sh

# Speed up Ubuntu boot
# https://itsfoss.com/speed-up-ubuntu-1310/