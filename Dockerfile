FROM ubuntu:trusty
MAINTAINER Jonas Svatos <lsde@lsde.org>

ENV DEBIAN_FRONTEND=noninteractive
ENV SKIP_BUILD_STACK=YES

RUN apt-get update && apt-get install -y wget git openssh-server supervisor
RUN groupadd -g 1001 docker
RUN useradd -u 1000 -G 1001 dokku
RUN mkdir /var/run/sshd

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

USER root
WORKDIR /root
RUN git clone https://github.com/lsde/dokku.git

WORKDIR /root/dokku
RUN ./bootstrap.sh

RUN locale-gen en_US.UTF-8

EXPOSE 22 80 443
CMD ["/usr/bin/supervisord"]
