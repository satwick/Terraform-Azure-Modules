output "route_table_id" {
  description = "The ID of the deployed route table"
  value       = azurerm_route_table.table.id
}
