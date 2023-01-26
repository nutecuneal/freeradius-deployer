FROM alpine:3.17.1

EXPOSE 1812-1813/udp

ARG CONF_RADIUSD
ARG CONF_MOD_SQL
ARG CONF_SERVER_LOCAL
ARG CONF_SERVER_HOST

RUN apk update
RUN apk upgrade

RUN apk add --no-cache openssl

RUN apk add --no-cache \
    freeradius=3.0.26-r0 \
    freeradius-mysql=3.0.26-r0 \
    freeradius-sqlite=3.0.26-r0 \
    freeradius-utils=3.0.26-r0 \
    freeradius-eap=3.0.26-r0

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh


WORKDIR /etc/ssl/certs

RUN openssl genrsa -out radiusCA.key 2048
RUN openssl req -new -x509 -sha256 -key radiusCA.key -days 3650 -subj "/" -out radiusCA.pem

RUN chown radius:radius ./*

WORKDIR /etc/raddb/mods-available

RUN sed -i -e \
    's/private_key_password.*=.*whatever/#private_key_password = whatever/g' eap

RUN sed -i -e \
    's/private_key_file.*=.*\.pem/private_key_file = \${certdir}\/radiusCA.key/g' eap

RUN sed -i -e \
    's/certificate_file.*=.*\.pem/certificate_file = \${certdir}\/radiusCA.pem/g' eap

RUN sed -i -e \
    's/ca_file.*=.*\.pem/ca_file = \${cadir}\/ca-certificates.crt/g' eap


WORKDIR /etc/raddb

RUN rm clients.conf
RUN rm radiusd.conf
RUN rm -rf sites-enabled/*
RUN rm mods-available/sql

COPY ${CONF_RADIUSD} ./
COPY ${CONF_MOD_SQL} mods-available/freeradius-sql
COPY ${CONF_SERVER_LOCAL} sites-available/freeradius-local
COPY ${CONF_SERVER_HOST} sites-available/freeradius

RUN ln -s /etc/raddb/mods-available/freeradius-sql mods-enabled
RUN ln -s /etc/raddb/sites-available/freeradius-local sites-enabled
RUN ln -s /etc/raddb/sites-available/freeradius sites-enabled

RUN printf "bobtest Cleartext-Password := 1234\n" >> mods-config/files/authorize

ENTRYPOINT [ "/entrypoint.sh"]
