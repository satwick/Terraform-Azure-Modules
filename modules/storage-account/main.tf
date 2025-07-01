# ####################
# # Provider section #
# ####################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.98.0"
    }
  }
}

provider "azurerm" {
  features {}
}

#####################
# Resources section #
#####################

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "storage" {

  name                             = var.name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  tags                             = var.tags
  account_tier                     = var.account_tier
  account_kind                     = var.account_kind
  account_replication_type         = var.account_replication_type
  public_network_access_enabled    = var.public_network_access
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  blob_properties {
    versioning_enabled  = var.versioning_enabled
    change_feed_enabled = var.change_feed_enabled
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "POST", "PUT"]
      allowed_origins    = ["*"]
      exposed_headers    = ["content-length"]
      max_age_in_seconds = 200
    }
    delete_retention_policy {
      days = 15
    }
  }
  depends_on = [var.storageaccount_depends_on]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container
resource "azurerm_storage_container" "blob" {
  for_each = toset(var.containers)

  name                  = each.value
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint
resource "azurerm_private_endpoint" "endpoint" {
  name                          = var.private_endpoint_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  tags                          = var.tags
  subnet_id                     = var.subnet_id
  custom_network_interface_name = "${var.private_endpoint_name}-nic"

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  private_service_connection {
    name                           = "${var.private_endpoint_name}psc"
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}
