resource "azurerm_virtual_network_gateway_connection" "default" {
  name                = "vcn-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name

  type                = "IPsec"
  connection_protocol = "IKEv2"
  enable_bgp          = false

  virtual_network_gateway_id = var.vpn_gateway_id
  local_network_gateway_id   = var.local_network_gateway_id

  shared_key = var.shared_key
}
