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

# PostgreFLEX

variable "name" {
  description = "Name of the PostgreSQL Database Flexible Server"
  type        = string
}

variable "username" {
  description = "Name of the PostgreSQL Database Flexible Server user"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Password of the PostgreSQL Database Flexible Server user"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "Name of PostgreSQL Database Flexible Server SKU"
  type        = string
}

variable "db_version" {
  description = "Version of PostgreSQL DatabaseFlexible Server"
  type        = string
}

variable "storage_mb" {
  description = "Storage of PostgreSQL Database Single Flexible SKU in MB"
  type        = number
}

variable "auto_grow_enabled" {
  description = "the storage auto grow for PostgreSQL Flexible Server enabled to true"
  type        = bool
  default     = true
}

variable "backup_retention_days" {
  description = "The backup retention days for the PostgreSQL Flexible Server"
  type        = number
}

variable "subnet_id" {
  description = "ID given for a subnet to use"
  type        = string
}

variable "private_dns_zone_id" {
  description = "List of Private DNS Zone ID"
  type        = string
}

variable "zone" {
  description = "The Availability Zone in which the PostgreSQL Flexible Server should be located"
  type        = number
}

variable "psqlflex_depends_on" {
  description = "using this variable to propagate dependencies"
  type    = any
  default = []
}
