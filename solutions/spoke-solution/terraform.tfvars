# Common

resource_group_name = "dflbus-dev-rg"
tags = {
  "Environment" : "dev",
  "Project" : "DFLBUS devspoke"
}
environment = "dev"

# Storage DevSpoke

devspoke_storage_name                     = "dflbusiq4busdev"
devspoke_storage_containers               = ["dflbus-dev-rg"]
devspoke_storage_private_endpoint_name    = "dflbusiq4busdev"
devspoke_cross_tenant_replication_enabled = true
devspoke_change_feed_enabled              = true
devspoke_versioning_enabled               = true



# Storage account InfoX

devspoke_infox_storage_name                     = "infoxdev"
devspoke_infox_storage_containers               = ["infox-germany", "infox-turkey", "infox-shared"]
devspoke_infox_storage_private_endpoint_name    = "infoxdevpe"
devspoke_infox_cross_tenant_replication_enabled = true
devspoke_infox_change_feed_enabled              = true
devspoke_infox_versioning_enabled               = true

# Storage account Treasure

devspoke_treasure_storage_name                     = "dflbustreasuredev"
devspoke_treasure_storage_containers               = ["dflbustreasuredev", "dflbustreasureint", "temp-files"]
devspoke_treasure_storage_private_endpoint_name    = "dflbustreasuredev"
devspoke_treasure_cross_tenant_replication_enabled = true
devspoke_treasure_change_feed_enabled              = false
devspoke_treasure_versioning_enabled               = false

# Storage account Montaviz

devspoke_montaviz_storage_name                     = "dflbusmontavizdev"
devspoke_montaviz_storage_containers               = ["dflbus-montaviz-dev", "temp-files"]
devspoke_montaviz_storage_private_endpoint_name    = "dflbusmontavizdev"
devspoke_montaviz_cross_tenant_replication_enabled = true
devspoke_montaviz_change_feed_enabled              = true
devspoke_montaviz_versioning_enabled               = true

# VNet

devspoke_vnet_name          = "dflbus-dev-vnet"
devspoke_vnet_address_space = [""]

# Subnets

support_snet_address_prefix  = ""
aks_snet_address_prefix      = ""
gateway_snet_address_prefix  = ""
database_snet_address_prefix = ""



# Route Table

route_table_name = "devRouteTable"
devspoke_route_table_routes = {
  # -- add route for ENV support subnet to target firewall in hub
  "01" = {
    "name"                   = "route-01"
    "address_prefix"         = ""
    "next_hop_type"          = "VirtualAppliance"
    "next_hop_in_ip_address" = ""
  },
  #-- UDR to on-prem email server
  "built2hubfw53151" = {
    "name"                   = ""
    "address_prefix"         = ""
    "next_hop_type"          = "VirtualAppliance"
    "next_hop_in_ip_address" = ""
  },
  # -- UDR to on-prem DNS server
  "built2hubfw5318" = {
    "name"                   = "route-built2hubfw5318"
    "address_prefix"         = ""
    "next_hop_type"          = "VirtualAppliance"
    "next_hop_in_ip_address" = ""
  },
  # -- UDR to on-prem SAP server
  "built2hubfw5316" = {
    "name"                   = "route-built2hubfw5316"
    "address_prefix"         = ""
    "next_hop_type"          = "VirtualAppliance"
    "next_hop_in_ip_address" = ""
  },
  # -- UDR to on-prem SAP server
  "built2hubfw5348" = {
    "name"                   = ""
    "address_prefix"         = ""
    "next_hop_type"          = "VirtualAppliance"
    "next_hop_in_ip_address" = ""
  },
  # -- UDR to on-prem GIT
  "built2hubfw5320045" = {
    "name"                   = "route-built2hubfw5320045"
    "address_prefix"         = ""
    "next_hop_type"          = "VirtualAppliance"
    "next_hop_in_ip_address" = ""
  },
  # -- to hub VM's
  "2hubVMs" = {
    "name"                   = "route-2hubVMs"
    "address_prefix"         = ""
    "next_hop_type"          = "VirtualAppliance"
    "next_hop_in_ip_address" = ""
  },
  # -- 53.254
  "53.254" = {
    "name"                   = "route-53.254"
    "address_prefix"         = ""
    "next_hop_type"          = "VirtualAppliance"
    "next_hop_in_ip_address" = "4"
  },
  # -- 53.29-DNS
  "53.29-DNS" = {
    "name"                   = "route-5-DNS"
    "address_prefix"         = "6"
    "next_hop_type"          = "VirtualAppliance"
    "next_hop_in_ip_address" = ""
  },
  # -- 53.17
  "53.17" = {
    "name"                   = "route-5"
    "address_prefix"         = ""
    "next_hop_type"          = "VirtualAppliance"
    "next_hop_in_ip_address" = "5"
  },

  "53.200.41" = {
    "name"                   = "route-TestZGDOK"
    "address_prefix"         = ""
    "next_hop_type"          = "VirtualAppliance"
    "next_hop_in_ip_address" = "5"
  },

  "53.200.42" = {
    "name"                   = "route-ProdZGDOK"
    "address_prefix"         = ""
    "next_hop_type"          = "VirtualAppliance"
    "next_hop_in_ip_address" = "5"
  },
}

