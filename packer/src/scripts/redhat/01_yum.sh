#!/bin/sh -eux


## Once firewall request
curl --insecure --output katello-ca-consumer-latest.noarch.rpm https://satellite.yoox.net/pub/katello-ca-consumer-latest.noarch.rpm

yum localinstall -y katello-ca-consumer-latest.noarch.rpm

hostname

cat /etc/rhsm/rhsm.conf

## Once firewall request
subscription-manager register --org=YNAP --activationkey=AK_TO_TEST

## Once firewall request
yum update -y

## Once firewall request
yum install -y vim openssh-clients perl ca-certificates net-tools bind-utils wget unzip traceroute telnet nfs-utils yum-utils at ntp ntpdate lsof redhat-lsb-core screen oddjob sssd samba-common-tools samba-libs open-vm-tools realmd oddjob-mkhomedir adcli krb5-workstation

yum clean all

subscription-manager unregister
subscription-manager clean

rpm -e $(rpm -qa | grep katello-ca-consumer)

rm -f katello-ca-consumer-latest.noarch.rpm

mv /etc/rhsm/rhsm.conf.kat-backup /etc/rhsm/rhsm.conf 2>/dev/null || /bin/true