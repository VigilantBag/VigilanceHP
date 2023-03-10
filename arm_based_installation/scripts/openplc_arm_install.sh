#!/bin/bash

# Prepare the system to run OpenPLC Runtime and run OpenPLC Runtime

# Update the system and install git
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install git

# Clone the OpenPLC runtime repo
git clone https://github.com/thiagoralves/OpenPLC_v3.git

# Run OpenPLC's installation script and start OpenPLC runtimme
cd ~/OpenPLC_v3
bash ./install.sh rpi
bash ./start_openplc.sh