#!/bin/bash
# Prepares the system to run OpenPLC Runtime and run OpenPLC Runtime

# Move to a known directory
cd /home/aicshp/

# Update the system, install dependencies, and grab required files
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y git vsftpd inotify-tools docker.io python3-pip iptables-persistent
sudo pip3 install pymodbus
wget https://raw.githubusercontent.com/VigilantBag/AICSHP/openplc/arm_based_installation/preconfigured_files/vsftpd.conf
wget https://raw.githubusercontent.com/VigilantBag/AICSHP/openplc/arm_based_installation/scripts/inotifyfilechange_arm.sh

# Clone the OpenPLC runtime repo
git clone https://github.com/thiagoralves/OpenPLC_v3.git /home/aicshp/OpenPLC_v3

# Run OpenPLC's installation script
cd /home/aicshp/OpenPLC_v3
bash /home/aicshp/OpenPLC_v3/install.sh rpi

# Move and utilize the pre-configured vsftpd file
cd /home/aicshp/
sudo chmod 644 vsftpd.conf
sudo chown root:root vsftpd.conf
sudo rm /etc/vsftpd.conf
sudo cp /home/aicshp/vsftpd.conf /etc/vsftpd.conf

# Configure and move vsftpd.user_list file
echo aicshp > ./vsftpd.user_list
sudo chmod 644 ./vsftpd.user_list
sudo chown root:root ./vsftpd.user_list
sudo cp /home/aicshp/vsftpd.user_list /etc/vsftpd.user_list

# Create the ftp server
cd /home/aicshp/OpenPLC_v3/webserver/st_files

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
# Keep ufw disabled to avoid IPTables conflict

# Correct permissions, ownership and add inotify script to /etc/
cd /home/aicshp/
sudo chmod 755 ./inotifyfilechange_arm.sh
sudo chown root:root ./inotifyfilechange_arm.sh
sudo cp /home/aicshp/inotifyfilechange_arm.sh /etc/inotifyfilechange_arm.sh
sudo cp /home/aicshp/OpenPLC_v3/webserver/scripts/start_openplc.sh /etc/start_openplc.sh
echo "cd /home/aicshp/OpenPLC_v3/webserver" >> start_plc.sh
echo "python2.7 webserver.py" >> start_plc.sh
sudo mv start_plc.sh /etc/

# Add Zeek and Tshark Logging
sudo groupadd docker
sudo usermod -aG docker aicshp
newgrp docker

# Configure IPTables to allow docker to be run in promiscuous mode
sudo sysctl net.ipv4.conf.all.forwarding=1
sudo systemctl enable netfilter-persistent.service
sudo iptables -P FORWARD ACCEPT
sudo /sbin/iptables-save > /etc/iptables/rules.v4
sudo systemctl enable docker.service

# Set up crontab
sudo su -
echo "1 * * * * @reboot root /etc/inotifyfilechange_arm.sh" >> /var/spool/cron/crontabs/root
echo "1 * * * * @reboot root /etc/start_openplc.sh" >> /var/spool/cron/crontabs/root
echo "net.ipv4.conf.all.forwarding=1" >> /etc/sysctl.conf