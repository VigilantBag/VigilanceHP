#!/bin/bash

# Prepare the system to run OpenPLC Runtime and run OpenPLC Runtime

# Update the system and install git
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install git vsftpd inotify-tools

# Clone the OpenPLC runtime repo
git clone https://github.com/thiagoralves/OpenPLC_v3.git

# Obtain the current user name
read "Enter your selected user name: " USER_NAME

# Run OpenPLC's installation script
cd /home/"$USER_NAME"/OpenPLC_v3
bash /home/$USER_NAME/OpenPLC_v3/install.sh rpi



# Create the ftp server
cd ~/OpenPLC_v3/webserver/st_files