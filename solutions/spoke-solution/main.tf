####################
# Locals           #
####################

locals {
  private_dns_zones = {
    azurecr-io            = "privatelink.azurecr.io"
    blob-core-windows-net = "privatelink.blob.core.windows.net"
    vaultcore-azure-net   = "privatelink.vaultcore.azure.net"
    sql-server-net        = "privatelink.database.windows.net"
    postgres-server-net   = "privatelink.postgres.database.azure.com"
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
      version = "~>3.98.0"
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

provider "azurerm" {
  skip_provider_registration = true
  features {}
  alias           = "target"
  subscription_id = var.target_subscription_id
  client_id       = var.client_id_target
  client_secret   = var.client_secret_target
  tenant_id       = var.tenant_id_target
}

#####################
# Data section 			#
#####################

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone
data "azurerm_private_dns_zone" "sql-server-net" {
  provider = azurerm.target

  name                = local.private_dns_zones["sql-server-net"]
  resource_group_name = var.target_resource_group_name
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
  depends_on          = [module.devspoke_vnet.id, module.devspoke_appgw.id, module.devspoke_aks.id]
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

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "vnet_contributor" {
  scope                = module.devspoke_vnet.vnet_id
  role_definition_name = "Contributor"
  principal_id         = module.devspoke_aks.ingress_application_gateway_identity_object_id

  depends_on = [
    module.devspoke_aks.id,
    module.devspoke_vnet.id
  ]
}

module "devspoke_vnet" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-vnet.git?ref=v1.2.0"

  name                = var.devspoke_vnet_name
  location            = azurerm_resource_group.devspoke.location
  resource_group_name = azurerm_resource_group.devspoke.name
  tags                = var.tags
  address_space       = var.devspoke_vnet_address_space

  subnets = {
    support-snet = {
      address_prefix                                = [var.support_snet_address_prefix]
      delegation                                    = []
      service_endpoints                             = []
      private_link_service_network_policies_enabled = false
      private_endpoint_network_policies_enabled     = false
    },
    dflbusgateway-snet = {
      address_prefix                                = [var.gateway_snet_address_prefix]
      delegation                                    = []
      service_endpoints                             = []
      private_link_service_network_policies_enabled = true
      private_endpoint_network_policies_enabled     = false
    },
    aks-snet = {
      address_prefix                                = [var.aks_snet_address_prefix]
      delegation                                    = []
      service_endpoints                             = []
      private_link_service_network_policies_enabled = true
      private_endpoint_network_policies_enabled     = false
    },
    database-snet = {
      address_prefix = [var.database_snet_address_prefix]
      delegation = [
        {
          name    = "Microsoft.DBforPostgreSQL/flexibleServers"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", ]
        }
      ]
      service_endpoints                             = ["Microsoft.Storage"]
      private_link_service_network_policies_enabled = true
      private_endpoint_network_policies_enabled     = false
    }
  }
}

module "devspoke_route_table" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-routetable.git?ref=v1.2.0"

  name                = var.route_table_name
  location            = azurerm_resource_group.devspoke.location
  resource_group_name = azurerm_resource_group.devspoke.name
  tags                = var.tags
  route_table_routes  = var.devspoke_route_table_routes
}
resource "azurerm_subnet_route_table_association" "devspoke_support" {
  subnet_id      = module.devspoke_vnet.subnet_ids["support-snet"]
  route_table_id = module.devspoke_route_table.route_table_id
}

resource "azurerm_subnet_route_table_association" "devspoke_aks" {
  subnet_id      = module.devspoke_vnet.subnet_ids["aks-snet"]
  route_table_id = module.devspoke_route_table.route_table_id
}

module "devspoke_storage" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-storageaccount.git?ref=v1.2.0"

  name                             = var.devspoke_storage_name
  location                         = azurerm_resource_group.devspoke.location
  resource_group_name              = azurerm_resource_group.devspoke.name
  tags                             = var.tags
  account_tier                     = var.devspoke_storage_account_tier
  account_kind                     = var.devspoke_storage_account_kind
  account_replication_type         = var.devspoke_storage_account_replication_type
  cross_tenant_replication_enabled = var.devspoke_cross_tenant_replication_enabled
  change_feed_enabled              = var.devspoke_change_feed_enabled
  versioning_enabled               = var.devspoke_versioning_enabled
  containers                       = var.devspoke_storage_containers
  private_endpoint_name            = var.devspoke_storage_private_endpoint_name
  private_dns_zone_ids = [
    azurerm_private_dns_zone.private_dns_zones["blob-core-windows-net"].id,
  ]
  subnet_id                 = module.devspoke_vnet.subnet_ids["support-snet"]
  public_network_access     = true
  storageaccount_depends_on = [module.devspoke_aks]
}

