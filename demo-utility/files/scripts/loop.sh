#!/bin/sh

#
# create never ending loop that keeps container alive
# to allow kong tooling within the container to be accessed
# i.e docker exec -it <my-container-id> /bin/sh
#

env

echo "`date`"

while true
do
	echo "`date` Sleeping"
	sleep 30
done


