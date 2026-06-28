resource "azurerm_route_table" "spoke" {
  name                          = "rt-${var.workload}-spoke"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true
}

resource "azurerm_route" "servers_to_gateway" {
  name                = "servers-to-gateway"
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.spoke.name
  address_prefix      = var.remote_egress_cidr
  next_hop_type       = "VirtualNetworkGateway"
}

resource "azurerm_subnet_route_table_association" "spoke_servers" {
  subnet_id      = var.servers_subnet_id
  route_table_id = azurerm_route_table.spoke.id
}
