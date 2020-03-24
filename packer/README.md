# Packer generated Images for YNAP

Fork for including ECOps Infrastructure BLQ. Documentation at `https://confluence.nap/display/EOB/Template+creation+pipeline`.

===
This repository is used for building the custom NAP images, using Hashicorp's packer tool and various virtual services.

_NOTE: `build.sh` is used to expose the git branch name and commit id's to the packer template.  You will need to use it instead of the `packer` command or the variables will not be populated correctly.
This repo come from this one [packer-builder](https://stash.nap/projects/OSTK/repos/packer-builder/browse)._

---

## VMware

To use this for Vmware image creation you will need to provide several environment variables.

It's required :

- an access to a running nested ESXi.
- an access to a Vcenter.
- an access to an ESXi where the desired datastore is mounted.

For now you need to store your credentials in credentials.txt, soon this will be handle with secret store in Jenkins.

---

## Variables present in the project

- `VCENTER_USER` : User used by packer to connect to vcenter. Default value is `svc_packer@london.net-a-porter.com` and it stored in `credentialsID (to be substituted)` in Jenkins Vault.
- `VCENTER_PWD` : Password for `VCENTER_USER`. Default value stored in `credentialsID (to be substituted)` Jenkins Vault.
- `VCENTER_NIC_VLAN` : Port group to confifure on the VM during the image creation process. Stored in `vars.groovy` file. Depending of site.
- `VCENTER_VM_HW_VERSION` : Vmware hardware version of the images. Default value is `11`. Stored in `vars.groovy` file.
- `VAR_FILE` : Var file to use for packer execution. It changes according to the chosen distribution.
- `HTTP_PORT` : Port where the packer web server will be listening. Default value is `8001`. Stored in `vars.groovy` file.
- `HTTP_IP` : Equals to `JENKINS_IP`.
- `COMMIT_ID` : Last commit id. Used to create the VM on esxi host. Setted in `Makefile`.
- `BRANCH_NAME` : Branch name used to compose VM hostname. Setted in `Makefile`.
- `DC_SITE` : Datacenter site where VM will be created. Fixed in`vars.groovy` file.
- `PACKER_ON_ERROR` : Control packer behaviour in case of error during the build. Default value is `cleanup`. Stored in `vars.groovy` file.
- `PACKER_PARALLEL` : Control parallel build execution. We disable it since it's running inside a container and we want to specify which port is exposed. If we want to run parallel builds run several differents container. Default value is `false`. Stored in `vars.groovy` file.
- `IMAGE_ROOT_PWD` : Root password setup during kickstart installation. Default value stored in `vault_jenkins_cred_inf_image` in Jenkins Vault.
- `ESXI_DATASTORE`: Default esxi datastore where VM will be created. Stored in `vars.groovy` file.
- `ESXI_HOST` : Default esxi address where VM will be created. Stored in `vars.groovy` file.
- `ESXI_USER` : Default User used to connect into esxi host. Default value in Jenkins Vault. Stored in `vars.groovy` file.
- `ESXI_PWD` : Password of `ESXI_USER` used to connect to nested ESXi. Default value `` in Jenkins Vault.
- `CLIENT_IP` : Template VM IP.
- `GATEWAY_IP` : Template VM Gateway.
- `DNS1`: Template VM DNS.
- `DNS2` : Template VM DNS.
- `NETMASK` : Template VM Netmask.

---

## Local execution

If you want to run this locally, you will need to setup the following environment variables :

- `VCENTER_PWD`
- `IMAGE_ROOT_PWD`
- `ESXI_PWD`
- `COMMIT_ID` (value don't matter)
- `BRANCH_NAME`
- `JENKINS_IP` (value don't matter)
- `HTTP_PORT` (value don't matter)
- `PACKER_PARALLEL`

## Troubleshooting

1. Make sure you are limiting which builder you use with the `-only=` parameter
2. For additional verbosity, add `PACKER_LOG=1` to the command, e.g.

        PACKER_LOG=1 packer build -only=qemu -var-file=centos67.json centos.json

    Note this is done automatically by the build.sh script

## Nested ESXi

Builds have moved from GS2 to Imola. See the kickstart file in the repo which was used to build the ISO to install this server.

Refer to `https://git.yoox.net/projects/INF/repos/vmware-simple-kickstart/browse` on how to easily build the ISO.
