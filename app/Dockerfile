FROM alpine:3.17.1

EXPOSE 1812-1813/udp

# Variables
ARG CONF_RADIUSD=raddb/radiusd.conf
ARG CONF_MODS=raddb/mods-available
ARG CONF_SITES=raddb/sites-available

# installation: app and dependencies
RUN apk update
RUN apk upgrade

RUN apk add --no-cache openssl

RUN apk add --no-cache \
    freeradius=3.0.26-r0 \
    freeradius-mysql=3.0.26-r0 \
    freeradius-sqlite=3.0.26-r0 \
    freeradius-utils=3.0.26-r0 \
    freeradius-eap=3.0.26-r0

# Entrypoint
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Certificate - SSL/TLS
WORKDIR /etc/ssl/certs

RUN openssl genrsa -out radiusCA.key 2048
RUN openssl req -new -x509 -sha256 -key radiusCA.key -days 3650 -subj "/" -out radiusCA.pem

RUN chown :radius ./*
RUN chmod 751 ./*

# Raddb-config
WORKDIR /etc/raddb

RUN rm clients.conf
RUN rm radiusd.conf

COPY ${CONF_RADIUSD} radiusd.conf

## Config: sites-{available,enable} 
RUN mv sites-available sites-available-tmp
COPY ${CONF_SITES} sites-available

RUN rm -rf sites-enabled/*

RUN ln -s /etc/raddb/sites-available/* sites-enabled

RUN mv sites-available-tmp/* sites-available

RUN rm -rf sites-available-tmp

## Config: mods-{available,enable}
RUN mv mods-available mods-available-tmp
COPY ${CONF_MODS} mods-available

RUN ln -s /etc/raddb/mods-available/* mods-enabled

RUN mv mods-available-tmp/* mods-available

RUN rm -rf mods-available-tmp
RUN rm mods-available/sql

## Config: authorize file (test user)
RUN printf "bobtest Cleartext-Password := 1234\n" >> mods-config/files/authorize

## Config: mods-available - content
WORKDIR /etc/raddb/mods-available

### eap file
RUN sed -i -e \
    's/private_key_password.*=.*whatever/#private_key_password = whatever/g' eap

RUN sed -i -e \
    's/private_key_file.*=.*\.pem/private_key_file = \${certdir}\/radiusCA.key/g' eap

RUN sed -i -e \
    's/certificate_file.*=.*\.pem/certificate_file = \${certdir}\/radiusCA.pem/g' eap

RUN sed -i -e \
    's/ca_file.*=.*\.pem/ca_file = \${cadir}\/ca-certificates.crt/g' eap

WORKDIR /etc/raddb/

ENTRYPOINT [ "/entrypoint.sh"]
