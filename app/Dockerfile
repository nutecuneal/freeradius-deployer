FROM alpine:3.17.1

EXPOSE 1812-1813/udp

RUN apk update
RUN apk upgrade

RUN apk add --no-cache \
    freeradius=3.0.26-r0 \
    freeradius-mysql=3.0.26-r0

WORKDIR /etc/raddb

RUN rm sites-enabled/*

ENTRYPOINT [ "/usr/sbin/radiusd", "-f" ]
