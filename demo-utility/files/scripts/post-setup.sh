#!/bin/sh

#
#  post setup which creates
#  a) secrets within Hashicorp value
#  b) kong configuration
#  c) creates developer portal
#  d) adds open api specs to portal

#
# vault / secrets post setup for OpenID Connect
# accessed within Kong using {vault://hcv/oauth-client/client-id}
# and {vault://hcv/oauth-client/client-secret}
#
curl --header X-Vault-Token:${VAULT_DEV_ROOT_TOKEN_ID} --request POST --data '{"type": "kv","options": {"version": "2"}}' ${VAULT_API_URL}/v1/sys/mounts/kong-secrets
VAULT_SECRET_OAUTH_DATA="{\"data\":{ \"client-id\": \"$VAULT_KONG_OAUTH_CLIENT_ID\", \"client-secret\": \"$VAULT_KONG_OAUTH_CLIENT_SECRET\"}}"
curl --header X-Vault-Token:${VAULT_DEV_ROOT_TOKEN_ID} --request POST --data "${VAULT_SECRET_OAUTH_DATA}" ${VAULT_API_URL}/v1/kong-secrets/data/oauth-client

#
# check honeycomb api key environment variable
#
if [[ -z "${HONEYCOMB_API_KEY}" ]]; then
  echo "`date` exiting as HONEYCOMB_API_KEY environment variable not found"
  exit 1
fi

#
# kong post setup
#

#
# determine if role based access control (RBAC) header is required
#
if [[ -z "${KONG_PASSWORD}" ]]; then
  echo "`date` KONG_PASSWORD not found"
  DECK_RBAC_HEADER=""
  CURL_RBAC_HEADER=""
else
  echo "`date` KONG_PASSWORD found"
  DECK_RBAC_HEADER="--headers \"kong-admin-token:$KONG_PASSWORD\""
  CURL_RBAC_HEADER="--header kong-admin-token:$KONG_PASSWORD"

fi

echo "`date` DECK_RBAC_HEADER is ${DECK_RBAC_HEADER}"
echo "`date` CURL_RBAC_HEADER is ${CURL_RBAC_HEADER}"

#
# set up via kong deck
#

echo "`date` about to deck ping"

deck ping --kong-addr ${KONG_GATEWAY_API_URL} --verbose 2 ${DECK_RBAC_HEADER}

cd ${HOME}/kong_config

echo "`date` about to deck sync"

deck sync --workspace default --state default.yaml --kong-addr ${KONG_GATEWAY_API_URL} ${DECK_RBAC_HEADER}
deck sync --workspace kong3 --state kong3.yaml --kong-addr ${KONG_GATEWAY_API_URL} ${DECK_RBAC_HEADER}

#
# dynamically add opentelemetery
#
result=$(curl -X POST ${CURL_RBAC_HEADER} ${KONG_GATEWAY_API_URL}/kong3/plugins \
    --data "name=opentelemetry"  \
    --data "config.endpoint=https://api.honeycomb.io/v1/traces" \
    --data "config.headers.x-honeycomb-team=${HONEYCOMB_API_KEY}" \
    --data "config.batch_span_count=200" \
    --data "config.batch_flush_delay=3"
)
echo "`date` - added opentelemetry - ${result}"

#
# bump default workspace to enable it from browser
#

echo "`date` bumping workspaces to enable them"
echo "`date` - bumping - `curl -X PATCH ${CURL_RBAC_HEADER} ${KONG_GATEWAY_API_URL}/workspaces/default --data 'config.portal=true'`"
echo "`date` - bumping - `curl -X PATCH ${CURL_RBAC_HEADER} ${KONG_GATEWAY_API_URL}/workspaces/kong3 --data 'config.portal=true'`"

#
# add thumbnail to workspaces
#

echo "`date` adding thumbnails to workspaces"
WORKSPACE_THUMBNAIL="data:image/png;base64,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"

result=$(curl -X PATCH -H 'Content-Type: application/json;charset=UTF-8' ${CURL_RBAC_HEADER} ${KONG_GATEWAY_API_URL}/workspaces/default  --data-raw '{ "meta":{ "thumbnail":"'${WORKSPACE_THUMBNAIL}'"}}' )
echo "`date` - workspace thumbnail patch result - ${result}"

result=$(curl -X PATCH -H 'Content-Type: application/json;charset=UTF-8' ${CURL_RBAC_HEADER} ${KONG_GATEWAY_API_URL}/workspaces/kong3  --data-raw '{ "meta":{ "thumbnail":"'${WORKSPACE_THUMBNAIL}'"}}' )
echo "`date` - workspace thumbnail patch result - ${result}"

#
# publishing openapi specifications to developer portal
#
for filepath in ${HOME}/openapi_specs/*.yaml
do

  file=$(basename ${filepath})

  echo "`date` filename - ${filepath} file - ${file}"
  result=$(curl -X POST -s -w "status code %{http_code}" ${CURL_RBAC_HEADER} ${KONG_GATEWAY_API_URL}/default/files -F "path=specs/${file}" -F "contents=@${HOME}/openapi_specs/${file}")
  echo "`date` - ${file} openapi default publish results - ${result}"
  result=$(curl -X POST -s -w "status code %{http_code}" ${CURL_RBAC_HEADER} ${KONG_GATEWAY_API_URL}/kong3/files -F "path=specs/${file}" -F "contents=@${HOME}/openapi_specs/${file}")
  echo "`date` - ${file} openapi kong3 publish results - ${result}"

done

#
# remove some of the openapi specifications
#
result=$(curl -X DELETE ${CURL_RBAC_HEADER} ${KONG_GATEWAY_API_URL}/kong3/files/specs/petstore.yaml)
echo "`date` - remove openapi specification - ${result}"

result=$(curl -X DELETE ${CURL_RBAC_HEADER} ${KONG_GATEWAY_API_URL}/default/files/specs/petstore.yaml)
echo "`date` - remove openapi specification - ${result}"

result=$(curl -X DELETE ${CURL_RBAC_HEADER} ${KONG_GATEWAY_API_URL}/kong3/files/specs/callback-example.yaml)
echo "`date` - remove openapi specification - ${result}"

result=$(curl -X DELETE ${CURL_RBAC_HEADER} ${KONG_GATEWAY_API_URL}/default/files/specs/callback-example.yaml)
echo "`date` - remove openapi specification - ${result}"



