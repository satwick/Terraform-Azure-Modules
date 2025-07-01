# VNET

## Introduction

This module is used to create a virtual network and multiple subnets in Microsoft Azure. With the help of this module, it is possible to create a spoke VNET that can be peered with a hub network to establish connectivity to on-premises clients and systems. This definition can be reused for almost every spoke deployment situation.

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
| [azurerm_subnet.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | Address space to be used for the virtual network | `list` | <pre>[<br>  "10.0.0.0/16"<br>]</pre> | no |
| <a name="input_location"></a> [location](#input\_location) | Region for deployment | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the virtual network | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the Resource group | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets that will be created inside the VNET | <pre>map(object({<br>    address_prefix    = list(string)<br>    delegation        = any<br>    service_endpoints = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | An array consisting of all subnets names with their IDs |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | The ID of the deployed VNET |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | The name of the deployed VNET |
<!-- END_TF_DOCS -->
