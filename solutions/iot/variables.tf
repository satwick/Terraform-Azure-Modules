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

# VNet

variable "iot_vnet_name" {
  description = "Name of the IoT VNET"
  type        = string
}

variable "iot_vnet_address_space" {
  description = "The address space of the IoT virtual network"
  type        = list(string)
  default     = ["172.30.0.0/16"]
}

variable "support_snet_address_prefix" {
  description = "The address prefix of the support subnet"
  type        = string
}

variable "iot_snet_address_prefix" {
  description = "The address prefix of the iot subnet"
  type        = string
}

#  Event Hub (Namespace)

variable "event_hub_namespace_name" {
  description = "Name of Event Hub Development Namespace"
  type        = string
}

variable "eventhub_private_endpoint_name" {
  description = "Name of Event Hub Development Private Endpoint"
  type        = string
}

# Private Endpoint

variable "target_dns_resource_group_name" {
  description = "Resource group name of the target DNS"
  type        = string
}

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
  description = "Resource group name of the target Vnet "
  type        = string
}

variable "target_vnet_name" {
  description = "Target vnet name "
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

variable "eventhub_subresource_name" {
  description = "Name of the subresource"
  type        = list(string)
  default     = ["namespace"]
}

# Azure Data Explorer

variable "adx_name" {
  description = "Name of Azure Data Explorer"
  type        = string
}

variable "adx_database_name" {
  description = "Name of Azure Data Explorer Database"
  type        = string
}

variable "adx_sku" {
  description = "Name of Azure Data Explorer SKU"
  type        = string
  default     = "Dev(No SLA)_Standard_E2a_v4"
}

variable "adx_capacity" {
  description = "Capacity of Azure Data Explorer Instance"
  type        = number
  default     = 1 # Potential to increase to 3 after going production
}

variable "adx_nsg_name" {
  description = "Name of the Azure Data Explorer Subnet Network Security Group"
  type        = string
}

variable "adx_private_endpoint_name" {
  description = "Name of Azure Data Explorer Private Endpoint"
  type        = string
}
