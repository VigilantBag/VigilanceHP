#!/bin/sh

# install AICSHP just to make sure this is done uncomment if the rest of the AICSHP github is not installed
# git clone https://github.com/VigilantBag/AICSHP.git 
sudo apt update
# install honeyd & dependencies
sudo apt install curl gnupg lsb-release  libevent-dev libdumbnet-dev libpcap-dev libpcre3-dev libedit-dev bison tshark autogen make cmake gnome-terminal ca-certificates flex libtool automake python3 python3-pip build-essential zlib1g-dev

# Install Docker Desktop
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Install mininet
sudo apt install mininet

# Install minicps 
pip3 install minicps
pip3 install testresources

# install modified IHS directory
cd ./ICSpot/
git clone https://github.com/VigilantBag/IHS.git

# install flask and flask_socketio
pip3 install flask
pip3 install flask-socketio
# install farpd & fix the script paths so they match the absolute paths of file system
sudo apt install farpd
