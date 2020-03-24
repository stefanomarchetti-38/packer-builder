FROM ubuntu:18.04

LABEL maintainer="ECOPS INFRASTRUCTURE - LDN <infrastructure@net-a-porter.com>"

ENV DEBIAN_FRONTEND="noninteractive"

# pre-requisite installation
RUN apt-get update && \
    apt-get -y install curl unzip git ansible jq ruby ruby-json python-dev python-pip apache2 && \
    pip install python-openstackclient && \
# packer installation
    curl -sL -o /tmp/packer.zip \
    https://releases.hashicorp.com/packer/1.5.0/packer_1.5.0_linux_amd64.zip && \
    unzip /tmp/packer.zip -d /usr/local/bin/ && \
# ovftool installation
    curl -k -o /tmp/ovftool.bundle \
    http://artifactory.yoox.net/artifactory/ynap-infrastructure-packages/VMware-ovftool-4.3.0-13981069-lin.x86_64.bundle && \
    chmod u+x /tmp/ovftool.bundle && \
    yes yes | /tmp/ovftool.bundle && \
# cleanup
    rm -rf /tmp/ovftool.bundle /tmp/packer.zip && \
    apt-get autoclean
