MAKEFILE_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))

.DEFAULT_GOAL := help
.PHONY: help
help:  ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

boot/cidata.iso:  ## Create a cloud-init iso
	mkisofs -output $(MAKEFILE_DIR)/boot/cidata.iso -volid cidata -joliet -rock $(MAKEFILE_DIR)/boot/cloud-init

boot/ssh: ## Create a ssh key
	mkdir -p boot/ssh
	ssh-keygen -t rsa -b 4096 -f boot/ssh/id_rsa -N ""

.PHONY: clean
clean:  ## Clean the cloud-init iso
	rm -rf boot/cidata.iso boot/ssh

.PHONY: build
build: boot/cidata.iso  ## Build the cloud-init iso
	PACKER_LOG=1 packer build .
