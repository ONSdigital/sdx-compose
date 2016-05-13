# Dockers

This repository contains a collection of dockerfiles used throughout the Office of National Statistics (ONS) Survey Data Exchange (SDE) project. The root of the repo contains a docker-compose yaml which builds all elements of the SDE project, along with test tools.

In order to build the docker-compose app, you'll need to check out [Perkin](https://github.com/ONSdigital/perkin), [Posie](https://github.com/ONSdigital/posie), [sde-bdd](https://github.com/ONSdigital/sde-bdd) and [sde-console](https://github.com/ONSdigital/sde-console) into the same directory as the compose yaml file. After executing docker-compose up, the sde-console app will be exposed on the containers ip address.