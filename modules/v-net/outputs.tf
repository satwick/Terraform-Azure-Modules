output "vnet_id" {
  description = "The ID of the deployed VNET"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The name of the deployed VNET"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_ids" {
  description = "An array consisting of all subnets names with their IDs"
  value = {
    for key, subnet in azurerm_subnet.subnets : key => subnet.id
  }
}
