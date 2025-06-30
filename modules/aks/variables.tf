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

# Managed Identity
variable "Managedidentity_name" {
  description = "Name of Managed Identity"
  type        = string
}

# Azure Kubernetes Service

variable "name" {
  description = "Name of Azure Kubernetes Service"
  type        = string
}

variable "kubernetes_version" {
  description = "Version of of Azure Kubernetes Service cluster"
  type        = string
}

variable "azure_ad_rbac_enabled" {
  description = "RBAC enabled "
  type        = bool
}

variable "subnet_id" {
  description = "The ID of the AKS cluster subnet"
  type        = string
}

variable "private_cluster" {
  description = "Version of of Azure Kubernetes Service cluster"
  type        = bool
}

variable "sla_sku" {
  description = "SKU of Azure Kubernetes Service cluster"
  type        = string
  default     = "Standard"
}

variable "default_node_pool" {
  description = "Defines the default node pool information."
  type = object({
    name                           = string
    node_count                     = number
    vm_size                        = string
    max_pods                       = number
    zones                          = list(string)
    labels                         = map(string)
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
  })
}

variable "additional_node_pools" {
  description = "Defines additional node pools that are added besides the default node pool."
  type = map(object({
    name                           = string
    node_count                     = number
    vm_size                        = string
    max_pods                       = number
    zones                          = list(string)
    labels                         = map(string)
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
  }))
}

variable "addons" {
  description = "Defines which addons will be activated."
  type = object({
    azure_policy = bool
  })
}

variable "agw_id" {
  description = "The ID of the AGW"
  type        = string
  default     = null
}

variable "aks_depends_on" {
  description = "using this variable to propagate dependencies"
  type        = any
  default     = []
}
