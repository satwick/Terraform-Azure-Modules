module "aks" {
  source              = "../../"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  name                = "example-aks"
  kubernetes_version  = "1.27.7"
  private_cluster     = false
  subnet_id           = azurerm_subnet.example.id
  adgroup_id          = "00000000-0000-0000-0000-000000000000"

  default_node_pool = {
    name                           = "default"
    node_count                     = 1
    vm_size                        = "Standard_D2_v2"
    max_pods                       = 30
    zones                          = ["1"]
    labels                         = {}
    taints                         = []
    cluster_auto_scaling           = true
    cluster_auto_scaling_min_count = 1
    cluster_auto_scaling_max_count = 3
  }

  additional_node_pools = {}
  addons = {
    azure_policy = true
  }
  tags = {
    Environment = "Example"
  }
}
