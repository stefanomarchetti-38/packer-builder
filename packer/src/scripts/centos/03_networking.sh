#!/bin/sh -eux

echo "Running $0"
case "$PACKER_BUILDER_TYPE" in
vmware-iso)
    os_major=`facter -p operatingsystemmajrelease`
    if [ "$os_major" -ge 7 ]; then
        # Fix slow DNS:
        # Add 'single-request-reopen' so it is included when /etc/resolv.conf is
        # generated
        # Note: not applied to centos 6 as this was causing problems with the pipeline
        # https://access.redhat.com/site/solutions/58625 (subscription required)
        echo 'RES_OPTIONS="single-request-reopen"' >>/etc/sysconfig/network;
        service network restart;
        echo 'Slow DNS fix applied (single-request-reopen)';
    fi

    # Disable IPV6
    echo 'NETWORKING_IPV6=no' >> /etc/sysconfig/network
    echo 'net.ipv6.conf.default.disable_ipv6=1' >> /etc/sysctl.conf
    echo 'net.ipv6.conf.all.disable_ipv6=1' >> /etc/sysctl.conf

    # Hosts entries and puppetca 
    echo '10.5.48.152 puppet' >> /etc/hosts
    echo '10.5.13.105 pulp.wtf.nap' >> /etc/hosts
    echo '10.5.13.110 loghost' >> /etc/hosts
    sed -i '/\[main\]/a \ \ \ \ ca_server = puppetca.nap' /etc/puppet/puppet.conf

    # Regenerate initramfs for centos 7
    # os_maj_version=`cat /etc/redhat-release  | cut -d ' ' -f 4 | cut -d '.' -f 1`
    if [ $os_major = "7"]; then
      dracut -f
    fi

    # Configure eth0 to DHCP to allow VM created from this template to get
    # before bootstrapping
    echo "DEVICE=eth0" > /etc/sysconfig/network-scripts/ifcfg-eth0
    echo "BOOTPROTO=dhcp" >> /etc/sysconfig/network-scripts/ifcfg-eth0
    echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-eth0

    ;;
esac
