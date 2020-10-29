resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = "ha-api-aks"
  location            = azurerm_resource_group.ha_api_resource_group.location
  resource_group_name = azurerm_resource_group.ha_api_resource_group.name
  dns_prefix          = "ha-api-aks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}
