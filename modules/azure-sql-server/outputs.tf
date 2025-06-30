output "server_name" {
  description = "The name of the SQL Server"
  value       = azurerm_mssql_server.sql_server.name
}

output "id" {
  description = "ID of the SQL server"
  value       = azurerm_mssql_server.sql_server.id
}
