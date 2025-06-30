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

# Route Table

variable "name" {
  description = "Name of Azure Kubernetes Service"
  type        = string
}

variable "disable_bgp_route_propagation" {
  type        = bool
  description = "Enable/disable bgp route propagation"
  default     = false
}

variable "route_table_routes" {
  type        = map(any)
  description = "The list of route definitions applied to the custom route table."
  default     = null
}
