FROM ubuntu:latest

EXPOSE 1812-1813/udp

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y nano freeradius freeradius-mysql

#COPY ./freeradius /etc/freeradius

ENTRYPOINT [ "/usr/sbin/freeradius", "-f" ]