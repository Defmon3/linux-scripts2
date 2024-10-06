# Linux Setup Scripts

This repository contains scripts to quickly set up a Linux environment, including essential configurations like installing necessary packages, setting up user permissions, enabling system performance features, and configuring useful development tools. Follow the instructions below for different environments like **Ubuntu** and **Kali Linux**.

---

## Prerequisites

Before proceeding, ensure to enable **max graphics memory** and **bidirectional clipboard** (if applicable) to enhance system performance and usability. For instructions on how to enable these features, refer to your virtualization software's documentation or visit [this guide](https://help.ubuntu.com/community/VirtualBox/GuestAdditions).

---

## Troubleshooting Terminal Access

### If Terminal is Not Opening

If you're unable to open the terminal, follow these steps:

1. **Open Settings** -> **Region**.
2. Change the region to **Canada**.
3. **Log out**, then **log back in**.
4. Change the region back to **US**.
5. **Log out** again, then **log back in**.
6. Now, try to open the terminal.

---

## Enable Sudo Access

If you cannot use `sudo` in the terminal, run the following script to ensure you are added to the `sudo` group:

```bash
#!/bin/bash

# Prompt for the root password
read -sp "Enter root password: " rootpass

# Switch to root user and add the current user to the sudo group
echo "$rootpass" | su -c "usermod -aG sudo $(whoami)"

# Verify if the user has been added successfully
groups $(whoami)

# Inform the user to reboot the system
echo "Reboot your system to apply the changes."
```

If you prefer manual steps, follow these instructions:

1. **Open the terminal using root access**:
   ```bash
   su
   ```
   You will be prompted to enter your password.

2. **Add your user to the `sudo` group**:
   ```bash
   usermod -aG sudo <your_username>
   ```

3. **Verify that your user is now in the `sudo` group**:
   ```bash
   groups <your_username>
   ```

4. **Reboot the system to apply the changes**:
   ```bash
   reboot
   ```

> **Note**: Replace `<your_username>` with your actual username, for example, `delta`.

---

## Setup Instructions

### Setup for Ubuntu

Run the following commands in the terminal to set up your environment on **Ubuntu**:

2. **Execute the shell script to complete the setup**:
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/Defmon3/linux-scripts2/master/install.sh)"
   ```

Alternatively, you can manually clone the repository and run the main setup script:

```bash
mkdir -p ~/.config && cd ~/.config

read -sp "Enter your sudo password: " sudopass && export SUDOPASS=$sudopass && \
echo $SUDOPASS | sudo -S apt install git -y && \
(git clone https://github.com/Defmon3/linux-scripts2.git || (cd linux-scripts2 && git pull)) && \
sudo apt autoremove -y && \
cd linux-scripts2 && bash ./main.sh
```

### Setup for Kali Linux

If you're using **Kali Linux**, run the following command to set up your environment:

```bash
bash -c 'read -sp "Enter your sudo password: " sudopass && \
export SUDOPASS=$sudopass > /dev/null 2>&1 && \
echo $SUDOPASS | sudo -S apt install git -y > /dev/null 2>&1 && \
(git clone https://github.com/Defmon3/linux-scripts2.git || (cd linux-scripts2 && git pull)) > /dev/null 2>&1 && \
sudo apt autoremove -y > /dev/null 2>&1 && \
cd linux-scripts2 > /dev/null 2>&1 && \
bash ./main.sh'
```

---

## Notes

- Ensure your system has an **active internet connection** to download the necessary packages and repositories.
- After completing these steps, your Linux environment will be set up with the required configurations.
- If you encounter any issues, verify your **sudo access** or **terminal functionality** using the steps mentioned above.

---

## Additional Information

For more details on each script or to contribute to this project, check out the source code in this repository.