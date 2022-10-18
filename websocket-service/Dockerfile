FROM docker.io/library/ubuntu:22.04

LABEL maintainer="Mark Sivill - Kong"
LABEL description="Web Browser to show Kong Gateway websockets functionality"

#
# web browser client built from https://github.com/mheap/websocket-spike-test
#

RUN apt-get --yes update \
  && apt-get --yes upgrade \
  && apt-get --yes install nodejs npm

RUN useradd -ms /bin/bash default-user

COPY ./files/websocket-spike-test/index.html /home/default-user
COPY ./files/websocket-spike-test/package.json /home/default-user
COPY ./files/websocket-spike-test/index.js /home/default-user
RUN chown -R default-user:default-user /home/default-user

WORKDIR /home/default-user
USER default-user

RUN npm install

CMD [ "/usr/bin/node", "index.js" ]

