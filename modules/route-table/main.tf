####################
# Provider section #
####################



provider "azurerm" {
  features {}
}

#####################
# Resources section #
#####################

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table
resource "azurerm_route_table" "table" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tags                          = var.tags
  disable_bgp_route_propagation = var.disable_bgp_route_propagation

  dynamic "route" {
    for_each = var.route_table_routes
    content {
      name                   = route.value["name"]
      address_prefix         = route.value["address_prefix"]
      next_hop_type          = route.value["next_hop_type"]
      next_hop_in_ip_address = route.value["next_hop_in_ip_address"]
    }
  }
}
