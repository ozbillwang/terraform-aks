resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = local.resource_group_location
}


resource "azurerm_log_analytics_workspace" "this" {
  # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
  name                = local.log_analytics_workspace_name
  location            = local.log_analytics_workspace_location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "this" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.this.location
  resource_group_name   = azurerm_resource_group.this.name
  workspace_resource_id = azurerm_log_analytics_workspace.this.id
  workspace_name        = azurerm_log_analytics_workspace.this.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name                      = local.cluster_name
  location                  = azurerm_resource_group.this.location
  resource_group_name       = azurerm_resource_group.this.name
  dns_prefix                = local.dns_prefix
  automatic_channel_upgrade = "patch"

  #  linux_profile {
  #    admin_username = "ubuntu"
  #
  #
  #    ssh_key {
  #      key_data = file(var.ssh_public_key)
  #    }
  #  }

  default_node_pool {
    name       = "agentpool"
    node_count = var.agent_count
    vm_size    = "Standard_D2_v2"
  }
  identity {
    type = "SystemAssigned"
  }

  #  service_principal {
  #    client_id     = var.aks_service_principal_app_id
  #    client_secret = var.aks_service_principal_client_secret
  #  }
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  http_application_routing_enabled = true

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "kubenet"
  }

  tags = {
    Environment = var.env
  }
}

# add the role to the identity the kubernetes cluster was assigned
resource "azurerm_role_assignment" "this" {
  scope                = data.azurerm_container_registry.this.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}

