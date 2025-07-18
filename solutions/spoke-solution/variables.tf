# Common 

variable "location" {
  description = "Region for deployment"
  type        = string
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "Name of the Resource group"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}

variable "environment" {
  description = "Name of the spoke environment being provisioned DEV?INT?PROD"
  type        = string
}

# VNET devspoke

variable "devspoke_vnet_name" {
  description = "Name of the devspoke VNET"
  type        = string
}

variable "devspoke_vnet_address_space" {
  description = "The address space of the devspoke virtual network"
  type        = list(string)
}

# Subnets

variable "database_snet_address_prefix" {
  description = "The address prefix of the database subnet"
  type        = string
}

variable "support_snet_address_prefix" {
  description = "The address prefix of the support subnet"
  type        = string
}

variable "aks_snet_address_prefix" {
  description = "The address prefix of the aks subnet"
  type        = string
}

variable "gateway_snet_address_prefix" {
  description = "The address prefix of the gateway subnet"
  type        = string
}

# Route Table

variable "route_table_name" {
  description = "The name of the Route Table"
  type        = string
}

variable "devspoke_route_table_routes" {
  type        = map(any)
  description = "The list of route definitions applied to the custom route table"
  default     = null
}

# Linux VM

variable "vm_linux_name" {
  description = "The name of the Linux Virtual Machine"
  type        = string
}

variable "vm_linux_username" {
  description = "The username for Linux Virtual Machine"
  type        = string
}

variable "vm_linux_password" {
  description = "The password for Linux Virtual Machine"
  type        = string
  sensitive   = true
}

# To run this custom data path, the Cloud Standard script needs to be added to the module folder
variable "custom_data_path" {
  description = "The Base64-Encoded Custom Data path which should be used for this Virtual Machine"
  type        = string
}

# Windows VM

variable "vm_windows_name" {
  description = "The name of the Windows Virtual Machine"
  type        = string
}

variable "vm_windows_username" {
  description = "The username for Windows Virtual Machine"
  type        = string
}

variable "vm_windows_password" {
  description = "The password for Windows Virtual Machine"
  type        = string
  sensitive   = true
}

# Storage account devspoke

variable "devspoke_storage_name" {
  description = "Name of the storage account"
  type        = string
}

variable "devspoke_storage_account_tier" {
  description = "Specifies the access tier"
  type        = string
  default     = "Standard"
}

variable "devspoke_storage_account_kind" {
  description = "Defines the Kind of storage account. Defaults to StorageV2"
  type        = string
  default     = "StorageV2"
}

variable "devspoke_storage_account_replication_type" {
  description = "Specifies the data replication strategy for the storage account"
  type        = string
  default     = "LRS"
}

variable "devspoke_cross_tenant_replication_enabled" {
  description = "Defines if devspoke_cross_tenant_replication should be enabled or not"
  type        = bool
}

variable "devspoke_change_feed_enabled" {
  description = "Is the blob service properties for change feed events enabled? "
  type        = bool
}

variable "devspoke_versioning_enabled" {
  description = "Defines if versioning should be enabled or not? "
  type        = bool
}

variable "devspoke_storage_containers" {
  description = "List of container names that will be created in the storage account"
  type        = list(string)
}

variable "devspoke_storage_private_endpoint_name" {
  description = "Name of storage account private endpoint"
  type        = string
}

# Storage account infox

variable "devspoke_infox_storage_name" {
  description = "Name of the storage account for infox application"
  type        = string
}

variable "devspoke_infox_storage_account_tier" {
  description = "Specifies the access tier for the infox application's storage account"
  type        = string
  default     = "Standard"
}

variable "devspoke_infox_storage_account_kind" {
  description = "Defines the Kind of account for infox application. Defaults to StorageV2"
  type        = string
  default     = "StorageV2"
}

variable "devspoke_infox_storage_account_replication_type" {
  description = "Specifies the data replication strategy for the Infox application's storage account"
  type        = string
  default     = "LRS"
}
variable "devspoke_infox_cross_tenant_replication_enabled" {
  description = "Defines if devspoke_infox_cross_tenant_replication should be enabled or not"
  type        = bool
}

variable "devspoke_infox_change_feed_enabled" {
  description = "Is the blob service properties for change feed events enabled? "
  type        = bool
}

variable "devspoke_infox_versioning_enabled" {
  description = "Defines if versioning should be enabled or not? "
  type        = bool
}

variable "devspoke_infox_storage_containers" {
  description = "List of container names that will be created in the storage account for infox application"
  type        = list(string)
}

variable "devspoke_infox_storage_private_endpoint_name" {
  description = "Name of storage private endpoint for infox application"
  type        = string
}

# Storage account treasure

