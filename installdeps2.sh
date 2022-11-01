#!/bin/sh

# Install mininet
sudo apt-get install mininet

# Install minicps 
pip2 install minicps
pip2 install testresources

# install modified IHS directory
cd ./ICSpot/
git clone https://github.com/VigilantBag/IHS.git

# install flask and flask_socketio
pip3 install flask==1.1.1
pip3 install flask-socketio==4.2.1
