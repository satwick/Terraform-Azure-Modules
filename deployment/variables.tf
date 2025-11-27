variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "example-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "vnet_name" {
  description = "Name of the VNet"
  type        = string
  default     = "example-vnet"
}

variable "vnet_address_space" {
  description = "Address space for VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {
    Environment = "Dev"
    Project     = "Portfolio"
  }
}
