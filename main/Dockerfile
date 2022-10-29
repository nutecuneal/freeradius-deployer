FROM ubuntu:22.10

EXPOSE 1812-1813/udp

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y nano \
    freeradius=3.* \
    freeradius-mysql=3.*

#COPY ./freeradius /etc/freeradius

ENTRYPOINT [ "/usr/sbin/freeradius", "-f" ]