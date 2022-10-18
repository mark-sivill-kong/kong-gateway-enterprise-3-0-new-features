#!/bin/sh

#
# generate web traffic for plugin ordering routes
#

echo "`date` about to start generating traffic"

echo "`date` kong proxy url ${KONG_PROXY_URL}"

while :
do

  curl -o /dev/null -s -w "%{url} - status code %{http_code}\n" ${KONG_PROXY_URL}/plugin-order/default
  sleep $(( $RANDOM % 20 ))
  curl -o /dev/null -s -w "%{url} - status code %{http_code}\n" ${KONG_PROXY_URL}/plugin-order/changed
  sleep $(( $RANDOM % 40 ))

done

echo "`date` finished?"
