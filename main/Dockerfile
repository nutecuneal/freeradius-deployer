FROM ubuntu:latest

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install nano freeradius freeradius-mysql

COPY ./freeradius /etc/freeradius

ENTRYPOINT [ "/etc/init.d/freeradius", "start" ]