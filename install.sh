#!/bin/bash

# Platform Linux (ubuntu 18.04)
# VM : Standard D2s v3 (2 vcpus, 8 GiB memory)
# Author : Bahadir YILMAZ
# Date : 30/04/2020

# before start don't forget chmod set for install.sh :)

sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get -y update
sudo apt-get -y install docker-ce

# Confirm Docker ver.
sudo docker -v
sleep 3   

# open port - you should also open the port from the Azure network security group.

sudo ufw allow 9200/tcp

# install elasticsearch
sudo docker pull docker.elastic.co/elasticsearch/elasticsearch:7.6.2

sleep 5

# run elasticsearch
sudo docker run -d -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.6.2

sleep 20s

# check to elasticsearch status after run
sudo curl localhost:9200
sleep 2s
sudo curl http://localhost:9200/_cluster/health?pretty
  
# or >> sudo curl -XGET 'localhost:9200/_cat/health?v&pretty'

