# Common

variable "location" {
  description = "Region for deployment"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource group"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}

# Storage Account

variable "name" {
  description = "Storage account name"
  type        = string
}

variable "account_tier" {
  description = "Defines the access tier for blobs"
  type        = string
}

variable "account_kind" {
  description = "Defines the Kind of account"
  type        = string
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account"
  type        = string
}

variable "cross_tenant_replication_enabled" {
  description = "Defines if cross_tenant_replication should be enabled or not"
  type        = bool
}

variable "change_feed_enabled" {
  description = "Is the blob service properties for change feed events enabled? "
  type        = bool
}

variable "versioning_enabled" {
  description = "Defines if versioning should be enabled or not? "
  type        = bool
}


variable "containers" {
  description = "List of names for the storage containers"
  type        = list(string)
}

variable "private_endpoint_name" {
  description = "Name given for a private endpoint"
  type        = string
}

variable "private_dns_zone_ids" {
  description = "List of Private DNS Zone IDs"
  type        = list(string)
}

variable "subnet_id" {
  description = "ID given for a subnet to use to create private endpoint"
  type        = string
}

variable "public_network_access" {
  description = "Should public network access be possible?"
  type        = bool
}

variable "storageaccount_depends_on" {
  description = "using this variable to propagate dependencies"
  type        = any
  default     = []
}
