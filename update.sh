#!/bin/bash
git submodule foreach git pull origin master
home=$PWD
cd perkin
mvn clean package
cd $home
eval $(docker-machine env)
docker-compose up
