FROM alpine:3.17.1

EXPOSE 1812-1813/udp

RUN apk update
RUN apk upgrade

RUN apk add --no-cache \
    freeradius=3.0.26-r0 \
    freeradius-mysql=3.0.26-r0 \
    freeradius-sqlite=3.0.26-r0

COPY ./entrypoint.sh /

RUN chmod +x /entrypoint.sh

WORKDIR /etc/raddb

ENTRYPOINT [ "/entrypoint.sh"]
