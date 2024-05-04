
Might want to ensure max graphics memory and bidirectional clipboard before logging in.


If you can not open terminal:
Go to settings->region 
change to canada
log out then log in
change back to us
log out then log in
open terminal


If you can not sudo  sudo in terminal:
type: su
type your password
type: usermod -aG sudo <your_username>
type: groups <your_username>
type: reboot

run:

sh -c "$(curl -fsSL https://raw.githubusercontent.com/Defmon3/linux-scripts2/master/install.py)" | python3

sh -c "$(curl -fsSL https://raw.githubusercontent.com/Defmon3/linux-scripts2/master/install.sh)"
cd ~ && 
mkdir .config > /dev/null 2>&1 ;
read -sp "Enter your sudo password: " sudopass &&
export SUDOPASS=$sudopass > /dev/null 2>&1 &&
echo $SUDOPASS | sudo -S apt install git -y > /dev/null 2>&1 &&
cd .config &&
(git clone https://github.com/Defmon3/linux-scripts2.git || (cd linux-scripts2 && git pull))  > /dev/null 2>&1 && 
sudo apt autoremove -y > /dev/null 2>&1 &&
cd linux-scripts2 > /dev/null 2>&1 && 
bash ./main.sh
