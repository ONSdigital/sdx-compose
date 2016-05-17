#!/bin/bash
sudo apt-get update 
sudo apt-get -y upgrade

# Git
sudo apt-get -y install git

# Maven
sudo apt-get -y install maven

# Java
sudo apt-get -y install default-jdk

# Python
sudo apt purge python2.7-minimal

# Docker
sudo apt-get install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo mkdir -p /etc/apt/sources.list.d
sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list'
sudo apt-get update
sudo apt-get -y purge lxc-docker
sudo apt-get -y install linux-image-extra-$(uname -r)
sudo apt-get -y install docker-engine
sudo sh -c 'curl -L https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose'
sudo chmod +x /usr/local/bin/docker-compose
sudo service docker start
sudo groupadd docker
sudo usermod -aG docker ubuntu

# Version checks
git --version | grep git
mvn -version | grep "Apache Maven"
java -version 2>&1 | grep openjdk
python --version 2>&1 | grep Python
echo Docker client/server versions:
sudo docker version | grep Version
echo --- Please log in again to complete installation ---
exit

