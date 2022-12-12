# Kong Gateway Enterprise 3.0 change log

## Changes between main and 3.0 branches

* Kong upgraded to 3.1
* Jeager used instead of honeycomb.io for open telemetry collection, no need for honeycomb.io API key
* Secrets are defined in deck config instead of environment variables
* Deck upgraded to 1.16.1
* Hashicorp Vault upgraded to 1.12.2
* docker-compose now has a name which is used instead of current directory name for running containers naming conventions
* create kong certificates during image build
* run kong containers from altered kong gateway image

