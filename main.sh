#!/bin/bash

chmod +x ./system-setup.sh
./system-setup.sh

sudo apt-get update

sudo apt-get install nala

sudo apt-get install git

chmod +x ./ohmyzsh.sh
./ohmyzsh.sh

chmod +x ./sublime.sh
./sublime.sh
