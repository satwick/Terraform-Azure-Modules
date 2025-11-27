output "vnet_id" {
  description = "The ID of the deployed VNET"
  value       = module.vnet.vnet_id
}

output "vnet_name" {
  description = "The name of the deployed VNET"
  value       = module.vnet.vnet_name
}
