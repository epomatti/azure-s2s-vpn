resource "azurerm_local_network_gateway" "default" {
  name                = "lgw-${var.workload}"
  resource_group_name = var.resource_group_name
  location            = var.location
  gateway_address     = var.lgw_gateway_address
  address_space       = var.lgw_address_space
}
