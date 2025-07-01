output "storage_account_name" {
  description = "The name of the deployed storage account"
  value       = azurerm_storage_account.storage.name
}

output "storage_containers" {
  description = "An array consisting of all storage container names with their IDs"
  value       = { for k, v in azurerm_storage_container.blob : k => v }
}

output "access_key" {
  description = "The primary access key to access the storage through the unique URL"
  value       = azurerm_storage_account.storage.primary_access_key
}

output "primary_blob_endpoint" {
  description = "The primary access point or URL for interacting with a Blob Storage service"
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}

output "id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.storage.id
}
