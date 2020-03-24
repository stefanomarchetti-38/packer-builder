#!/bin/bash
set -e
source openstack-postpro

# Find which version of Centos we are building
case $VAR_FILE in
  centos6.json)
    export IP_STRING="ip=${CLIENT_IP} gateway=${GATEWAY_IP} netmask=${NETMASK} ksdevice=eth0 dns=${DNS1}"
    export OS_VERSION="6"
    ruby yaml2json-template.rb centos-postpro.yaml centos6-postpro.json
    ;;
  centos7.json)
    export IP_STRING="ip=${CLIENT_IP}::${GATEWAY_IP}:${NETMASK}:packer-builder:eth0:none nameserver=${DNS1}"
    export OS_VERSION="7"
    ruby yaml2json-template.rb centos-postpro.yaml centos7-postpro.json
    ;;
  openstack6.json)
    export IP_STRING="ip=${CLIENT_IP} gateway=${GATEWAY_IP} netmask=${NETMASK} ksdevice=eth0 dns=${DNS1}"
    export OS_VERSION="6"
    ;;
  openstack7.json)
    export IP_STRING="ip=${CLIENT_IP}::${GATEWAY_IP}:${NETMASK}:packer-builder:eth0:none nameserver=${DNS1}"
    export OS_VERSION="7"
    ;;
  rhel7.json)
    export IP_STRING="ip=${CLIENT_IP}::${GATEWAY_IP}:${NETMASK}:packer-builder:ens192:none nameserver=${DNS1}"
    export OS_VERSION="7"
    if [ ${BRANCH_NAME} != "master" ]; then
      export VM_NAME_SUFFIX="-${BRANCH_NAME}"
    fi
    # Resize primary disk
    jq '(.builders[0] |.disk_size) |= 10240' build.json > build_temp.json && mv build_temp.json build.json
    # Add additinal disk
    jq '.builders[0] += { "disk_additional_size": 10240 }' build.json > build_temp.json && mv build_temp.json build.json
    #
    ruby yaml2json-template.rb rhel7-postpro.yaml rhel7-postpro.json
    ;;
  *)
    echo "version not supported"
    exit 1
  ;;
esac

if [[ ${VAR_FILE} != *"openstack"* ]];then
  jq -s '.[0] + .[1]' build.json $(basename ${VAR_FILE} .json)-postpro.json > mypacker.json
  PACKER_LOG=1 packer build -debug -on-error=${PACKER_ON_ERROR} -only=${BUILD_TYPE} -var-file=${VAR_FILE} -parallel=${PACKER_PARALLEL} mypacker.json
else
  PACKER_LOG=1 packer build -debug -on-error=${PACKER_ON_ERROR} -only=${BUILD_TYPE} -var-file=${VAR_FILE} -parallel=${PACKER_PARALLEL} build.json
    for endpoint in "${vioendpoint[@]}"
    do
      export openstack_auth="--os-auth-url "https://$endpoint:5000/v3" --os-username "packer_builder" --os-password $VIO_PWD --insecure --os-project-name "admin" --os-project-domain-name "local" --os-user-domain-name "local""
      export template_name="centos${OS_VERSION}-${BRANCH_NAME}-latest"
      export create_options="--public --disk-format vmdk --file build-image/centos-${OS_VERSION}-vmware-iso/centos-${OS_VERSION}-${BRANCH_NAME}-${COMMIT_ID}/centos-${OS_VERSION}-${BRANCH_NAME}-${COMMIT_ID}-disk1.vmdk --property vmware_adaptertype="paraVirtual" --property hw_vif_model="VirtualVmxnet3""
      echo "Pushing CentOS ${OS_VERSION} image to VIO"
      openstack image create pipeline-image-${BUILD_NUMBER} $openstack_auth $create_options
      if [[ $(openstack image list $openstack_auth | grep "$template_name") ]]; then
        echo "Deleting existing image centos${OS_VERSION}-${BRANCH_NAME}-latest"
        openstack image delete $template_name $openstack_auth
      else
        echo "No image to delete"
      fi
      echo "Renaming new image to centos${OS_VERSION}-${BRANCH_NAME}-latest"
      openstack image set --name $template_name $openstack_auth pipeline-image-${BUILD_NUMBER}
    done
    rm -rf "/src/build-image/centos-${OS_VERSION}-vmware-iso"
fi