module "devspoke_infox_storage" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-storageaccount.git?ref=v1.2.0"

  name                             = var.devspoke_infox_storage_name
  location                         = azurerm_resource_group.devspoke.location
  resource_group_name              = azurerm_resource_group.devspoke.name
  tags                             = var.tags
  account_tier                     = var.devspoke_infox_storage_account_tier
  account_kind                     = var.devspoke_infox_storage_account_kind
  account_replication_type         = var.devspoke_infox_storage_account_replication_type
  cross_tenant_replication_enabled = var.devspoke_infox_cross_tenant_replication_enabled
  change_feed_enabled              = var.devspoke_infox_change_feed_enabled
  versioning_enabled               = var.devspoke_infox_versioning_enabled
  containers                       = var.devspoke_infox_storage_containers
  private_endpoint_name            = var.devspoke_infox_storage_private_endpoint_name
  private_dns_zone_ids = [
    azurerm_private_dns_zone.private_dns_zones["blob-core-windows-net"].id,
  ]
  subnet_id                 = module.devspoke_vnet.subnet_ids["support-snet"]
  public_network_access     = true
  storageaccount_depends_on = [module.devspoke_storage]
}

module "devspoke_treasure_storage" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-storageaccount.git?ref=v1.2.0"

  name                             = var.devspoke_treasure_storage_name
  location                         = azurerm_resource_group.devspoke.location
  resource_group_name              = azurerm_resource_group.devspoke.name
  tags                             = var.tags
  account_tier                     = var.devspoke_treasure_storage_account_tier
  account_kind                     = var.devspoke_treasure_storage_account_kind
  account_replication_type         = var.devspoke_treasure_storage_account_replication_type
  cross_tenant_replication_enabled = var.devspoke_treasure_cross_tenant_replication_enabled
  change_feed_enabled              = var.devspoke_treasure_change_feed_enabled
  versioning_enabled               = var.devspoke_treasure_versioning_enabled
  containers                       = var.devspoke_treasure_storage_containers
  private_endpoint_name            = var.devspoke_treasure_storage_private_endpoint_name
  private_dns_zone_ids = [
    azurerm_private_dns_zone.private_dns_zones["blob-core-windows-net"].id,
  ]
  subnet_id                 = module.devspoke_vnet.subnet_ids["support-snet"]
  public_network_access     = true
  storageaccount_depends_on = [module.devspoke_infox_storage]
}

module "devspoke_montaviz_storage" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-storageaccount.git?ref=v1.2.0"

  name                             = var.devspoke_montaviz_storage_name
  location                         = azurerm_resource_group.devspoke.location
  resource_group_name              = azurerm_resource_group.devspoke.name
  tags                             = var.tags
  account_tier                     = var.devspoke_montaviz_storage_account_tier
  account_kind                     = var.devspoke_montaviz_storage_account_kind
  account_replication_type         = var.devspoke_montaviz_storage_account_replication_type
  cross_tenant_replication_enabled = var.devspoke_montaviz_cross_tenant_replication_enabled
  change_feed_enabled              = var.devspoke_montaviz_change_feed_enabled
  versioning_enabled               = var.devspoke_montaviz_versioning_enabled
  containers                       = var.devspoke_montaviz_storage_containers
  private_endpoint_name            = var.devspoke_montaviz_storage_private_endpoint_name
  private_dns_zone_ids = [
    azurerm_private_dns_zone.private_dns_zones["blob-core-windows-net"].id,
  ]
  subnet_id                 = module.devspoke_vnet.subnet_ids["support-snet"]
  public_network_access     = true
  storageaccount_depends_on = [module.devspoke_treasure_storage]
}

