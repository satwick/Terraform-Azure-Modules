output "fqdn" {
  description = "FQDN of deployed Azure Kubernetes Service"
  value       = azurerm_kubernetes_cluster.aks.fqdn
}

output "name" {
  description = "Name of deployed Azure Kubernetes Service"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "id" {
  description = "ID of deployed Azure Kubernetes Service"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "mi_principal_id" {
  description = "ID of Managed Identity of deployed Azure Kubernetes Service"
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

output "mi_tenant_id" {
  description = "Tenant ID of deployed Azure Kubernetes Service"
  value       = azurerm_kubernetes_cluster.aks.identity[0].tenant_id
}

output "kubelet_client_id" {
  description = "Client ID of Kubelet of deployed Azure Kubernetes Service"
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].client_id
}

output "kubelet_object_id" {
  description = "Object ID of Kubelet of deployed Azure Kubernetes Service"
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

output "kubelet_user_assigned_identity_id" {
  description = "ID User Assigned Identity of deployed Azure Kubernetes Service"
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].user_assigned_identity_id
}

output "kube_config" {
  description = "Kubeconfig for deployed Azure Kubernetes Service"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "ingress_application_gateway_identity_object_id" {
  description = "ID of Managed Identity that is used for Azure Application Gateway by deployed Azure Kubernetes Service"
  value       = length(azurerm_kubernetes_cluster.aks.ingress_application_gateway) > 0 ? azurerm_kubernetes_cluster.aks.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id : null
}

output "node_resource_group_name" {
  description = "Name of deployed Azure Kubernetes Service Node Resource Group"
  value       = data.azurerm_resource_group.node_rg.name
}
