#!/bin/sh

# install AICSHP just to make sure this is done uncomment if the rest of the AICSHP github is not installed
# git clone https://github.com/VigilantBag/AICSHP.git 

# install honeyd & dependencies
sudo apt-get install libevent-dev libdumbnet-dev libpcap-dev libpcre3-dev libedit-dev bison flex libtool automake python3 python3-pip build-essential zlib1g-dev

# Install mininet
sudo apt-get install mininet

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
