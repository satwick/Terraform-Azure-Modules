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

# Virtual Machine

variable "subnet_id" {
  description = "ID of subnet the VM should be connect to"
  type        = string
}

variable "name" {
  description = "Name of Virtual Machine"
  type        = string
}

variable "size" {
  description = "SKU of Virtual Machine"
  type        = string
  default     = "Standard_B2s"
}

variable "username" {
  description = "Username for Virtual Machine"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Password for Virtual Machine"
  type        = string
  sensitive   = true
}

variable "vmwindows_depends_on" {
  description = "using this variable to propagate dependencies"
  type    = any
  default = []
}
