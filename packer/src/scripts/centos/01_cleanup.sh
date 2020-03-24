#!/bin/sh -eux

echo "Running $0"
case "$PACKER_BUILDER_TYPE" in
*)
    # should output one of 'redhat' 'centos' 'oraclelinux'
    # distro="`rpm -qf --queryformat '%{NAME}' /etc/redhat-release | cut -f 1 -d '-'`"

    # Remove development and kernel source packages
    yum -y remove gcc cpp kernel-devel kernel-headers perl;

    # if [ "$distro" != 'redhat' ]; then
    yum -y clean all;
    # fi

    # Clean up network interface persistence
    rm -rf /etc/udev/rules.d/70-persistent-net.rules;
    mkdir -p /etc/udev/rules.d/70-persistent-net.rules;
    rm -rf /lib/udev/rules.d/75-persistent-net-generator.rules;
    rm -rf /dev/.udev/;

    # Clean up SSH host key.
    rm -f /etc/ssh/ssh_host_*

    for ndev in `ls -1 /etc/sysconfig/network-scripts/ifcfg-*`; do
        if [ "`basename $ndev`" != "ifcfg-lo" ]; then
            sed -i '/^HWADDR/d' "$ndev";
            sed -i '/^UUID/d' "$ndev";
        fi
    done

    rm -f VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?;
    ;;
esac
