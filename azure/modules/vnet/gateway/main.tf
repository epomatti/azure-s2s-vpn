resource "azurerm_virtual_network" "default" {
  name                = "vnet-${var.workload}-gateway"
  address_space       = ["${var.vnet_cidr_prefix}.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["${var.vnet_cidr_prefix}.10.0/27"]
}
