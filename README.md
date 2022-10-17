# Kong Gateway Enterprise 3.0 new features

A docker-compose project which shows the following new Kong Gateway Enterprise 3.0 features
* manager web interface
* open telemetry using honeycomb.io
* websocket plugins
* plugin ordering
* secrets using Hashicorp Vault

This project has been only been tested on a localhost machine.

## Prerequisites

* This github project copied to the localhost machine
* Working versions of docker and docker-compose on the localhost machine
* A honeycomb.io account and assoicated API key for sending opentelemetry data to the account
* A Kong enterprise license key

## Pre-setup

* Create the environment variable ```KONG_LICENSE_DATA``` with the value of the Kong license key
* Create the environment variable ```HONEYCOMB_API_KEY``` with the value of the honeycomb.io api key
* build the project by navigating to the directory where ```docker-compose.yml``` is located and run the command
```
docker-compose build --no-cache
```

## Running

From the shell where ```KONG_LICENSE_DATA``` and ```HONEYCOMB_API_KEY``` are setup, navigate to the directory where ```docker-compose.yml``` is located and run the command
```
docker-compose up
```
