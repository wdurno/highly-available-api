resource "azurerm_resource_group" "ha_api_resource_group" {
  name     = var.resource_group_name
  location = "East US"
}
