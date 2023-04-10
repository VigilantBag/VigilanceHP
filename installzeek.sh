#!/bin/sh
echo ONLY RUN AFTER YOU REBOOTED FROM installdeps.sh
echo Continue? \(y\/n\)
read confirm
if [ $confirm = "n" ]
then
    exit
else
    git clone https://github.com/VigilantBag/ICSPOT/ -b openplc
    cd ICSPOT/Logging/
    docker run -d --name elasticsearch -p 9200:9200 -e discovery.type=single-node blacktop/elasticsearch:x-pack-7.4.0 --restart=always
    docker run -d --name kibana -p 5601:5601 --link elasticsearch -e xpack.reporting.enabled=false blacktop/kibana:x-pack-7.4.0 --restart=always
    echo Waiting for Kibana to start...
    sleep 3m
    docker run -d --init -it -v `pwd`:/pcap --link kibana --link elasticsearch blacktop/filebeat:7.4.0 --restart=always -e
    docker run -d --cap-add=NET_RAW --net=host -v `pwd`:/pcap:rw blacktop/zeek:elastic -i af_packet::ens18 --restart=always local
    echo Kibana available on localhost:5601
    docker update --restart unless-stopped $(docker ps -q)
fi