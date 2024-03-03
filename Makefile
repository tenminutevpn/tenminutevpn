MAKEFILE_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))

.DEFAULT_GOAL := help
.PHONY: help
help:  ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.cache:
	@mkdir -p $(MAKEFILE_DIR)/.cache/packer/
	@mkdir -p $(MAKEFILE_DIR)/.cache/qemu/

.cache/packer/ssh/id_rsa: .cache
	@mkdir -p $(MAKEFILE_DIR)/.cache/packer/ssh/
	@ssh-keygen -t rsa -b 4096 -f $(MAKEFILE_DIR)/.cache/packer/ssh/id_rsa -N "" -q

.cache/packer/cloud-init: .cache .cache/packer/ssh/id_rsa
	@mkdir -p $(MAKEFILE_DIR)/.cache/packer/cloud-init/
	@cp $(MAKEFILE_DIR)/packer/files/cloud-init/* $(MAKEFILE_DIR)/.cache/packer/cloud-init/
	@SSH_PUBLIC_KEY="$(shell cat $(MAKEFILE_DIR)/.cache/packer/ssh/id_rsa.pub)" envsubst < $(MAKEFILE_DIR)/packer/files/cloud-init/user-data > $(MAKEFILE_DIR)/.cache/packer/cloud-init/user-data

.cache/packer/cidata.iso: .cache/packer/cloud-init
	@mkisofs -output $(MAKEFILE_DIR)/.cache/packer/cidata.iso -volid cidata -joliet -rock $(MAKEFILE_DIR)/.cache/packer/cloud-init/ > /dev/null 2>&1

.cache/packer/variables.pkrvars.hcl: .cache/packer/ssh/id_rsa
	@rm -f $(MAKEFILE_DIR)/.cache/packer/variables.pkrvars.hcl
	@echo "image_output = \"${MAKEFILE_DIR}/.cache/packer/image/\"" >> $(MAKEFILE_DIR)/.cache/packer/variables.pkrvars.hcl
	@echo "image_cache = \"${MAKEFILE_DIR}/.cache/qemu/\"" >> $(MAKEFILE_DIR)/.cache/packer/variables.pkrvars.hcl
	@echo "vm_cloudinit = \"${MAKEFILE_DIR}/.cache/packer/cidata.iso\"" >> $(MAKEFILE_DIR)/.cache/packer/variables.pkrvars.hcl
	@echo "ssh_private_key = \"$(MAKEFILE_DIR)/.cache/packer/ssh/id_rsa\"" >> $(MAKEFILE_DIR)/.cache/packer/variables.pkrvars.hcl

.PHONY: clean
clean:  ## Clean the build
	@rm -rf $(MAKEFILE_DIR)/.cache/packer/

.PHONY: format
format:  ## Format the code
	@packer fmt -recursive $(MAKEFILE_DIR)/packer/

.PHONY: lint
lint:  ## Lint the code
	@ansible-lint --offline $(MAKEFILE_DIR)/ansible/
	@packer validate -syntax-only $(MAKEFILE_DIR)/packer/

.PHONY: install
install:  ## Install the dependencies
	packer init $(MAKEFILE_DIR)/packer/

.PHONY: build
build: clean lint install .cache/packer/cidata.iso .cache/packer/variables.pkrvars.hcl  ## Build the image
	packer validate \
        -var-file=$(MAKEFILE_DIR)/.cache/packer/variables.pkrvars.hcl \
        $(MAKEFILE_DIR)/packer/
	packer build \
		-var-file=$(MAKEFILE_DIR)/.cache/packer/variables.pkrvars.hcl \
		$(MAKEFILE_DIR)/packer/
	@sed -i 's/\t/  /g' $(MAKEFILE_DIR)/.cache/packer/image/SHA512SUMS

.PHONY: test
test:  ## Test the image
	cd $(MAKEFILE_DIR)/ansible/roles/tenminutevpn/ && molecule test
