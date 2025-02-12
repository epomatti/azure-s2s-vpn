resource "azurerm_virtual_network_peering" "gateway_to_workloads" {
  name                      = "peer-gateway-to-workloads"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.gateway_vnet_name
  remote_virtual_network_id = var.workloads_vnet_id
}

resource "azurerm_virtual_network_peering" "workloads_to_gateway" {
  name                      = "peer-workloads-to-gateway"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.workloads_vnet_name
  remote_virtual_network_id = var.gateway_vnet_id
}
