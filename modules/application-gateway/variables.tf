# Common

variable "resource_group" {
  description = "The name of the target resource group"
  type        = string
}

variable "environment" {
  description = "Name of the spoke environment being provisioned DEV?INT?PROD"
  type        = string
}

variable "location" {
  description = "Geographic Region resource will be deployed into"
  type        = string
}

# Keyvault

variable "shared_key_vault_name" {
  description = "The name of the shared keyvault"
  type        = string
}

variable "shared_key_vault_resource_group" {
  description = "resource group of the shared keyvault"
  type        = string
}

variable "shared_certificate_name" {
  description = "Name of the certificate for SSL termination "
  type        = string
}

# Azure Application Gateway

variable "name" {
  description = "The name of the AGW"
  type        = string
}

variable "subnet_id" {
  description = "The ID of a Subnet."
  type        = string
}

variable "appgw_private_ip" {
  description = "The Private IP Address to use for the Application Gateway"
  type        = string
}

variable "support_subnet_id" {
  description = "The ID of the support subnet"
  type        = string
}

# Tags

variable "tags" {
  description = "Optional tags to be added to resource"
  type        = map(any)
  default     = {}
}

variable "apgw_depends_on" {
  description = "using this variable to propagate dependencies"
  type        = any
  default     = []
}
