####################
# Provider section #
####################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.98.0"
    }
  }
}

provider "azurerm" {
  features {}
}

########################
# Data sources section #
########################

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
data "azurerm_client_config" "current" {}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
data "azurerm_resource_group" "node_rg" {
  name = azurerm_kubernetes_cluster.aks.node_resource_group

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

data "azurerm_resource_group" "AKS" {
  name = azurerm_kubernetes_cluster.aks.resource_group_name
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]

}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity
data "azurerm_user_assigned_identity" "identity-appgw" {
  name                = "ingressapplicationgateway-${var.name}"
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group

  depends_on = [azurerm_kubernetes_cluster.aks]
}

#####################
# Resources section #
#####################

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity
resource "azurerm_user_assigned_identity" "dflbuscontrolplane" {
  name                = var.Managedidentity_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster
resource "azurerm_kubernetes_cluster" "aks" {
  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      oms_agent[0].log_analytics_workspace_id ,
      oms_agent[0].msi_auth_for_monitoring_enabled ,
      oms_agent[0].oms_agent_identity 

    ]
  }

  name                    = var.name
  location                = var.location
  resource_group_name     = var.resource_group_name
  tags                    = var.tags
  dns_prefix              = var.name
  kubernetes_version      = var.kubernetes_version
  node_resource_group     = "MC_${var.resource_group_name}_${var.name}"
  private_cluster_enabled = var.private_cluster
  sku_tier                = var.sla_sku

  default_node_pool {
    name                = var.default_node_pool.name
    node_count          = var.default_node_pool.node_count
    vm_size             = var.default_node_pool.vm_size
    zones               = var.default_node_pool.zones
    type                = "VirtualMachineScaleSets"
    max_pods            = var.default_node_pool.max_pods
    os_disk_size_gb     = 128
    vnet_subnet_id      = var.subnet_id
    node_labels         = var.default_node_pool.labels
    enable_auto_scaling = var.default_node_pool.cluster_auto_scaling
    min_count           = var.default_node_pool.cluster_auto_scaling_min_count
    max_count           = var.default_node_pool.cluster_auto_scaling_max_count
    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.dflbuscontrolplane.id]
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = var.azure_ad_rbac_enabled
    managed                = true
    admin_group_object_ids = [data.azurerm_client_config.current.object_id]
  }


  azure_policy_enabled = var.addons.azure_policy

  dynamic "ingress_application_gateway" {
    for_each = var.agw_id != null ? ["a"] : []

    content {
      gateway_id = var.agw_id
    }
  }

  network_profile {
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
    network_plugin    = "azure"
    dns_service_ip    = "10.0.0.10"
    service_cidr      = "10.0.0.0/16"
  }

  depends_on = [var.aks_depends_on]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool
resource "azurerm_kubernetes_cluster_node_pool" "aks" {
  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

  for_each = var.additional_node_pools

  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  name                  = each.value.name
  mode                  = "System"
  node_count            = each.value.node_count
  vm_size               = each.value.vm_size
  zones                 = each.value.zones
  max_pods              = each.value.max_pods
  os_disk_size_gb       = 128
  vnet_subnet_id        = var.subnet_id
  node_labels           = each.value.labels
  enable_auto_scaling   = each.value.cluster_auto_scaling
  min_count             = each.value.cluster_auto_scaling_min_count
  max_count             = each.value.cluster_auto_scaling_max_count
}

####################
# Role assignments #
####################

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "agw_contributor" {
  scope                = var.agw_id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_user_assigned_identity.identity-appgw.principal_id
}

resource "azurerm_role_assignment" "aks_subnet" {
  scope                = var.subnet_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.dflbuscontrolplane.principal_id
}

resource "azurerm_role_assignment" "dflbuscontrolplane_contributor" {
  scope                = data.azurerm_resource_group.AKS.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.dflbuscontrolplane.principal_id
}
