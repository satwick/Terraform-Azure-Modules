# Storage Account

## Introduction

This module is used to create a storage account with multiple containers (blobs) and integrates a Private Endpoint for accessing the storage container from a private network. A switch variable is present, which determines whether the storage account can be accessed from the internet. This switch is implemented because not every workstation used in the development process has access to the internal network. To facilitate development and refinement of the definitions, you can simply activate public access. However, when deploying to production, it is recommended to set this switch to false to disable public access completely.

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
| [azurerm_private_endpoint.endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_storage_account.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | public network access is enabled | `string` | n/a | yes |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | public network access is enabled | `string` | n/a | yes |
| <a name="input_containers"></a> [containers](#input\_containers) | List of names for the storage containers | `list(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Region for deployment | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Storage account name | `string` | n/a | yes |
| <a name="input_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#input\_private\_dns\_zone\_ids) | List of Private DNS Zone IDs | `list(string)` | n/a | yes |
| <a name="input_private_endpoint_name"></a> [private\_endpoint\_name](#input\_private\_endpoint\_name) | Name given for a private endpoint | `string` | n/a | yes |
| <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access) | Should public network access be possible? | `bool` | n/a | yes |
| <a name="input_cross_tenant_replication_enabled"></a> [cross\_tenant\_replication\_enabled](#input\_cross\_tenant\_replication\_enabled) | Should cross_tenant_replication_enabled be possible? | `bool` | yes| n/a |
| <a name="input_change_feed_enabled"></a> [change\_feed\_enabled](#input\_change\_feed\_enabled) | Should change_feed_enabled be possible? | `bool` | yes | n/a |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Should versioning_enabled be possible? | `bool` | yes| n/a |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the Resource group | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID given for a subnet to use to create private endpoint | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for resources | `map(string)` | n/a | yes |

## CORS Configuration

| Setting          | Value              |
|-----------------|------------------|
| Allowed Headers | `[*]`             |
| Allowed Methods | `GET`, `POST`, `PUT` |
| Allowed origins | `[*]` |
| exposed_headers | `Content-length` |
| max_age_in_seconds | 200 |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key"></a> [access\_key](#output\_access\_key) | The primary access key to access the storage through the unique URL |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | The name of the deployed storage account |
| <a name="output_storage_containers"></a> [storage\_containers](#output\_storage\_containers) | An array consisting of all storage container names with their IDs |
<!-- END_TF_DOCS -->
