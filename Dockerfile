FROM centos:centos7


MAINTAINER Lars Solberg <lars.solberg@gmail.com>
ENV REFRESHED_AT 2015-11-20

# Override this if you need to
ENV TZ Europe/Oslo
ENV TERM xterm-256color
ENV LANG en_US.UTF-8
ENV PYTHONIOENCODING utf-8

RUN yum upgrade -y && yum install -y epel-release && mkdir /tmp/sockets && \
    yum install -y python-pip && pip install --upgrade pip && \
    pip install supervisor && \
    yum clean all

COPY supervisord.conf /etc/supervisord.conf
COPY init/ /init/
COPY hooks/ /hooks/

ENTRYPOINT ["/bin/sh", "-e", "/init/entrypoint"]
CMD ["run"]
