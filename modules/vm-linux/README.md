# Linux Virtual Machine

## Introduction

This module is used to create a Linux Virtual Machine that can be used as a jump host or support VM.

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
| [azurerm_linux_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Region for deployment | `string` | `"West Europe"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of Virtual Machine | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Password for Virtual Machine | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the Resource group | `string` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | SKU of Virtual Machine | `string` | `"Standard_B2s"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of subnet the VM should be connect to | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for resources | `map(string)` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Username for Virtual Machine | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the deployed Linux VM |
<!-- END_TF_DOCS -->
