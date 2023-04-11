#!/bin/sh
sudo groupadd docker
sudo usermod -aG docker aicshp
newgrp docker

echo "Please restart"