# Websocket Tester

This is a test environment to work with websockets. I'm using it to test Kong functionality.

## Kong Setup

### Add a license to your Gateway

```bash
export KONG_PROXY_PORT=8000
export KONG_ADMIN_PORT=8001

source ~/.local/bin/license
curl localhost:$KONG_ADMIN_PORT/licenses -d payload=$KONG_LICENSE_DATA
```

### Create a JSON validator plugin

```bash
curl localhost:$KONG_ADMIN_PORT/services -d name=websocket-validator-service -d url=ws://host.docker.internal:9898

curl localhost:$KONG_ADMIN_PORT/services/websocket-validator-service/routes -d protocols=ws -d name=ws-validator-route -d paths=/validate

curl localhost:$KONG_ADMIN_PORT/routes/ws-validator-route/plugins -d name=websocket-validator -d config.client.text.schema='{"type":"object","properties":{"hello":{"type":"string"}},"required":["hello"]}' -d config.client.text.type="draft4"
```

### Create a JSON frame size limit plugin

The `config.client_max_payload` value is the size in **bytes**.

```
curl localhost:$KONG_ADMIN_PORT/services -d name=websocket-framesize-service -d url=ws://host.docker.internal:9898

curl localhost:$KONG_ADMIN_PORT/services/websocket-framesize-service/routes -d protocols=ws -d name=ws-framesize-route -d paths=/size

curl localhost:$KONG_ADMIN_PORT/routes/ws-framesize-route/plugins -d name=websocket-size-limit -d config.client_max_payload=64
```

## App setup

* The app is a node.js app. 
* Install dependencies by running `npm install`. 
* Open up `index.html` and make sure that the `port` value at the top is set to the `KONG_PROXY_PORT` value
* Start the app with `node index.js`.
* Visit http://localhost:9898/

There are six buttons at the top. By default you'll connect to the `/validate` endpoint. If you use the `Schema: Valid` button you'll get a response. If you use the `Schema: Invalid` button you'll get disconnected.

To switch to the size limit plugin, click `Switch to /size`. Now you want to use the `Size: 64 bytes` and `Size: 65 bytes` buttons. 64 bytes is the limit, and 65 will disconnect you.
