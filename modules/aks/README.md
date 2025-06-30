# Azure Kubernetes Service

## Introduction

This module is used to create an Azure Kubernetes Service that integrates itself into a virtual network and is used to host container application.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.98.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.98.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_user_assigned_identity.dflbuscontrolplane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_role_assignment.aks_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.agw_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.dflbuscontrolplane_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_resource_group.node_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_node_pools"></a> [additional\_node\_pools](#input\_additional\_node\_pools) | Defines additional node pools that are added besides the default node pool. | <pre>map(object({<br>    node_count                     = number<br>    node_os                        = string<br>    vm_size                        = string<br>    max_pods                       = number<br>    zones                          = list(string)<br>    labels                         = map(string)<br>    taints                         = list(string)<br>    cluster_auto_scaling           = bool<br>    cluster_auto_scaling_min_count = number<br>    cluster_auto_scaling_max_count = number<br>  }))</pre> | n/a | yes |
| <a name="input_addons"></a> [addons](#input\_addons) | Defines which addons will be activated. | <pre>object({<br>    azure_policy = bool<br>  })</pre> | n/a | yes |
| <a name="input_adgroup_id"></a> [adgroup\_id](#input\_adgroup\_id) | The id of the Azure AD group for admins | `string` | n/a | yes |
| <a name="input_agw_id"></a> [agw\_id](#input\_agw\_id) | The ID of the AGW | `string` | `null` | no |
| <a name="input_default_node_pool"></a> [default\_node\_pool](#input\_default\_node\_pool) | Defines the default node pool information. | <pre>object({<br>    name                           = string<br>    node_count                     = number<br>    vm_size                        = string<br>    max_pods                       = number<br>    zones                          = list(string)<br>    labels                         = map(string)<br>    taints                         = list(string)<br>    cluster_auto_scaling           = bool<br>    cluster_auto_scaling_min_count = number<br>    cluster_auto_scaling_max_count = number<br>  })</pre> | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Version of of Azure Kubernetes Service cluster | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Region for deployment | `string` | `"West Europe"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of Azure Kubernetes Service | `string` | n/a | yes |
| <a name="input_private_cluster"></a> [private\_cluster](#input\_private\_cluster) | Version of of Azure Kubernetes Service cluster | `bool` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the Resource group | `string` | n/a | yes |
| <a name="input_sla_sku"></a> [sla\_sku](#input\_sla\_sku) | SKU of Azure Kubernetes Service cluster | `string` | `"Standard"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the AKS cluster subnet | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for resources | `map(string)` | n/a | yes |

## Ignore_changes

| Resource                         | Attribute         | Description                                       | Ignored |
|----------------------------------|------------------|---------------------------------------------------|---------|
| `azurerm_kubernetes_cluster`    | `oms_agent`      | Configuration block for Azure Monitor (OMS Agent) | ✅ Yes  |
| `azurerm_kubernetes_cluster`    | `oms_agent.log_analytics_workspace_id` | Specifies the Log Analytics Workspace ID for monitoring | ✅ Yes  |
| `azurerm_kubernetes_cluster`    | `oms_agent.msi_auth_for_monitoring_enabled` | Is managed identity authentication for monitoring enabled? | ✅ Yes  |
| `azurerm_kubernetes_cluster`    | `oms_agent.oms_agent_identity` |oms_agent_identity | ✅ Yes  |



## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | Client certificate of deployed Azure Kubernetes Service |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | Client key of deployed Azure Kubernetes Service |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | Cluster CA certificate of deployed Azure Kubernetes Service |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | FQDN of deployed Azure Kubernetes Service |
| <a name="output_host"></a> [host](#output\_host) | Host of deployed Azure Kubernetes Service |
| <a name="output_id"></a> [id](#output\_id) | ID of deployed Azure Kubernetes Service |
| <a name="output_ingress_application_gateway_identity_object_id"></a> [ingress\_application\_gateway\_identity\_object\_id](#output\_ingress\_application\_gateway\_identity\_object\_id) | ID of Managed Identity that is used for Azure Application Gateway by deployed Azure Kubernetes Service |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | Kubeconfig for deployed Azure Kubernetes Service |
| <a name="output_kubelet_client_id"></a> [kubelet\_client\_id](#output\_kubelet\_client\_id) | Client ID of Kubelet of deployed Azure Kubernetes Service |
| <a name="output_kubelet_object_id"></a> [kubelet\_object\_id](#output\_kubelet\_object\_id) | Object ID of Kubelet of deployed Azure Kubernetes Service |
| <a name="output_kubelet_user_assigned_identity_id"></a> [kubelet\_user\_assigned\_identity\_id](#output\_kubelet\_user\_assigned\_identity\_id) | ID User Assigned Identity of deployed Azure Kubernetes Service |
| <a name="output_mi_principal_id"></a> [mi\_principal\_id](#output\_mi\_principal\_id) | ID of Managed Identity of deployed Azure Kubernetes Service |
| <a name="output_mi_tenant_id"></a> [mi\_tenant\_id](#output\_mi\_tenant\_id) | Tenant ID of deployed Azure Kubernetes Service |
| <a name="output_name"></a> [name](#output\_name) | Name of deployed Azure Kubernetes Service |
| <a name="output_node_resource_group_name"></a> [node\_resource\_group\_name](#output\_node\_resource\_group\_name) | Name of deployed Azure Kubernetes Service Node Resource Group |
| <a name="output_token"></a> [token](#output\_token) | Password for deployed Azure Kubernetes Service |
<!-- END_TF_DOCS -->
