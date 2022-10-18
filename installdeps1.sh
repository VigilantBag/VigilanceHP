#!/bin/sh

# install honeyd & dependencies
apt-get install libevent-dev libdumbnet-dev libpcap-dev libpcre3-dev libedit-dev bison flex libtool automake python2

git clone https://github.com/DataSoft/Honeyd.git
cd ./Honeyd/
bash ./autogen.sh
bash ./configure
make 
make install
cd ../

# install farpd & fix the script paths so they match the absolute paths of file system
apt install farpd
git clone https://github.com/VigilantBag/ICSpot.git

echo ""
echo "Change ICSpot/honeyd.conf to the actual filepath pointing to the files in the scripts folder (lines 20-22)."
echo "After that, Run the second install script."
echo ""
