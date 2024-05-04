cd ~ || exit 1
#sh -c "$(curl -f https://raw.githubusercontent.com/Defmon3/linux-scripts2/master/install.sh)" | bash
sh -c "$(curl -f https://raw.githubusercontent.com/Defmon3/linux-scripts2/master/install.py)" | python3
echo "Enter your sudo password:" && read -s sudopass && wget -qO- https://raw.githubusercontent.com/Defmon3/linux-scripts2/master/install.py | python3 - "$sudopass"
