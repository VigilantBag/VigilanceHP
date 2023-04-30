#!/bin/sh
echo ONLY RUN AFTER YOU REBOOTED FROM installdeps.sh
echo Continue? \(y\/N\)
read confirm
if [ $confirm = "y" ]
then
    git clone https://github.com/VigilantBag/ICSPOT/ -b openplc
    cd ICSPOT/Logging/
    docker run -d --name elasticsearch -p 9200:9200 -e discovery.type=single-node blacktop/elasticsearch:x-pack-7.4.0 
    sleep 30s
    docker run -d --name kibana -p 5601:5601 --link elasticsearch -e xpack.reporting.enabled=false blacktop/kibana:x-pack-7.4.0 
    echo Waiting for Kibana to start...
    sleep 3m
    docker run -d --init -it -v `pwd`:/pcap --link kibana --link elasticsearch blacktop/filebeat:7.4.0 -e
    docker run -d --cap-add=NET_RAW --net=host -v `pwd`:/pcap:rw blacktop/zeek:elastic -i af_packet::ens18 local
    echo Kibana available on localhost:5601
    docker update --restart unless-stopped $(docker ps -q)
else
    exit
fi