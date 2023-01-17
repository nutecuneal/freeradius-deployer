FROM ubuntu:22.10

EXPOSE 1812-1813/udp

RUN apt-get update -y
RUN apt-get upgrade -y

RUN apt-get install freeradius=3.* \
    freeradius-mysql=3.* -y

RUN apt-get install nano -y

#COPY ./freeradius /etc/freeradius

ENTRYPOINT [ "/usr/sbin/freeradius", "-f" ]