resource "azurerm_virtual_network" "default" {
  name                = "vnet-${var.workload}-spoke"
  address_space       = ["172.16.0.0/12"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "servers" {
  name                 = "servers"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["172.16.100.0/24"]
}
