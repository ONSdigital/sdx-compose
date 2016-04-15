# Dockers

This repository contains a collection of dockerfiles used throughout the Office of National Statistics (ONS) Survey Data Exchange (SDE) project. The root of the repo contains a docker-compose yaml which builds all elements of the SDE project, along with test tools.

In order to build the docker-compose app, you'll need to check out [Perkin](https://github.com/ONSdigital/perkin), [Posie](https://github.com/ONSdigital/posie) and [sde-console](https://github.com/ONSdigital/sde-console) into the same directory as the compose yaml file. After executing docker-compose up, the sde-console app will be exposed on the containers ip address.

NB: There is a [known bug](https://github.com/docker/machine/issues/3222) with docker-compose which affects flask/alpine based docker images. Unforunately this means that the latest docker (1.10) does not sync changes properly from the flask app to the docker containers. If you want to see changes to the flask app following a build, you either need to be using the current docker for mac beta (which doesn't use virtualbox) or completely destroy your docker machine and build again.