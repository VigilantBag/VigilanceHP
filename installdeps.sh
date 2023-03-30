#!/bin/bash

# Prepare the system to run OpenPLC Runtime and run OpenPLC Runtime
cd /home/aicshp/
# Update the system, install dependencies, and grab required files
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y git vsftpd inotify-tools
wget https://raw.githubusercontent.com/VigilantBag/AICSHP/openplc/arm_based_installation/preconfigured_files/vsftpd.conf
wget https://raw.githubusercontent.com/VigilantBag/AICSHP/openplc/arm_based_installation/scripts/inotifyfilechange_arm.sh
# Clone the OpenPLC runtime repo
git clone https://github.com/thiagoralves/OpenPLC_v3.git /home/aicshp/OpenPLC_v3

# Run OpenPLC's installation script
cd /home/aicshp/OpenPLC_v3
bash /home/$USER_NAME/OpenPLC_v3/install.sh linux

# Move and utilize the pre-configured vsftpd file
cd /home/aicshp/
sudo chmod 644 vsftpd.conf
sudo chown root:wheel vsftpd.conf
sudo rm /etc/vsftpd.conf
sudo mv /home/aicshp/vsftd.conf /etc/vsftpd.conf

# Configure and move vsftpd.user_list file
echo aicshp > /etc/vsftpd.user_list
sudo chmod 644 /etc/vsftpd.user_list
sudo chown root:wheel /etc/vsftpd.user_list

# Create the ftp server
cd /home/aicshp/OpenPLC_v3/webserver/st_files

# Restart the vsftpd
sudo systemctl restart vsftpd

# Ensure FTP traffic is allowed through the firewall
sudo ufw allow 20:21/tcp
sudo ufw allow 30000:31000/tcp
sudo ufw allow 502
sudo allow from any to any proto tcp port 10090:10100

# sudo ufw allow 8080/tcp <--uncomment for troubleshooting/setup
# sudo ufw allow OpenSSH <-- uncomment for troubleshooting/setup

# Restart the firewall to reload the ufw rules
sudo ufw disable
sudo ufw enable

# Correct permissions, ownership and add inotify script to /etc/
cd /home/aicshp/
sudo chmod 755 inotifyfilechange_arm.sh
sudo chown root:root inotifyfilechange_arm.sh
sudo mv /home/aicshp/inotifyfilechange_arm.sh /etc/inotifyfilechange_arm.sh
sudo cp /home/aicshp/OpenPLC_v3/webserver/scripts/start_plc.sh /etc/start_plc.sh

# Prompt user to set up crontab
echo ""
echo "Add the following to crontab: "
echo "1 * * * * @reboot bash /etc/inotifyfilechange_arm.sh"
echo "1 * * * * :@reboot bash /etc/start_plc.sh"
echo ""

sudo crontab -e