module "support_vm_linux" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-vm_linux.git?ref=v1.2.0"

  name                                  = var.vm_linux_name
  location                              = azurerm_resource_group.devspoke.location
  resource_group_name                   = azurerm_resource_group.devspoke.name
  tags                                  = var.tags
  storage_account_primary_blob_endpoint = module.devspoke_storage.primary_blob_endpoint
  subnet_id                             = module.devspoke_vnet.subnet_ids["support-snet"]
  username                              = var.vm_linux_username
  password                              = var.vm_linux_password
  custom_data_path                      = var.custom_data_path
  vmlinux_depends_on                    = [module.devspoke_montaviz_storage]
}

module "support_vm_windows" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-vm_windows.git?ref=v1.2.0"

  name                 = var.vm_windows_name
  location             = azurerm_resource_group.devspoke.location
  resource_group_name  = azurerm_resource_group.devspoke.name
  tags                 = var.tags
  subnet_id            = module.devspoke_vnet.subnet_ids["support-snet"]
  username             = var.vm_windows_username
  password             = var.vm_windows_password
  vmwindows_depends_on = [module.support_vm_linux]
}

module "devspoke_keyvault" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-keyvault.git?ref=v1.2.0"

  name                       = var.devspoke_keyvault_name
  location                   = azurerm_resource_group.devspoke.location
  resource_group_name        = azurerm_resource_group.devspoke.name
  sku_name                   = var.devspoke_keyvault_sku_name
  soft_delete_retention_days = var.devspoke_keyvault_soft_delete_retention_days
  private_endpoint_name      = var.devspoke_keyvault_private_endpoint_name
  private_dns_zone_ids = [
    azurerm_private_dns_zone.private_dns_zones["vaultcore-azure-net"].id
  ]
  subnet_id                 = module.devspoke_vnet.subnet_ids["support-snet"]
  public_network_access     = var.devspoke_keyvault_public_network_access
  enable_rbac_authorization = var.devspoke_keyvault_enable_rbac_authorization
  keyvault_depends_on       = [module.support_vm_windows]
    keyvault_network_acls = {
    bypass         = var.keyvault_network_acls.bypass
    default_action = var.keyvault_network_acls.default_action
    ip_rules       = var.keyvault_network_acls.ip_rules
    virtual_network_subnet_ids = [
      module.devspoke_vnet.subnet_ids["support-snet"]
    ]
  }
}

module "montaviz_keyvault" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-keyvault.git?ref=v1.2.0"

  name                       = var.montaviz_keyvault_name
  location                   = azurerm_resource_group.devspoke.location
  resource_group_name        = azurerm_resource_group.devspoke.name
  sku_name                   = var.montaviz_keyvault_sku_name
  soft_delete_retention_days = var.montaviz_keyvault_soft_delete_retention_days
  private_endpoint_name      = var.montaviz_keyvault_private_endpoint_name
  private_dns_zone_ids = [
    azurerm_private_dns_zone.private_dns_zones["vaultcore-azure-net"].id
  ]
  subnet_id                 = module.devspoke_vnet.subnet_ids["support-snet"]
  public_network_access     = var.montaviz_keyvault_public_network_access
  enable_rbac_authorization = var.montaviz_keyvault_enable_rbac_authorization
  keyvault_depends_on       = [module.devspoke_keyvault]
    keyvault_network_acls = {
    bypass         = var.keyvault_network_acls.bypass
    default_action = var.keyvault_network_acls.default_action
    ip_rules       = var.keyvault_network_acls.ip_rules
    virtual_network_subnet_ids = [
      module.devspoke_vnet.subnet_ids["support-snet"]
    ]
  }
}

module "devspoke_acr_privateendpoint" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-acr-pe.git?ref=v1.2.0"

  build_resource_group_name       = var.build_resource_group_name
  build_acr_name                  = var.build_acr_name
  resource_group_name             = azurerm_resource_group.devspoke.name
  location                        = azurerm_resource_group.devspoke.location
  acr_build_private_endpoint_name = var.acr_build_private_endpoint_name
  private_dns_zone_ids = [
    azurerm_private_dns_zone.private_dns_zones["azurecr-io"].id
  ]
  subnet_id = module.devspoke_vnet.subnet_ids["support-snet"]
}

