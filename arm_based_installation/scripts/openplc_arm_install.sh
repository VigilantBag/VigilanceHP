#!/bin/bash
# Prepares the system to run OpenPLC Runtime and run OpenPLC Runtime

# Obtain the current user name
echo "Enter your selected user name: "
read USER_NAME

# Update the system, install dependencies, and grab required files
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install git vsftpd inotify-tools
curl https://raw.githubusercontent.com/VigilantBag/AICSHP/openplc/arm_based_installation/preconfigured_files/vsftpd.conf > vsftpd.conf
curl https://raw.githubusercontent.com/VigilantBag/AICSHP/openplc/arm_based_installation/scripts/inotifyfilechange_arm.sh > inotifyfilechange_arm.sh

# Clone the OpenPLC runtime repo
cd /home/$USER_NAME
git clone https://github.com/thiagoralves/OpenPLC_v3.git

# Run OpenPLC's installation script
cd /home/"$USER_NAME"/OpenPLC_v3
bash /home/$USER_NAME/OpenPLC_v3/install.sh rpi

# Move and utilize the pre-configured vsftpd file
cd /home/"$USER_NAME"
sudo chmod 644 vsftpd.conf
sudo chown root:root vsftpd.conf
sudo rm /etc/vsftpd.conf
sudo mv /home/"$USER_NAME"/vsftd.conf /etc/vsftpd.conf

# Configure and move vsftpd.user_list file
echo "$USER_NAME" > vsftpd.user_list
sudo chmod 644 vsftpd.user_list
sudo chown root:root vsftpd.user_list
sudo mv /home/"$USER_NAME"/vsftd.user_list /etc/vsftpd.user_list

# Create the ftp server
cd /home/"$USER_NAME"/OpenPLC_v3/webserver/st_files

# Restart the vsftpd
sudo systemctl restart vsftpd

# Ensure FTP traffic is allowed through the firewall
sudo ufw allow 20:21/tcp
sudo ufw allow 30000:31000/tcp

# sudo ufw allow 8080/tcp <--uncomment for troubleshooting/setup
# sudo ufw allow OpenSSH <-- uncomment for troubleshooting/setup

# Restart the firewall to reload the ufw rules
sudo ufw disable
sudo ufw enable

# Correct permissions, ownership and add inotify script to /etc/
cd /home/"$USER_NAME"
sudo chmod 755 inotifyfilechange_arm.sh
sudo chown root:root inotifyfilechange_arm.sh
sudo mv /home/"$USER_NAME"/inotifyfilechange_arm.sh /etc/inotifyfilechange_arm.sh

# Prompt user to set up crontab <-- **SOMETHING IN THIS SECTION BREAKS THINGS, MUST FIX**
echo ""
echo "The crontab command is: $ crontab -e "
echo "Add the following to crontab: "
echo "5 * * * * @reboot bash /etc/inotifyfilechange_arm.sh"
echo "5 * * * * @reboot bash /etc/start_plc.sh"
echo ""

sudo crontab -e