output "id" {
  description = "ID of deployed Azure Application Gateway"
  value       = azurerm_application_gateway.agw.id
}

output "name" {
  description = "Name of deployed Azure Application Gateway"
  value       = azurerm_application_gateway.agw.name
}
