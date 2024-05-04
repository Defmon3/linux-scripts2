#!/usr/bin/env python3
import os
import sys

if len(sys.argv) < 2:
    print("Usage: python script.py <sudo_password>")
    sys.exit(1)
sudopass = sys.argv[1]

home = os.path.expanduser("~")
config = os.path.join(home, ".config")
if not os.path.exists(config):
    os.makedirs(config)
print("Made dirs")
print(f"SUDOPASS = {sudopass}")
os.system(f"export SUDOPASS={sudopass};")

os.system('echo $SUDOPASS |sudo -S apt update;')
os.system('echo $SUDOPASS | sudo -S apt install git -y > /dev/null 2>&1 &&')
os.chdir(config)
print("Cloning repo")
os.system(
    '(git clone https://github.com/Defmon3/linux-scripts2.git || (cd linux-scripts2 && git pull))  > /dev/null 2>&1 && ')
os.system('sudo apt autoremove -y > /dev/null 2>&1 &&')
os.system('sudo apt autoclean -y > /dev/null 2>&1 &&')
os.system('bash ./main.sh')
