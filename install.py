#!/usr/bin/env python3
import os
import subprocess

# Prompt the user for their sudo password
sudopass = input("Enter your sudo password: ")

home = os.path.expanduser("~")
config = os.path.join(home, ".config")
if not os.path.exists(config):
    os.makedirs(config)
print("Made dirs")

# Use subprocess to pass the password to sudo
command = "sudo -S apt update"
proc = subprocess.Popen(command, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
output, error = proc.communicate(input=sudopass.encode() + b'\n')
print(output.decode())
print(error.decode())
sys.exit(1)

os.system('echo $SUDOPASS | sudo -S apt install git -y > /dev/null 2>&1 &&')
os.chdir(config)
print("Cloning repo")
os.system(
    '(git clone https://github.com/Defmon3/linux-scripts2.git || (cd linux-scripts2 && git pull))  > /dev/null 2>&1 && ')
os.system('sudo apt autoremove -y > /dev/null 2>&1 &&')
os.system('sudo apt autoclean -y > /dev/null 2>&1 &&')
os.system('bash ./main.sh')
