####################
# Provider section #
####################



provider "azurerm" {
  features {}
}

#####################
# Resources section #
#####################

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server
resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_server_version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  minimum_tls_version          = var.minimum_tls_version
  depends_on                   = [var.sql_depends_on]
}

resource "azurerm_private_endpoint" "private_endpoint" {
  for_each = var.private_endpoint

  name                = each.key
  resource_group_name = azurerm_mssql_server.sql_server.resource_group_name
  location            = azurerm_mssql_server.sql_server.location
  subnet_id           = each.value.subnet_id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.private_dns_zone_ids
  }
  private_service_connection {
    name                           = "${each.key}psc"
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    is_manual_connection           = false
    subresource_names              = ["SQLserver"]
  }
}
