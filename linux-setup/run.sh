#!/bin/bash
mkdir -p git
cd git
git clone https://github.com/ONSdigital/dockers
cd dockers
git reset --hard
git pull
./init.sh
./update.sh
