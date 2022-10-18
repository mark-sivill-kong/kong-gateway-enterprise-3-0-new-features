#!/bin/sh

#
#  show example kong commands for this environment
#

#
# determine if role based access control (RBAC) header is required
#
if [[ -z "${KONG_PASSWORD}" ]]; then
#  echo "`date` KONG_PASSWORD not found"
  DECK_RBAC_HEADER=""
  CURL_RBAC_HEADER=""
else
#  echo "`date` KONG_PASSWORD found"
  DECK_RBAC_HEADER="--headers kong-admin-token:$KONG_PASSWORD"
  CURL_RBAC_HEADER="--header kong-admin-token:$KONG_PASSWORD"
fi


echo ""
echo "Example commands"
echo "================"
echo ""

echo "curl -X GET ${CURL_RBAC_HEADER} ${KONG_GATEWAY_API_URL}/kong3/services"
echo "curl -X GET ${CURL_RBAC_HEADER} ${KONG_GATEWAY_API_URL}/kong3/routes"
echo "curl -X POST ${CURL_RBAC_HEADER} ${KONG_GATEWAY_API_URL}/kong3/routes/ws-framesize-route/plugins -d name=websocket-size-limit -d config.client_max_payload=4096"
echo "curl -X POST ${CURL_RBAC_HEADER} ${KONG_GATEWAY_API_URL}/kong3/routes/plugin-order-changed/plugins --data name=proxy-cache-advanced --data config.cache_ttl=10 --data config.strategy=memory --data ordering.before.access=rate-limiting-advanced"

echo ""

echo "deck ping --kong-addr ${KONG_GATEWAY_API_URL} --verbose 2 ${DECK_RBAC_HEADER}"
echo "deck dump --all-workspaces --kong-addr ${KONG_GATEWAY_API_URL} ${DECK_RBAC_HEADER}"
echo "deck sync --workspace kong3 --state kong3.yaml --kong-addr ${KONG_GATEWAY_API_URL} --verbose 2 ${DECK_RBAC_HEADER}"

echo ""


