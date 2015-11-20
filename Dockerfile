FROM centos:centos7


MAINTAINER Lars Solberg <lars.solberg@gmail.com>
ENV REFRESHED_AT 2015-11-20

RUN yum upgrade -y && yum install -y epel-release && mkdir /tmp/sockets && \
    yum install -y python-pip && pip install --upgrade pip && \
    pip install supervisor && \
    yum clean all

COPY supervisord.conf /etc/supervisord.conf
COPY init/ /init/
COPY hooks/ /hooks/

ENTRYPOINT ["/bin/sh", "-e", "/init/entrypoint"]
CMD ["run"]
