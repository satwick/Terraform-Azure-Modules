provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "vnet" {
  source = "../modules/v-net"

  name                = var.vnet_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = var.vnet_address_space
  tags                = var.tags

  subnets = {
    subnet1 = {
      address_prefix                                = ["10.0.1.0/24"]
      private_link_service_network_policies_enabled = true
      private_endpoint_network_policies_enabled     = true
      service_endpoints                             = []
      delegation                                    = []
    }
  }
}
