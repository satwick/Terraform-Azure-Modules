# Azure Key Vault

## Introduction

This module contains Terraform code to provision and manage an Azure Key Vault. Azure Key Vault is a cloud service for securely managing and protecting sensitive information such as secrets, keys, and certificates.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.73.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.73.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_private_endpoint.endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_key_vault.keyvault] (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy] (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_client_config.current_config] (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Region for deployment | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Key vault name | `string` | n/a | yes |
| <a name="input_sku_name"></a> [name](#input\_name) | sku name | `string` | n/a | yes |
| <a name="input_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#input\_private\_dns\_zone\_ids) | List of Private DNS Zone IDs | `list(string)` | n/a | yes |
| <a name="input_private_endpoint_name"></a> [private\_endpoint\_name](#input\_private\_endpoint\_name) | Name given for a private endpoint | `string` | n/a | yes |
| <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access) | Should public network access be possible? | `bool` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the Resource group | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID given for a subnet to use to create private endpoint | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for resources | `map(string)` | n/a | yes |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days] (#input\_soft\_delete\_retention\_days)  | No of days for retatining the deleted items in keyvault  | `number` | n/a | yes |
| <a name="input_keyvault_network_acls"></a> [keyvault\_network\_acls](#input\_keyvault\_network\_acls) | Object with Key Vault network ACLs, e.g. `{ bypass = "AzureServices", default_action = "Deny", ip_rules = [...], virtual_network_subnet_ids = [...] }` | `object({ bypass = string, default_action = string, ip_rules = list(string), virtual_network_subnet_ids = list(string) })` | n/a | yes |

<!-- END_TF_DOCS -->
