#!/bin/bash

# Prepare the system to run OpenPLC Runtime and run OpenPLC Runtime

# Update the system and install git
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install git vsftpd inotify-tools
curl https://raw.githubusercontent.com/VigilantBag/AICSHP/openplc/arm_based_installation/preconfigured_files/vsftpd.conf > vsftpd.conf

# Clone the OpenPLC runtime repo
git clone https://github.com/thiagoralves/OpenPLC_v3.git

# Obtain the current user name
echo "Enter your selected user name: "
read USER_NAME

# Run OpenPLC's installation script
cd /home/"$USER_NAME"/OpenPLC_v3
bash /home/$USER_NAME/OpenPLC_v3/install.sh rpi

# Move and utilize the pre-configured vsftpd file
cd /home/$USER_NAME
sudo chmod 644 vsftpd.conf
sudo chown root:root vsftpd.conf
sudo rm /etc/vsftpd.conf
sudo mv /home/$USER_NAME/vsftd.conf /etc/vsftpd.conf

# Configure and move vsftpd.user_list file
echo "$USER_NAME" > vsftpd.user_list
sudo chmod 644 vsftpd.user_list
sudo chown root:root vsftpd.user_list
sudo mv /home/$USER_NAME/vsftd.user_list /etc/vsftpd.user_list

# Create the ftp server
cd /home/$USER_NAME/OpenPLC_v3/webserver/st_files

# Restart the vsftpd
sudo systemctl restart vsftpd

# Ensure FTP traffic is allowed through the firewall
sudo ufw allow 20:21/tcp
sudo ufw allow 30000:31000/tcp
sudo ufw allow 8080/tcp

# sudo ufw allow OpenSSH <-- uncomment for troubleshooting/setup

# Restart the firewall to reload the ufw rules
sudo ufw disable
sudo ufw enable

