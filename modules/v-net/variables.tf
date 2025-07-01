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

# Virtual Network

variable "name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space to be used for the virtual network"
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Subnets that will be created inside the VNET"
  type = map(object({
    address_prefix                                = list(string)
    service_endpoints                             = list(string)
    private_link_service_network_policies_enabled = bool
    private_endpoint_network_policies_enabled     = bool
    delegation = list(object(
      {
        name    = string
        actions = list(string)
      }
    ))
  }))
}
