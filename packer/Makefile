.PHONY: all
all: build_image
pushall: push_centos7 push_centos6 push_rhel7 push_openstack6 push_openstack7

# When run locally DOCKER_TAG won't be set so we should create it
# When run in Jenkins the Jenkinsfile defines this appropriately
setup:
GIT_COMMIT_ID = $(shell git rev-parse --short HEAD)
ifndef DOCKER_TAG
DOCKER_TAG = "localtest-packer-builder-$(GIT_COMMIT_ID)"
endif

ifndef BRANCH_NAME
BRANCH_NAME = "$(shell git branch | sed -n -e 's/^\* \(.*\)/\1/p')"
endif

build_image: setup
	docker build -t $(DOCKER_TAG) .

run_image: setup	
	docker run --rm -e VCENTER_USER=$(VCENTER_USER) \
	-e VCENTER_PWD=$(VCENTER_PWD) \
	-e VCENTER_FOLDER="$(VCENTER_FOLDER)" \
	-e IMAGE_ROOT_PWD=$(IMAGE_ROOT_PWD) \
	-e ESXI_PWD=$(ESXI_PWD) \
	-e VIO_PWD=$(VIO_PWD) \
	-e HTTP_PORT=$(HTTP_PORT) \
	-e HTTP_IP=$(JENKINS_IP) \
	-e COMMIT_ID=$(GIT_COMMIT_ID) \
	-e BRANCH_NAME=$(BRANCH_NAME) \
	-e VAR_FILE=$(VAR_FILE) \
	-e PACKER_ON_ERROR=$(PACKER_ON_ERROR) \
	-e PACKER_PARALLEL=$(PACKER_PARALLEL) \
	-e DC_SITE=$(DC_SITE) \
	-e ESXI_DATASTORE=$(ESXI_DATASTORE) \
	-e ESXI_HOST=$(ESXI_HOST) \
	-e ESXI_USER=$(ESXI_USER) \
	-e NETMASK=$(NETMASK) \
	-e CLIENT_IP=$(CLIENT_IP) \
	-e GATEWAY_IP=$(GATEWAY_IP) \
	-e DNS1=$(DNS1) \
	-e DNS2=$(DNS2) \
	-e VCENTER_NIC_VLAN=$(VCENTER_NIC_VLAN) \
	-e VCENTER_VM_HW_VERSION=$(VCENTER_VM_HW_VERSION) \
	-e BUILD_TYPE=$(BUILD_TYPE) \
	-e BUILD_NUMBER=$(BUILD_NUMBER) \
	-e BUILD_VERSION=$(BUILD_VERSION) \
	-p $(HTTP_PORT) \
	-c 4 $(DOCKER_TAG)
