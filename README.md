# Kong Gateway Enterprise 3.0 new features

A docker-compose project which shows the following new Kong Gateway Enterprise 3.0 features
* manager web interface
* open telemetry using [Jaeger](https://www.jaegertracing.io/)
* websocket plugins
* plugin ordering
* secrets using [Hashicorp Vault](https://www.vaultproject.io/)

This project has been only been tested on localhost machine setups. Built for demonstration purposes only not to be used in production.

## Prerequisites

* This github project copied to the localhost machine
* Working versions of docker and docker-compose on the localhost machine
* A Kong enterprise license key

## Pre-setup

* Create the environment variable ```KONG_LICENSE_DATA``` with the value of the Kong license key
* build the project by navigating to the directory where ```docker-compose.yml``` is located and run the command
```
docker-compose build --no-cache
```
## Running

From the shell where ```KONG_LICENSE_DATA``` is setup, navigate to the directory where ```docker-compose.yml``` is located and run the command
```
docker-compose up
```
Start up time is approximately 3-5 mins on modern pc with 8 CPUs and 16GB RAM. To check if everything has started correctly
* Login to [Kong Manager](http://localhost:8002/) with username ```kong_admin``` and password ```kong_admin```, navigate to [Kong Manager Workspaces](http://localhost:8002/overview) then ensure the "License expiration" is above 1 day

## Useful demonstration links

* [Kong Manager - Kong3 workspace](http://localhost:8002/kong3/dashboard) username ```kong_admin``` password ```kong_admin``` 
* [Jaeger](http://localhost:16686) to view Kong opentelemetery data, ensure kong is in the dropdown
* [Default plugin order endpoint](http://localhost:8000/plugin-order/default)
* [Changed plugin order endpoint](http://localhost:8000/plugin-order/changed)
* [Websockets server](http://localhost:9898)
* [Hashicorp Vault](http://localhost:8200) method ```Token``` token ```Token```
* [OpenID Connect endpoint](http://localhost:8000/secret/oidc) username ```kong3``` password ```kong3```
* [Keycloak](http://localhost:8080) username ```admin``` password ```admin``` where OpenID Connect user ```kong3``` is configured

## Stopping

From the shell where docker-compose is running type ```Control-c``` and run the commands
```
docker-compose down
docker volume prune -f
```

## Third party assets

The following assets are included in this repository which may have their own licensing terms

* [Websockets service](https://github.com/mheap/websocket-spike-test) to demonstrate websocket plugins
* [3 Image](https://www.svgrepo.com/svg/7916/three) for workspace images
* [Transport for London Unified API](https://api.tfl.gov.uk) as example API specifications within developer portal
* [Wikimedia REST API](https://en.wikipedia.org/api/rest_v1/) as example API specifications within developer portal
