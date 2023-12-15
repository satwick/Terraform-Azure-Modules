####################
# Locals           #
####################

locals {
  private_dns_zones = {
    azurecr-io             = "privatelink.azurecr.io"
    blob-core-windows-net  = "privatelink.blob.core.windows.net"
    queue-core-windows-net = "privatelink.queue.core.windows.net"
    table-core-windows-net = "privatelink.table.core.windows.net"
    vaultcore-azure-net    = "privatelink.vaultcore.azure.net"
    sql-server-net         = "privatelink.database.windows.net"
    postgres-server-net    = "private.postgres.database.azure.com"
  }
}

####################
# Provider section #
####################

terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.73.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
  }
}

#####################
# Resources section #
#####################

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
resource "azurerm_resource_group" "devspoke" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone
resource "azurerm_private_dns_zone" "private_dns_zones" {
  for_each            = local.private_dns_zones
  name                = each.value
  resource_group_name = azurerm_resource_group.devspoke.name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_network_links" {
  for_each              = local.private_dns_zones
  name                  = "${var.devspoke_vnet_name}-link"
  resource_group_name   = azurerm_resource_group.devspoke.name
  private_dns_zone_name = each.value
  virtual_network_id    = module.devspoke_vnet.vnet_id
  depends_on            = [azurerm_private_dns_zone.private_dns_zones] # Depends on is needed, because otherwise updated DNS Zones aren't linked
}

module "devspoke_vnet" {
  source = "../../modules/vnet"

  name                = var.devspoke_vnet_name
  location            = azurerm_resource_group.devspoke.location
  resource_group_name = azurerm_resource_group.devspoke.name
  tags                = var.tags
  address_space       = var.devspoke_vnet_address_space

  subnets = {
    support-snet = {
      address_prefix    = [var.support_snet_address_prefix]
      delegation        = []
      service_endpoints = []
    },
    devspoke-snet = {
      address_prefix    = [var.devspoke_snet_address_prefix]
      delegation        = []
      service_endpoints = []
    },
    dflbusgateway-subnet = {
      address_prefix    = [var.gateway_snet_address_prefix]
      delegation        = []
      service_endpoints = []
    },
    aks-snet = {
      address_prefix    = [var.aks_snet_address_prefix]
      delegation        = []
      service_endpoints = []
    },
    database-snet = {
      address_prefix = [var.database_snet_address_prefix]
      delegation = [
        {
          name    = "Microsoft.DBforPostgreSQL/flexibleServers"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", ]
        }
      ]
      service_endpoints = ["Microsoft.Storage"]
    }
  }
}

module "devspoke_route_table" {
  source = "../../modules/routetable"

  name                = var.route_table_name
  location            = azurerm_resource_group.devspoke.location
  resource_group_name = azurerm_resource_group.devspoke.name
  tags                = var.tags
  route_table_routes  = var.devspoke_route_table_routes
}

resource "azurerm_subnet_route_table_association" "devspoke_database" {
  subnet_id      = module.devspoke_vnet.subnet_ids["database-snet"]
  route_table_id = module.devspoke_route_table.route_table_id
}

resource "azurerm_subnet_route_table_association" "devspoke_support" {
  subnet_id      = module.devspoke_vnet.subnet_ids["support-snet"]
  route_table_id = module.devspoke_route_table.route_table_id
}

resource "azurerm_subnet_route_table_association" "devspoke_devspoke" {
  subnet_id      = module.devspoke_vnet.subnet_ids["devspoke-snet"]
  route_table_id = module.devspoke_route_table.route_table_id
}

module "devspoke_storage" {
  source = "../../modules/storageaccount"

  name                     = var.devspoke_storage_name
  location                 = azurerm_resource_group.devspoke.location
  resource_group_name      = azurerm_resource_group.devspoke.name
  tags                     = var.tags
  account_tier             = var.devspoke_storage_account_tier
  account_replication_type = var.devspoke_storage_account_replication_type
  containers               = var.devspoke_storage_containers
  private_endpoint_name    = var.devspoke_storage_private_endpoint_name
  private_dns_zone_ids = [
    azurerm_private_dns_zone.private_dns_zones["blob-core-windows-net"].id,
    azurerm_private_dns_zone.private_dns_zones["queue-core-windows-net"].id,
    azurerm_private_dns_zone.private_dns_zones["table-core-windows-net"].id
  ]
  subnet_id             = module.devspoke_vnet.subnet_ids["support-snet"]
  public_network_access = true
}

