FROM centos:centos7


MAINTAINER Lars Solberg <lars.solberg@gmail.com>
ENV REFRESHED_AT 2015-11-18

RUN yum install -y epel-release && \
    yum install -y python-pip && pip install --upgrade pip \
    yum clean all
