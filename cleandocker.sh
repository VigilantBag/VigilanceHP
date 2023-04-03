#!/bin/sh
docker kill elasticsearch
docker kill kibana
docker kill zeek
docker rm elasticsearch
docker rm kibana
docker rm zeek