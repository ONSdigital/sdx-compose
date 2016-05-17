# Dockers

This repository contains a collection of dockerfiles used throughout the Office of National Statistics (ONS) Survey Data Exchange (SDE) project. The root of the repo contains a docker-compose yaml which builds all elements of the SDE project, along with test tools.

In order to build the docker-compose app, the following projects are configured as submodules: [Perkin](https://github.com/ONSdigital/perkin), [sdx-decrypt](https://github.com/ONSdigital/sdx-decrypt), [sde-bdd](https://github.com/ONSdigital/sde-bdd) and [sde-console](https://github.com/ONSdigital/sde-console). 

 For development you'll need something like:

 - docker-machine
 - docker-compose
 - git
 - maven 3
 - java 8
 - python 3

To get the environment running:

  - ./init.sh  # clones submodules
  - ./update.sh  # pulls the latest version of each submodule, runs `mvn package` in the `perkin` project and calls `docker-compose up`

After a `docker-compose up`, the `sde-console` app will be exposed on the host ip address (on port 80).

To work on an SDX component:

  - check out a separate copy of the component you want to work with (it's easier than dealing with submodules)
  - scale the component you want to develop down to zero in the compose setup, e.g. `docker-compose scale sdx-decrypt=0`
  - build and start the component you're working on and attach it to the network used by the docker compose setup using `--net=...`
 
