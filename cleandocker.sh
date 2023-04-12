#!/bin/sh
docker kill $(docker ps -aq)
docker rm $(docker ps -aq)