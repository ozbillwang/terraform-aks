#! /usr/bin/env bash

env=staging
terraform get -update=true
terraform init -reconfigure -backend-config=config/backend-${env}.conf
terraform fmt
terraform validate
terraform plan -var-file=config/terraform-${env}.tfvars

# if plan looks good, run below command to apply the change.
# terraform apply -var-file=config/terraform-${env}.tfvars

# if you want to redo some resources, use the trick below.
# terraform apply -replace="azurerm_linux_virtual_machine_scale_set.this"