# Linux VM

vm_linux_name     = "dev-linux-vm"
vm_linux_username = "azuser"
# The build cloud.sh should be in modules and update path in tfvars files accordingly
custom_data_path = "../built-cloud-standard.sh"

# Windows VM

vm_windows_name     = "dev-win-vm"
vm_windows_username = "azuser"

# Application Gateway

application_gateway_name             = "dflbus-AppGW-dev"
appgw_private_ip_address             = ""
shared_key_vault_name                = "kvdflbusiq4busshared"
shared_key_vault_resource_group      = "dflbus-kv-rg"
shared_certificate_name              = "Iq4busWildcardPfX"
devspoke_appgw_private_endpoint_name = "pe-AppGW-dev"

# Azure Kubernetes Service

aks_name               = "dflbus-aks-cluster-dev"
aks_kubernetes_version = "1.30.0"
aks_private_cluster    = false
azure_ad_rbac_enabled  = true
aks_addons = {
  azure_policy = true
}
aks_default_node_pool = {
  name                           = "nodepool2"
  node_count                     = 3
  vm_size                        = "Standard_B4ms"
  max_pods                       = 30
  zones                          = ["3"]
  labels                         = null
  taints                         = null
  cluster_auto_scaling           = true
  cluster_auto_scaling_min_count = 3
  cluster_auto_scaling_max_count = 6
}
aks_additional_node_pools = {}

# Managed identity
managed_identity_name = "dflbuscontrolplaneid-dev"

# Devspoke keyvault

devspoke_keyvault_name                       = "kv-dev-dflbus"
devspoke_keyvault_sku_name                   = "standard"
devspoke_keyvault_soft_delete_retention_days = 90
devspoke_keyvault_private_endpoint_name      = "kvdflbusdevpe"
devspoke_keyvault_public_network_access      = true
devspoke_keyvault_enable_rbac_authorization  = true
keyvault_network_acls = {
  bypass         = "AzureServices"
  default_action = "Deny"
  ip_rules       = ["", ""]
}

# Montaviz keyvault

montaviz_keyvault_name                       = "kv-dev-montaviz"
montaviz_keyvault_sku_name                   = "standard"
montaviz_keyvault_soft_delete_retention_days = 90
montaviz_keyvault_private_endpoint_name      = "kvmontavizdevpe"
montaviz_keyvault_public_network_access      = true
montaviz_keyvault_enable_rbac_authorization  = true

# ACR Private Endpoint

build_resource_group_name       = "dflbus-acr-rg"
build_acr_name                  = "dflbusacr"
acr_build_private_endpoint_name = "acrdflbusiq4busdev"

# Sql server

sql_server_name                        = "infox-devenv"
sql_server_administrator_login         = "azuser"
devspoke_sql_hub_private_endpoint_name = "priv-ep-infox-devenv-hub"

# Postgresql Flex

psql_name                  = "dflbus-flex-db-devenv"
psql_username              = "postgres"
psql_sku_name              = "GP_Standard_D2s_v3"
psql_version               = "13"
psql_storage_mb            = "131072"
psql_backup_retention_days = "7"
psql_zone                  = "2"

# Target ENV

target_subscription_id      = ""
target_resource_group_name  = "dflbus-hub-rg"
target_vnet_name            = "dflbus-hub-vnet"
target_snet_name            = "support-subnet-sn"
pe_resource_group_name      = "privateendpoints"
pe_resource_group_location  = "Germany West Central"
sql_server_subresource_name = ["sqlServer"]
