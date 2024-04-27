
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
ywget -qO- https://raw.githubusercontent.com/Defmon3/linux-scripts2/main/install.sh | sudo bash install.sh