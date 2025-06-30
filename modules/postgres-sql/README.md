# PostgreSQL Flexible Server

## Introduction

This module is used to create a PostgreSQL Flexible Server 
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
| [azurerm_postgresql_server.psql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Region for deployment | `string` | `"West Europe"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of PostgreSQL Database Flexible Server | `string` | n/a | yes |
| <a name="input_password"></a> [administrator_login](#input\_administrator_login) | The Administrator login for the PostgreSQL Flexible Server.  | `string` | n/a | yes |
| <a name="input_password"></a> [administrator_password](#input\_administrator_password) | The Password associated with the administrator_login for the PostgreSQL Flexible Serve | `string` | n/a | yes |
| <a name="input_version"></a> [\_version](#input\_version) | The version of PostgreSQL Flexible Server to use | `string` | n/a | yes |
| <a name="input_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#input\_private\_dns\_zone\_ids) | List of Private DNS Zone IDs | `list(string)` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the Resource group | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Name of PostgreSQL Database Single Server SKU | `string` | n/a | yes |
| <a name="input_storage_mb"></a> [storage\_mb](#input\_storage\_mb) | Storage of PostgreSQL Database Single Server SKU in MB | `string` | n/a | yes |
| <a name="input_StorageAutogrowth enable"></a> [Storage\_Autogrowth\_ enable](#input\Storage\_Autogrowth\_ enable) |the storage auto grow for PostgreSQL Flexible Server enabled to true | `boolean` | n/a | yes |
| <a name="input_backup_retention_days enable"></a> [backup\_retention\_days\_ enable](#input\backup\_retention\_days) |The backup retention days for the PostgreSQL Flexible Server | `number` | n/a | yes |
| <a name="input_zone enable"></a> [zone](#input\zone) |The Availability Zone in which the PostgreSQL Flexible Server should be located. | `number` | n/a | yes |
| <a name="input_delegated_subnet_id    "></a> [delegated_subnet\_id](#input\_delegated_subnet\_id) |The ID of the virtual network subnet to create the PostgreSQL Flexible Server | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for resources | `map(string)` | n/a | yes |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the deployes PostgreSQL Flexible server |
<!-- END_TF_DOCS -->
