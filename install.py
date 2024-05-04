import os
from pathlib import Path

home = Path('~')
config = home / '.config'
config.mkdir(exist_ok=True)
sudopass = input('Enter your sudo password: ')
os.system(f"export SUDOPASS={sudopass}")
os.system('sudo -S apt update')
os.system('echo $SUDOPASS | sudo -S apt install git -y > /dev/null 2>&1 &&')
os.chdir(config)
os.system('(git clone https://github.com/Defmon3/linux-scripts2.git || (cd linux-scripts2 && git pull))  > /dev/null 2>&1 && ')
os.system('sudo apt autoremove -y > /dev/null 2>&1 &&')
os.system('sudo apt autoclean -y > /dev/null 2>&1 &&')
os.system('bash ./main.sh')