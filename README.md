# sdx-console

[![Build Status](https://travis-ci.org/ONSdigital/sdx-console.svg?branch=master)](https://travis-ci.org/ONSdigital/sdx-console)

The Survey Data Exchange (SDX) Console is a component of the Office of National Statistics (ONS) SDX project, which takes an encrypted json payload and transforms it into a number of formats for use within the ONS. This console allows for insertion of input and checking of transformed output files, using the sdx-decrypt, sdx-validate, sdx-downstream and sdx-transform-* services.


## Installation

Checkout the sdx-compose repo and refer to the README

## Usage

To use the console you will need to start all services.

## API

There are two endpoints. The default takes JSON as input, encrypts it and places it upon the app queue for SDE to decrypt and transform, whilst 'decrypt' takes an encrypted payload as input and decrypts to json and transforms to final formats.

 * `POST /`
 * `POST /decrypt`


