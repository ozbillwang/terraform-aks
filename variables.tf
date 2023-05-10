variable "project" {
  default     = "aks-project"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "env" {
  default     = "staging"
  description = "environment name, such as develop, staging, production"
}

variable "location" {
  default = "Australia East"
}

variable "agent_count" {
  default = 2
}

variable "container_registry_name" {}

variable "container_registry_rg_name" {}

data "azurerm_subscription" "this" {}

data "azurerm_container_registry" "this" {
  name                = var.container_registry_name
  resource_group_name = var.container_registry_rg_name
}

locals {
  dns_prefix                       = "${var.project}-${var.env}"
  cluster_name                     = "${var.project}-${var.env}-aks"
  resource_group_name              = "${var.project}-${var.env}-aks"
  resource_group_location          = var.location
  log_analytics_workspace_name     = "${var.project}-${var.env}-aks-${substr(data.azurerm_subscription.this.subscription_id, 0, 7)}"
  log_analytics_workspace_location = var.location
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing
variable "log_analytics_workspace_sku" {
  default = "PerGB2018"
}