variable "devspoke_treasure_storage_name" {
  description = "Name of the storage account for treasure"
  type        = string
}

variable "devspoke_treasure_storage_account_tier" {
  description = "Specifies the access tier for treasure"
  type        = string
  default     = "Standard"
}

variable "devspoke_treasure_storage_account_kind" {
  description = "Defines the Kind of account for treasure. Defaults to StorageV2"
  type        = string
  default     = "StorageV2"
}

variable "devspoke_treasure_storage_account_replication_type" {
  description = "Specifies the data replication strategy for treasure"
  type        = string
  default     = "LRS"
}

variable "devspoke_treasure_cross_tenant_replication_enabled" {
  description = "Defines if devspoke_infox_cross_tenant_replication should be enabled or not"
  type        = bool
}

variable "devspoke_treasure_change_feed_enabled" {
  description = "Is the blob service properties for change feed events enabled? "
  type        = bool
}

variable "devspoke_treasure_versioning_enabled" {
  description = "Defines if versioning should be enabled or not? "
  type        = bool
}

variable "devspoke_treasure_storage_containers" {
  description = "List of container names that will be created in the storage account for treasure"
  type        = list(string)
}

variable "devspoke_treasure_storage_private_endpoint_name" {
  description = "Name of storage private endpoint for treasure"
  type        = string
}

# Storage account montaviz

variable "devspoke_montaviz_storage_name" {
  description = "Name of the storage account for montaviz"
  type        = string
}

variable "devspoke_montaviz_storage_account_tier" {
  description = "Specifies the access tier for montaviz"
  type        = string
  default     = "Standard"
}

variable "devspoke_montaviz_storage_account_kind" {
  description = "Defines the Kind of account for montaviz. Defaults to StorageV2"
  type        = string
  default     = "StorageV2"
}

variable "devspoke_montaviz_storage_account_replication_type" {
  description = "Specifies the data replication strategy for montaviz"
  type        = string
  default     = "LRS"
}

variable "devspoke_montaviz_cross_tenant_replication_enabled" {
  description = "Defines if devspoke_infox_cross_tenant_replication should be enabled or not"
  type        = bool
}

variable "devspoke_montaviz_change_feed_enabled" {
  description = "Is the blob service properties for change feed events enabled? "
  type        = bool
}

variable "devspoke_montaviz_versioning_enabled" {
  description = "Defines if versioning should be enabled or not? "
  type        = bool
}

variable "devspoke_montaviz_storage_containers" {
  description = "List of container names that will be created in the storage account for montaviz"
  type        = list(string)
}

variable "devspoke_montaviz_storage_private_endpoint_name" {
  description = "Name of storage private endpoint for montaviz"
  type        = string
}

# Devspoke Key Vault

variable "devspoke_keyvault_name" {
  description = "Name of keyvault"
  type        = string
}

variable "devspoke_keyvault_sku_name" {
  description = "Name of keyvault sku"
  type        = string
}

variable "devspoke_keyvault_soft_delete_retention_days" {
  description = "Number of retention days after soft delete"
  type        = number
}

variable "devspoke_keyvault_private_endpoint_name" {
  description = "Name of Private Endpoint of keyvault"
  type        = string
}

variable "devspoke_keyvault_public_network_access" {
  description = "Public network access of devspoke keyvault"
  type        = bool
}

variable "devspoke_keyvault_enable_rbac_authorization" {
  description = "enable_rbac_authorization of devspoke keyvault"
  type        = bool
}

variable "keyvault_network_acls" {
  description = "Network ACL configuration for Key Vault"
  type = object({
    bypass         = string
    default_action = string
    ip_rules       = list(string)
  })
}

#  Montaviz Key Vault

variable "montaviz_keyvault_name" {
  description = "Name of keyvault"
  type        = string
}

variable "montaviz_keyvault_sku_name" {
  description = "Name of keyvault sku"
  type        = string
}

variable "montaviz_keyvault_soft_delete_retention_days" {
  description = "Number of retention days after soft delete"
  type        = number
}

variable "montaviz_keyvault_private_endpoint_name" {
  description = "Name of Private Endpoint of keyvault"
  type        = string
}

variable "montaviz_keyvault_public_network_access" {
  description = "Public network access of montaviz keyvault"
  type        = bool
}

variable "montaviz_keyvault_enable_rbac_authorization" {
  description = "enable_rbac_authorization of montaviz keyvault"
  type        = bool
}

# Sql Server

variable "sql_server_name" {
  description = "The name of the Azure SQL Server"
  type        = string
}

variable "sql_server_administrator_login" {
  description = "SQL Server administrator login"
  type        = string
}

