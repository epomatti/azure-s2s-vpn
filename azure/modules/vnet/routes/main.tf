locals {
  p2s_cidr_list = tolist(var.p2s_cidr)
}

resource "azurerm_route_table" "default" {
  name                          = "rt-${var.workload}-vpn"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true
}

resource "azurerm_route" "gateway" {
  name                = "vgw"
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.default.name
  address_prefix      = var.remote_cidr
  next_hop_type       = "VirtualNetworkGateway"
}

resource "azurerm_route" "p2s" {
  count               = length(local.p2s_cidr_list)
  name                = "p2s-${count.index}"
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.default.name
  address_prefix      = local.p2s_cidr_list[count.index]
  next_hop_type       = "VirtualNetworkGateway"
}

resource "azurerm_subnet_route_table_association" "workload" {
  subnet_id      = var.workload_subnet_id
  route_table_id = azurerm_route_table.default.id
}

resource "azurerm_subnet_route_table_association" "gateway" {
  subnet_id      = var.gateway_subnet_id
  route_table_id = azurerm_route_table.default.id
}
