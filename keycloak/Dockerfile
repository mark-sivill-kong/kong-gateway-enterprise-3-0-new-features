FROM quay.io/keycloak/keycloak:19.0.3

LABEL maintainer="Mark Sivill - Kong"
LABEL description="Pre built Keycloak with pre-created realms and users ready for importing"

#
# build keycloak with pre-defined realms and users using
# bin/kc.sh start --import-realm
#
# to export realm/user details within container use
# /opt/keycloak/bin/kc.sh export --dir /opt/keycloak/data --users realm_file
#

RUN mkdir /opt/keycloak/data/import
COPY ./files/import/*.json /opt/keycloak/data/import

USER root
RUN chown -R keycloak /opt/keycloak/data/import

USER keycloak

