#!/bin/sh
echo This can ONLY be run on the HOST machine, not a VM.
echo Continue? \(y\/n\)
read confirm
if [ $confirm = "n" ]
then
    exit
else
    apt update
    apt install gnome-terminal ca-certificates gnupg curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt update
    apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    git clone https://github.com/VigilantBag/ICSPOT/ -b openplc
    cd ICSPOT/Logging/
    docker run -d --cap-add=NET_ADMIN --name elasticsearch -p 9200:9200 -e discovery.type=single-node blacktop/elasticsearch:x-pack-7.4.0 
    sleep 30s
    docker run -d --cap-add=NET_ADMIN --name kibana -p 5601:5601 --link elasticsearch -e xpack.reporting.enabled=false blacktop/kibana:x-pack-7.4.0 
    echo Waiting for Kibana to start...
    sleep 3m
    docker run -d --cap-add=NET_ADMIN --init -it -v `pwd`:/pcap --link kibana --link elasticsearch blacktop/filebeat:7.4.0 -e
    docker run -d --cap-add=NET_ADMIN --net=host -v `pwd`:/pcap:rw blacktop/zeek:elastic -i af_packet::ens18 local
    echo Kibana available on localhost:5601
    docker update --restart unless-stopped $(docker ps -q)
fi