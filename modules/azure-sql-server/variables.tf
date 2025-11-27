# Common

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

# Sql Server

variable "sql_server_name" {
  description = "Name of the Azure SQL Server"
  type        = string
}

variable "sql_server_version" {
  description = "SQL Server version"
  type        = string
  default     = "12.0"
}

variable "administrator_login" {
  description = "SQL Server administrator login"
  type        = string
  sensitive   = true
}

variable "administrator_login_password" {
  description = "SQL Server administrator login password"
  type        = string
  sensitive   = true
}

variable "minimum_tls_version" {
  description = "minimum_tls_version"
  type        = string
  default     = "1.2"
}

variable "sql_depends_on" {
  description = "using this variable to propagate dependencies"
  type        = any
  default     = []
}

variable "private_endpoint" {
  description = "Private-endpoint creation"
  type = map(object({
    subnet_id = string
  }))
}

variable "private_dns_zone_ids" {
  description = "List of Private DNS Zone IDs"
  type        = list(string)
}