module "support_vm_linux" {
  source = "../../modules/vm_linux"

  name                                  = var.vm_linux_name
  location                              = azurerm_resource_group.devspoke.location
  resource_group_name                   = azurerm_resource_group.devspoke.name
  tags                                  = var.tags
  storage_account_primary_blob_endpoint = module.devspoke_storage.primary_blob_endpoint

  subnet_id = module.devspoke_vnet.subnet_ids["support-snet"]

  username         = var.vm_linux_username
  password         = var.vm_linux_password
  custom_data_path = var.custom_data_path
}

module "support_vm_windows" {
  source = "../../modules/vm_windows"

  name                = var.vm_windows_name
  location            = azurerm_resource_group.devspoke.location
  resource_group_name = azurerm_resource_group.devspoke.name
  tags                = var.tags

  subnet_id = module.devspoke_vnet.subnet_ids["support-snet"]

  username = var.vm_windows_username
  password = var.vm_windows_password
}

module "devspoke_keyvault" {
  source = "../../modules/keyvault"

  name                       = var.devspoke_keyvault_name
  location                   = azurerm_resource_group.devspoke.location
  resource_group_name        = azurerm_resource_group.devspoke.name
  sku_name                   = var.devspoke_keyvault_sku_name
  soft_delete_retention_days = var.devspoke_keyvault_soft_delete_retention_days
  private_endpoint_name      = var.devspoke_keyvault_private_endpoint_name
  private_dns_zone_ids = [
    azurerm_private_dns_zone.private_dns_zones["vaultcore-azure-net"].id
  ]
  subnet_id             = module.devspoke_vnet.subnet_ids["support-snet"]
  public_network_access = var.devspoke_keyvault_public_network_access
}

module "devspoke_sql_server" {
  source = "../../modules/sql_server"

  sql_server_name              = var.sql_server_name
  resource_group_name          = azurerm_resource_group.devspoke.name
  location                     = azurerm_resource_group.devspoke.location
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  sql_db = {
    sql_db_germany = {
      edition     = var.edition
      collation   = var.collation
      max_size_gb = var.max_size_gb
    }
    sql_db_turkey = {
      edition     = var.edition
      collation   = var.collation
      max_size_gb = var.max_size_gb
    }
  }
  private_endpoint_name = var.devspoke_sql_private_endpoint_name
  private_dns_zone_ids = [
    azurerm_private_dns_zone.private_dns_zones["sql-server-net"].id
  ]
  subnet_id = module.devspoke_vnet.subnet_ids["support-snet"]
}

module "devspoke_postgresflex" {

  source              = "../../modules/postgresflex"
  name                = var.psql_name
  location            = azurerm_resource_group.devspoke.location
  resource_group_name = azurerm_resource_group.devspoke.name
  tags                = var.tags
  username            = var.psql_username
  password            = var.psql_password
  sku_name            = var.psql_sku_name
  db_version          = var.psql_version
  storage_mb          = var.psql_storage_mb
  private_dns_zone_id = azurerm_private_dns_zone.private_dns_zones["postgres-server-net"].id
  subnet_id           = module.devspoke_vnet.subnet_ids["database-snet"]
}

module "devspoke_appgw" {
  source = "../../modules/agw"
  
  name                          = var.application_gateway_name
  resource_group                = azurerm_resource_group.devspoke.name
  location                      = azurerm_resource_group.devspoke.location
  subnet_id                     = module.devspoke_vnet.subnet_ids["dflbusgateway-subnet"]
  environment                   = var.environment
  appgw_private_ip              = var.appgw_private_ip_address 
}

module "devspoke_aks"{
  source = "../../modules/aks"

  name                          = var.aks_name
  resource_group_name           = azurerm_resource_group.devspoke.name
  tags                          = var.tags
  additional_node_pools         = var.aks_additional_node_pools 
  private_cluster               = var.aks_private_cluster 
  kubernetes_version            = var.aks_kubernetes_version
  subnet_id                     = module.devspoke_vnet.subnet_ids["aks-snet"]
  default_node_pool             = var.aks_default_node_pool
  agw_id                        = module.devspoke_appgw.id
  addons                        = var.aks_addons
}
