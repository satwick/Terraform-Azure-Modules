####################
# Provider section #
####################



provider "azurerm" {
  features {}
}

#####################
# Resources section #
#####################

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server
resource "azurerm_postgresql_flexible_server" "psql" {
  name                   = var.name
  location               = var.location
  resource_group_name    = var.resource_group_name
  tags                   = var.tags
  delegated_subnet_id    = var.subnet_id
  private_dns_zone_id    = var.private_dns_zone_id
  administrator_login    = var.username
  administrator_password = var.password
  sku_name               = var.sku_name
  version                = var.db_version
  storage_mb             = var.storage_mb
  auto_grow_enabled      = var.auto_grow_enabled
  backup_retention_days  = var.backup_retention_days
  zone                   = var.zone
  depends_on             = [var.psqlflex_depends_on]
}
