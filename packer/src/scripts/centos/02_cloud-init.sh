#!/bin/sh -eux


echo "Running $0"
case "$PACKER_BUILDER_TYPE" in
qemu|vmware-iso)
    # cloud-init needs to be installed _after_ the kickstart process.  This is because
    # we are running kickstart on a non-openstack instance, so it can't find the
    # relevant network metadata.

    # Specify the version for centos 7 because latest version is buggy.
    os_major=`facter -p operatingsystemmajrelease`
    case "$os_major" in
      7)
        yum  -y install cloud-init-0.7.5-6.el7.x86_64 cloud-utils-0.27-10.el7.x86_64 cloud-utils-growpart-0.27-10.el7.x86_64
      ;;
      *)
        yum -y install cloud-init cloud-utils cloud-utils-growpart
      ;;
    esac

    # The configuration files are added via the packer file provisioner
    # check the packer template for more information

    # Order matters, local before init
    echo "# chkconfig: 2345 09 50" > /etc/chkconfig.d/cloud-init-local
    echo "# chkconfig: 2345 11 50" > /etc/chkconfig.d/cloud-init
    /sbin/chkconfig --override cloud-init-local
    /sbin/chkconfig --override cloud-init
    ;;

*)
    exit 0
    ;;
esac