variable "sql_server_administrator_login_password" {
  description = "SQL Server administrator login password"
  type        = string
  sensitive   = true
}

variable "devspoke_sql_hub_private_endpoint_name" {
  description = "Name of SQL_server private endpoint for hub"
  type        = string
}

# PostgreSQL

variable "psql_name" {
  description = "Name of the PostgreSQL Database flexi Server"
  type        = string
}

variable "psql_username" {
  description = "Name of the PostgreSQL Database flexi Server user"
  type        = string
}

variable "psql_password" {
  description = "Password of the PostgreSQL Database flexi Server user"
  type        = string
  sensitive   = true
}

variable "psql_sku_name" {
  description = "Name of PostgreSQL Database flexi Server SKU"
  type        = string
}

variable "psql_version" {
  description = "Version of PostgreSQL Database flexi Server"
  type        = string
}

variable "psql_storage_mb" {
  description = "Storage of PostgreSQL Database flexi Server SKU in MB"
  type        = number
}

variable "psql_backup_retention_days" {
  description = "The backup retention days for the PostgreSQL Flexible Server"
  type        = number
}

variable "psql_zone" {
  description = "The Availability Zone in which the PostgreSQL Flexible Server should be located"
  type        = number
}

# Application Gateway

variable "application_gateway_name" {
  description = "Name of application gateway"
  type        = string
}

variable "appgw_private_ip_address" {
  description = "Private ip address of application gateway"
  type        = string
}

variable "appgw_public_ip_address_id" {
  description = "ID of Public IP address of application gateway"
  type        = string
  default     = null
}

variable "shared_key_vault_name" {
  description = "Name of the shared key vault"
  type        = string
}

variable "shared_key_vault_resource_group" {
  description = "Resource Group of shared keyvault"
  type        = string
}

variable "shared_certificate_name" {
  description = "Certificate name in the shared keyvault"
  type        = string
}


variable "devspoke_appgw_private_endpoint_name" {
  description = "Name of appgw private endpoint"
  type        = string
}

# Private Endpoint

variable "target_subscription_id" {
  description = "Subscription ID of target vnet"
  type        = string
}

variable "client_id_target" {
  description = "Client ID for service principal in target subscription"
  type        = string
}

variable "client_secret_target" {
  description = "Client Secret for service principal in target subscription"
  type        = string
  sensitive   = true
}

variable "tenant_id_target" {
  description = "Tenant ID for service principal in target subscription"
  type        = string
}

variable "target_resource_group_name" {
  description = "Resource group name of the target Vnet"
  type        = string
}

variable "target_vnet_name" {
  description = "Target vnet name"
  type        = string
}

variable "target_snet_name" {
  description = "Target subnet name"
  type        = string
}

variable "pe_resource_group_name" {
  description = "Resource group name of private endpoint"
  type        = string
}

variable "pe_resource_group_location" {
  description = "Region of the resource group where private endpoint is deployed"
  type        = string
}

variable "sql_server_subresource_name" {
  description = "A subresource name which the Private Endpoint is able to connect to sql server"
  type        = list(string)
}

# ACR Private endpoint
variable "build_resource_group_name" {
  description = "Name of the existing build resource group where the Azure Container Registry (ACR) is located"
  type        = string
}

variable "build_acr_name" {
  description = "Name of the existing Azure Container registry"
  type        = string
}

variable "acr_build_private_endpoint_name" {
  description = "Name of private endpoint of ACR"
  type        = string
}

# Managed Identity

variable "managed_identity_name" {
  description = "Name of the Managed Identity"
  type        = string
}

# Azure Kubernetes Service

variable "aks_name" {
  description = "Name of Azure Kubernetes Service"
  type        = string
}

variable "aks_kubernetes_version" {
  description = "Version of Azure Kubernetes Service cluster"
  type        = string
}

variable "aks_private_cluster" {
  description = "Should the Azure Kubernetes Cluster be deployed in Private Mode?"
  type        = bool
}

variable "aks_addons" {
  description = "Defines which addons will be activated."
  type = object({
    azure_policy = bool
  })
}

variable "azure_ad_rbac_enabled" {
  description = "RBAC enabled "
  type        = bool
}

variable "aks_default_node_pool" {
  description = "Defines the default node pool information"
  type = object({
    name                           = string
    node_count                     = number
    vm_size                        = string
    max_pods                       = number
    zones                          = list(string)
    labels                         = map(string)
    taints                         = list(string)
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
  })
}

variable "aks_additional_node_pools" {
  description = "Defines additional node pools that are added besides the default node pool."
  type = map(object({
    name                           = string
    node_count                     = number
    vm_size                        = string
    max_pods                       = number
    zones                          = list(string)
    labels                         = map(string)
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
  }))
}
