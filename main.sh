#!/bin/bash
# main.sh and others


yellow() { echo -e "\033[1m\033[43m$1\033[0m"; }

red() { echo -e "\033[1m\033[41m$1\033[0m"; }

green() { echo -e "\033[1m\033[42m$1\033[0m"; }

debug=1
execute_command() {
    local command=$1
    local local_debug="${2:-$debug}"
    yellow ">>> $command"

    if [ "$local_debug" -eq 1 ]; then
        if $command; then
        green "$command"
      else
          red "$command"
          exit 1
      fi
    else
      if $command >/dev/null 2>&1; then
        green "$command"
      else
          red "$command"
          exit 1
      fi
    fi


}
green "\nStarting main.sh"

#echo $SUDOPASS | sudo -S sh -c "echo '${SUDO_USER:-$(whoami)} ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/temp_nopasswd"

if [ $? -ne 0 ]; then
    red "Failed to authenticate with sudo."
    exit 1
fi



execute_command "sudo -S apt install nala -y"
execute_command "echo \$SUDOPASS | sudo -S nala update"
execute_command "echo \$SUDOPASS | sudo -S nala upgrade"
execute_command "echo \$SUDOPASS | sudo -S nala install tmux fzf curl -y"


yellow "<<< Installing terminator >>>"
chmod +x ./install-terminator.sh
bash ./install-terminator.sh || { red "oh-my-zsh installation failed"; exit 1; }

yellow "<<< Installing oh-my-zsh >>>"
chmod +x ./ohmyzsh.sh
bash ./ohmyzsh.sh || { red "oh-my-zsh installation failed"; exit 1; }

yellow "<<< Installing Sublime >>>"
chmod +x ./sublime.sh
./sublime.sh || { red "Sublime installation failed"; exit 1; }

yellow "<<< Setting up auto login >>>"
chmod +x ./auto_login.sh
echo $SUDOPASS | sudo -S bash ./auto_login.sh || { echo 'Auto login setup failed'; exit 1; }



# reboot

#
# Speed up Ubuntu boot
# https://itsfoss.com/speed-up-ubuntu-131
