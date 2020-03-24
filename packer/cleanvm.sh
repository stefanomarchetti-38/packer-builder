#!/bin/bash

unset vm
export vm=$(docker run --rm -e GOVC_USERNAME=${ESXI_USER} -e GOVC_INSECURE=true -e GOVC_PASSWORD=${ESXI_PWD} vmware/govc ls -u ${ESXI_HOST} /ha-datacenter/vm | sed -n 2p)
vm=${vm##*/}
echo "vm = "$vm

if [ -z "$vm" ]; then
    echo "no vm running"
else
    docker run --rm -e  GOVC_URL=${ESXI_HOST} -e GOVC_USERNAME=${ESXI_USER} -e GOVC_INSECURE=true -e GOVC_PASSWORD=${ESXI_PWD} vmware/govc vm.destroy $vm
    echo "Destroyed vm "$vm 
fi