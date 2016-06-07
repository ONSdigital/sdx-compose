#!/bin/bash
git submodule foreach git pull origin master
home=$PWD
cd sdx-collect
mvn clean package
cd sdx-store
mvn clean package
cd $home
eval $(docker-machine env)
docker-compose up
