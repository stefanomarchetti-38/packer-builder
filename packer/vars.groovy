// Generic variables
//
env.BUILD_VERSION = 1.0
env.SKIP_DEPLOY = 0
env.HTTP_PORT = 8001
env.PACKER_ON_ERROR = 'cleanup'
env.PACKER_PARALLEL = 'false'
env.VCENTER_VM_HW_VERSION = '11'
env.BUILD_TYPE= 'vmware-iso'
//
// Determining jenkins host's ip.
env.JENKINS_NET_INTERFACE = sh(script:"/sbin/ifconfig | grep ^eno | head -n 1| cut -d: -f 1", returnStdout: true)
env.JENKINS_IP = sh(script:"/sbin/ifconfig \$JENKINS_NET_INTERFACE | grep inet | grep -v inet6  | awk '{print \$2}' | tr -d '\\n'| head -1", returnStdout: true)
//
// env.ESXI_HOST = '192.168.25.17' // Nested ESXI in LDN. Used instead of VCENTER_HOST
env.DC_SITE = 'imo' // fixed because in future we will have only an esxi host on imola
env.ESXI_DATASTORE = 'build_datastore'
env.ESXI_HOST = '172.22.35.120' // Nested ESXI in IMO.
//
switch(DC_SITE) {
  case 'gs2':
      env.CLIENT_IP = '192.168.25.200'
      env.GATEWAY_IP = '192.168.25.1'
      env.DNS1 = '192.168.25.137'
      env.DNS2 = '192.168.45.131'
      env.VCENTER_NIC_VLAN = 'dvPortGroup-T1.5-Managament'
      env.NETMASK = '255.255.255.0'
      env.VCENTER_FOLDER = '/Template/Linux/CentOS'
      break
  case 'sav':
      env.CLIENT_IP = '192.168.89.200'
      env.GATEWAY_IP = '192.168.89.1'
      env.DNS1 = '192.168.89.136'
      env.DNS2 = '192.168.45.131'
      env.VCENTER_NIC_VLAN = 'dvPortGroup-T1.5-Managament'
      env.NETMASK = '255.255.255.0'
      env.VCENTER_FOLDER = '/Template/Linux/CentOS'
      break
  case 'imo':
      env.CLIENT_IP = '172.22.77.49'
      env.GATEWAY_IP = '172.22.77.1'
      env.DNS1 = '172.22.32.11'
      env.DNS2 = '172.22.32.12'
      env.VCENTER_NIC_VLAN = 'VLAN77'
      env.NETMASK = '255.255.255.0'
      env.VCENTER_FOLDER = '/Template/vRealize Automation 7'
      break
  default:
      echo ("DC site $DC_SITE not supported.")
      break
}
