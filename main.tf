provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks_rg" {
  name     = "myAKSResourceGroup"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "myAKSCluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myAKSDns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
    enable_auto_scaling = true
    min_count = 1
    max_count = 3
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "Production"
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw

  sensitive = true
}
