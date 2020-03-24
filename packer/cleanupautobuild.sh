#!/bin/bash

export GOVC_USERNAME=$VCENTER_USER
export GOVC_INSECURE=1
export GOVC_PASSWORD=$VCENTER_PWD
unset arr

declare -a arr=("vcenter01.sav.nap" "vcenter02.sav.nap" "vcenter01.gs2.nap" "vcsa01.gs2.nap" "vcenter02.gs2.nap" "vcsa01.wtf.nap" "vcsa01.dc1.nap" "vcsa01.dc2.nap" "vcsa01.dc3.nap" "vcsa01.dev.sav.nap" "yvc08blq.yoox.net" "yvc07blq.yoox.net" "drbinfvca001btm.yoox.net")
for targets in "${arr[@]}"
do
    unset vm
    export vm=$(docker run --rm -e GOVC_USERNAME=${GOVC_USERNAME} -e GOVC_INSECURE=true -e GOVC_PASSWORD=${GOVC_PASSWORD} -e GOVC_URL=$targets vmware/govc find vm -name "*-autobuild*" | awk -F/ '{print $NF}')
    if [ -z "$vm" ]; then
        echo "no vm to delete on $targets"
    else
        docker run --rm -e GOVC_USERNAME=${GOVC_USERNAME} -e GOVC_INSECURE=true -e GOVC_PASSWORD=${GOVC_PASSWORD} vmware/govc vm.destroy -u https://$targets $vm
        echo "deleted $vm from $targets"
    fi
done