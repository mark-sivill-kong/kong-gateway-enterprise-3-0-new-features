FROM docker.io/kong/deck:v1.16.1

LABEL maintainer="Mark Sivill - Kong"
LABEL description="Docker demo utility image that is used for post setup, generating traffic, and provding access to kong tooling"

#
# use deck docker image (alpine based) and add curl to it 
#

USER root

RUN apk update \
  && apk upgrade \
  && apk add curl \
  && mkdir /home/deckuser/openapi_specs \
  && mkdir /home/deckuser/kong_config

COPY ./files/openapi_specs /home/deckuser/openapi_specs
COPY ./files/kong_config /home/deckuser/kong_config
COPY ./files/scripts /home/deckuser/scripts

RUN chmod oug+x /home/deckuser/scripts/*.sh \
  && chown -R deckuser:deckuser /home/deckuser/*

ENV PATH "$PATH:/home/deckuser/scripts"

USER deckuser
WORKDIR /home/deckuser/

ENTRYPOINT ["/bin/sh", "/home/deckuser/scripts/loop.sh"]
