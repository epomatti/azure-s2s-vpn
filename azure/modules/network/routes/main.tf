resource "azurerm_route_table" "default" {
  name                          = "rt-${var.workload}-gateway"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true
}

resource "azurerm_route" "gateway" {
  name                = "gateway"
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.default.name
  address_prefix      = var.remote_address_prefix
  next_hop_type       = "VirtualNetworkGateway"
}

resource "azurerm_subnet_route_table_association" "servers" {
  subnet_id      = var.servers_subnet_id
  route_table_id = azurerm_route_table.default.id
}

# TODO: Delete if not needed.
# resource "azurerm_subnet_route_table_association" "gateway" {
#   subnet_id      = var.gateway_subnet_id
#   route_table_id = azurerm_route_table.default.id
# }
