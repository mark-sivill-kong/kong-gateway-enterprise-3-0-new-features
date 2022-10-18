const http = require("http");
const fs = require("fs");
const path = require("path");
const WebSocketServer = require("websocket").server;

console.info("Starting websockets service")

const server = http.createServer(function (request, response) {
  var filePath = path.join(__dirname, "index.html");

  response.writeHead(200, {
    "Content-Type": "text/html",
  });

  response.end(fs.readFileSync(path.join(__dirname, "index.html")));
});
server.listen(9898);

const wsServer = new WebSocketServer({
  httpServer: server,
});

console.info("Websockets service listening")

wsServer.on("request", function (request) {

  const connection = request.accept(null, request.origin);

  connection.on("message", function (message) {
    console.info("Received Message:", message.utf8Data);
    connection.sendUTF("Received Message:" + message.utf8Data);
  });

  connection.on("close", function (reasonCode, description) {
    console.info("Client has disconnected.");
  });

});
