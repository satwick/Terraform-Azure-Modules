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

variable "environment"{
  description = "Name of the spoke environment being provisioned DEV?INT?PROD"
  type        = string
}

# VNET 

variable "devspoke_vnet_name" {
  description = "Name of the devspoke VNET"
  type        = string
}

variable "devspoke_vnet_address_space" {
  description = "The address space of the devspoke virtual network"
  type        = list(string)
}

variable "database_snet_address_prefix" {
  description = "The address prefix of the database subnet"
  type        = string
}

variable "support_snet_address_prefix" {
  description = "The address prefix of the support subnet"
  type        = string
}

variable "devspoke_snet_address_prefix" {
  description = "The address prefix of the devspoke subnet"
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
  description = "The list of route definitions applied to the custom route table."
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
}

variable "custom_data_path" {
  description = "path"
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
}

# Storage 

variable "devspoke_storage_name" {
  description = "Name of the storage account"
  type        = string
}

variable "devspoke_storage_account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "devspoke_storage_account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}

variable "devspoke_storage_containers" {
  description = "List of container names that will be created in the storage account"
  type        = list(string)
}

variable "devspoke_storage_private_endpoint_name" {
  description = "Name of storage private endpoint"
  type        = string
}

# Key Vault

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
  description = "public access of devspoke keyvault"
  type        = bool
}

# Sql Server

variable "sql_server_name" {
  description = "The name of the Azure SQL Server"
  type        = string
}

variable "administrator_login" {
  description = "SQL Server administrator login"
  type        = string
}

variable "administrator_login_password" {
  description = "SQL Server administrator login password"
  type        = string
}

variable "edition" {
  description = "Edition of the SQL Database"
  type        = string
}

variable "collation" {
  description = "Collation of the SQL Database"
  type        = string
}

variable "max_size_gb" {
  description = "Maximum size of the SQL Database in GB"
  type        = number
}

variable "devspoke_sql_private_endpoint_name" {
  description = "Name of storage private endpoint"
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
  type        = string
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

#AKS

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

variable "aks_default_node_pool" {
  description = "Defines the default node pool information."
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
    node_count                     = number
    node_os                        = string
    vm_size                        = string
    max_pods                       = number
    zones                          = list(string)
    labels                         = map(string)
    taints                         = list(string)
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
  }))
}
