#!/bin/bash

# Install vsftpd
sudo apt install vsftpd tshark -y

# Create the wireshark user 
sudo adduser wireshark 
sudo usermod -aG wireshark,ftp wireshark
cd /home/wireshark

# Create an ftp user_list file
sudo wget https://raw.githubusercontent.com/VigilantBag/AICSHP/openplc/arm_based_installation/preconfigured_files/physical_pi_ftp/vsftpd.user_list
sudo chmod 644 ./vsftpd.user_list
sudo chown root:root ./vsftpd.user_list
sudo cp /home/wireshark/vsftpd.user_list /etc/vsftpd.user_list

# Move and utilize the vsftp configuration file
sudo wget https://raw.githubusercontent.com/VigilantBag/AICSHP/openplc/arm_based_installation/preconfigured_files/physical_pi_ftp/vsftpd.conf
sudo chmod 644 vsftpd.conf
sudo chown root:root vsftpd.conf
sudo rm /etc/vsftpd.conf
sudo cp /home/wireshark/vsftpd.conf /etc/vsftpd.conf

# Restart the vsftpd service
sudo systemctl restart vsftpd

