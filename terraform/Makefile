MAKEFILE_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: format
format:  ## Format Terraform files
	@terraform fmt -recursive $(MAKEFILE_DIR)/{modules,workspaces}

.PHONY: install
install:  ## Install Terraform and Terragrunt
	tfenv install
	tgenv install

.PHONY: prerequisities
prerequisities:  ## Install Prerequisities
	brew install direnv sops tfenv tgenv

.PHONY: clean
clean:  ## Clean up
	rm -rf $(MAKEFILE_DIR)/.cache/
