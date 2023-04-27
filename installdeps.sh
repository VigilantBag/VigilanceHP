#!/bin/bash
# Prepare the system to run OpenPLC Runtime and run OpenPLC Runtime

# Move to a known directory
cd /home/vhp/

# Update the system, install dependencies, and grab required files
sudo apt-get -y update
sudo DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade
sudo DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install git vsftpd inotify-tools docker.io python3-pip iptables-persistent
sudo pip3 install pymodbus
wget https://raw.githubusercontent.com/VigilantBag/VigilanceHP/openplc/arm_based_installation/preconfigured_files/vsftpd.conf
wget https://raw.githubusercontent.com/VigilantBag/VigilanceHP/openplc/arm_based_installation/preconfigured_files/startplc.service
wget https://raw.githubusercontent.com/VigilantBag/VigilanceHP/openplc/arm_based_installation/preconfigured_files/inotify.service
wget https://raw.githubusercontent.com/VigilantBag/VigilanceHP/openplc/arm_based_installation/scripts/inotifyfilechange_arm.sh

# Clone the OpenPLC runtime repo
git clone https://github.com/thiagoralves/OpenPLC_v3.git /home/vhp/OpenPLC_v3

# Run OpenPLC's installation script
cd /home/vhp/OpenPLC_v3
bash /home/vhp/OpenPLC_v3/install.sh linux

# Move and utilize the pre-configured vsftpd file
cd /home/vhp/
sudo chmod 644 vsftpd.conf
sudo chown root:root vsftpd.conf
sudo rm /etc/vsftpd.conf
sudo cp /home/vhp/vsftpd.conf /etc/vsftpd.conf

# Configure and move vsftpd.user_list file
echo vhp > ./vsftpd.user_list
sudo chmod 644 ./vsftpd.user_list
sudo chown root:root ./vsftpd.user_list
sudo cp /home/vhp/vsftpd.user_list /etc/vsftpd.user_list
sudo cp /home/vhp/inotify.service /etc/systemd/system/inotify.service
sudo cp /home/vhp/startplc.service /etc/systemd/system/startplc.service

# Create the ftp server
cd /home/vhp/OpenPLC_v3/webserver/st_files

# Restart the vsftpd
sudo systemctl restart vsftpd

# Ensure FTP traffic is allowed through the firewall
sudo ufw allow 20:21/tcp
sudo ufw allow 30000:31000/tcp
sudo ufw allow 502
sudo ufw allow 20000
sudo ufw allow 44818
sudo ufw allow 5601
sudo ufw allow from any to any proto tcp port 10090:10100

# sudo ufw allow 8080/tcp <--uncomment for troubleshooting/setup
# sudo ufw allow OpenSSH <-- uncomment for troubleshooting/setup

# Restart the firewall to reload the ufw rules
sudo ufw disable
sudo ufw enable

# Correct permissions, ownership and add inotify script to /etc/
cd /home/vhp/
sudo chmod 755 ./inotifyfilechange_arm.sh
sudo chown root:root ./inotifyfilechange_arm.sh
sudo cp /home/vhp/inotifyfilechange_arm.sh /etc/inotifyfilechange_arm.sh
echo "cd /home/vhp/OpenPLC_v3/webserver" >> start_plc.sh
echo "python2.7 webserver.py" >> start_plc.sh
sudo mv start_plc.sh /etc/

# Add Zeek and Tshark Logging
sudo groupadd docker
sudo usermod -aG docker vhp

# Configure IPTables to allow docker to be run in promiscuous mode

sudo systemctl daemon-reload
sudo systemctl enable docker.service
sudo systemctl enable inotify.service
sudo systemctl enable startplc.service
sudo systemctl restart inotify.service
sudo systemctl restart startplc.service