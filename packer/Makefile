MAKEFILE_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))

.DEFAULT_GOAL := help
.PHONY: help
help:  ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

out:
	mkdir -p $(MAKEFILE_DIR)/out/

out/ssh/id_rsa: out  ## Create a ssh key
	mkdir -p $(MAKEFILE_DIR)/out/ssh/
	ssh-keygen -t rsa -b 4096 -f $(MAKEFILE_DIR)/out/ssh/id_rsa -N ""

our/cloud-init: out out/ssh/id_rsa  ## Create a cloud-init directory
	mkdir -p $(MAKEFILE_DIR)/out/cloud-init/
	cp $(MAKEFILE_DIR)/src/files/cloud-init/* $(MAKEFILE_DIR)/out/cloud-init/
	SSH_PUBLIC_KEY="$(shell cat $(MAKEFILE_DIR)/out/ssh/id_rsa.pub)" envsubst < $(MAKEFILE_DIR)/src/files/cloud-init/user-data > $(MAKEFILE_DIR)/out/cloud-init/user-data

out/cidata.iso: our/cloud-init  ## Create a cloud-init iso
	mkisofs -output $(MAKEFILE_DIR)/out/cidata.iso -volid cidata -joliet -rock $(MAKEFILE_DIR)/out/cloud-init/

out/default.pkrvars.hcl: out/ssh/id_rsa  ## Create a packer variables file
	rm -f $(MAKEFILE_DIR)/out/default.pkrvars.hcl
	echo "image_output = \"${MAKEFILE_DIR}/out/image/\"" >> $(MAKEFILE_DIR)/out/default.pkrvars.hcl
	echo "vm_cloudinit = \"${MAKEFILE_DIR}/out/cidata.iso\"" >> $(MAKEFILE_DIR)/out/default.pkrvars.hcl
	echo "ssh_private_key = \"$(MAKEFILE_DIR)/out/ssh/id_rsa\"" >> $(MAKEFILE_DIR)/out/default.pkrvars.hcl

.PHONY: clean
clean:  ## Clean the build
	rm -rf $(MAKEFILE_DIR)/out/

.PHONY: build
build: out/cidata.iso out/default.pkrvars.hcl  ## Build the image
	PACKER_LOG=1 packer build \
		-var-file=$(MAKEFILE_DIR)/vars/debian-12.pkrvars.hcl \
		-var-file=$(MAKEFILE_DIR)/out/default.pkrvars.hcl \
		$(MAKEFILE_DIR)/src/
