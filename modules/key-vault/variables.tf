# Common

variable "location" {
  description = "Region for deployment"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource group"
  type        = string
}

# Key Vault

variable "name" {
  description = "Keyvault name"
  type        = string
}

variable "sku_name" {
  description = "sku name"
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "soft delete retention days"
  type        = number
}

variable "private_endpoint_name" {
  description = "Name given for a keyvault private endpoint"
  type        = string
}

variable "private_dns_zone_ids" {
  description = "List of Private DNS Zone IDs"
  type        = list(string)
}

variable "subnet_id" {
  description = "id given for a subnet to use to create private endpoint"
  type        = string
}

variable "public_network_access" {
  description = "Should public network access be possible?"
  type        = bool
}

variable "enable_rbac_authorization" {
  description = "Should enable_rbac_authorization be possible?"
  type        = bool
}

variable "keyvault_depends_on" {
  description = "using this variable to propagate dependencies"
  type        = any
  default     = []
}

variable "keyvault_network_acls" {
  description = "Network ACL configuration for Key Vault"
  type = object({
    bypass                     = string
    default_action             = string
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
}
