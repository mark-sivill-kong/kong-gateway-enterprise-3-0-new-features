FROM docker.io/kong/kong-gateway:3.1

LABEL maintainer="Mark Sivill - Kong"
LABEL description="Docker demo utility image that is used for post setup, generating traffic, and provding access to kong tooling"

#
# create a kong certificates upfront
#

USER root

RUN mkdir /home/kong/ \
  && mkdir /home/kong/certificates \
  && chown -R kong:kong /home/kong

USER kong
RUN kong hybrid gen_cert /home/kong/certificates/cluster.crt /home/kong/certificates/cluster.key