module "devspoke_sql_server" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-sql_server.git?ref=v1.2.0"

  sql_server_name              = var.sql_server_name
  resource_group_name          = azurerm_resource_group.devspoke.name
  location                     = azurerm_resource_group.devspoke.location
  administrator_login          = var.sql_server_administrator_login
  administrator_login_password = var.sql_server_administrator_login_password
  private_endpoint = {
    private_endpoint_support_dev = {
      subnet_id = module.devspoke_vnet.subnet_ids["support-snet"]
    }
    private_endpoint_AKS_dev = {
      subnet_id = module.devspoke_vnet.subnet_ids["aks-snet"]
    }
  }
  private_dns_zone_ids = [
    azurerm_private_dns_zone.private_dns_zones["sql-server-net"].id
  ]
  sql_depends_on = [module.devspoke_acr_privateendpoint]
}

module "devspoke_sql_server_pe" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-privateendpoint.git?ref=v1.2.0"

  providers = {
    azurerm.target = azurerm.target
  }

  target_resource_group_name = var.target_resource_group_name
  target_vnet_name           = var.target_vnet_name
  target_snet_name           = var.target_snet_name
  pe_resource_group_name     = var.pe_resource_group_name
  pe_resource_group_location = var.pe_resource_group_location
  private_endpoint_name      = var.devspoke_sql_hub_private_endpoint_name
  resource_id                = module.devspoke_sql_server.id
  subresource_name           = var.sql_server_subresource_name
  private_dns_zone_ids = [
    data.azurerm_private_dns_zone.sql-server-net.id
  ]
}

module "devspoke_postgresflex" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-postgresflex.git?ref=v1.2.0"

  name                  = var.psql_name
  location              = azurerm_resource_group.devspoke.location
  resource_group_name   = azurerm_resource_group.devspoke.name
  tags                  = var.tags
  username              = var.psql_username
  password              = var.psql_password
  sku_name              = var.psql_sku_name
  db_version            = var.psql_version
  storage_mb            = var.psql_storage_mb
  backup_retention_days = var.psql_backup_retention_days
  zone                  = var.psql_zone
  private_dns_zone_id   = azurerm_private_dns_zone.private_dns_zones["postgres-server-net"].id
  subnet_id             = module.devspoke_vnet.subnet_ids["database-snet"]
  psqlflex_depends_on   = [module.devspoke_sql_server_pe]
}

module "devspoke_appgw" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-agw.git?ref=v1.2.0"

  name                            = var.application_gateway_name
  resource_group                  = azurerm_resource_group.devspoke.name
  location                        = azurerm_resource_group.devspoke.location
  subnet_id                       = module.devspoke_vnet.subnet_ids["dflbusgateway-snet"]
  support_subnet_id               = module.devspoke_vnet.subnet_ids["support-snet"]
  environment                     = var.environment
  appgw_private_ip                = var.appgw_private_ip_address
  shared_key_vault_name           = var.shared_key_vault_name
  shared_key_vault_resource_group = var.shared_key_vault_resource_group
  shared_certificate_name         = var.shared_certificate_name
  apgw_depends_on                 = [module.devspoke_vnet]
}

module "devspoke_appgw_pe" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-agw-pe.git?ref=v1.2.0"

  providers = {
    azurerm.target = azurerm.target
  }

  target_resource_group_name = var.target_resource_group_name
  target_vnet_name           = var.target_vnet_name
  target_snet_name           = var.target_snet_name
  pe_resource_group_name     = var.pe_resource_group_name
  pe_resource_group_location = var.pe_resource_group_location
  private_endpoint_name      = "${var.devspoke_appgw_private_endpoint_name}-hub"
  resource_id                = module.devspoke_appgw.id
  subresource_name           = ["${var.application_gateway_name}-priv-ip"]
}

module "devspoke_aks" {
  source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-aks.git?ref=feature/disableomsagent"

  name                  = var.aks_name
  Managedidentity_name  = var.managed_identity_name
  resource_group_name   = azurerm_resource_group.devspoke.name
  tags                  = var.tags
  additional_node_pools = var.aks_additional_node_pools
  private_cluster       = var.aks_private_cluster
  kubernetes_version    = var.aks_kubernetes_version
  subnet_id             = module.devspoke_vnet.subnet_ids["aks-snet"]
  default_node_pool     = var.aks_default_node_pool
  agw_id                = module.devspoke_appgw.id
  addons                = var.aks_addons
  azure_ad_rbac_enabled = var.azure_ad_rbac_enabled
  aks_depends_on        = [module.devspoke_appgw]
}
