FROM ubuntu:trusty
MAINTAINER Jonas Svatos <lsde@lsde.org>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y wget git openssh-server supervisor
RUN groupadd -g 1001 docker
RUN useradd -u 1000 -G 1001 dokku
USER root
WORKDIR /root
RUN git clone https://github.com/progrium/dokku.git

WORKDIR /root/dokku
RUN git checkout 929-mh-conditionally-run-buildstack
RUN ./bootstrap.sh

RUN locale-gen en_US.UTF-8
RUN locale-gen cs_CZ.UTF-8
RUN mkdir /var/run/sshd
RUN ln -sf /home/dokku/HOSTNAME /home/dokku/VHOST
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22 80 443
CMD ["/usr/bin/supervisord"]
