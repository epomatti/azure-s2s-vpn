data "azurerm_virtual_network_gateway" "default" {
  name                = var.vgw_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network_gateway_nat_rule" "remote_gateway" {
  name                       = "remote"
  resource_group_name        = var.resource_group_name
  virtual_network_gateway_id = data.azurerm_virtual_network_gateway.default.id
  mode                       = "EgressSnat"
  type                       = "Static"
  ip_configuration_id        = data.azurerm_virtual_network_gateway.default.ip_configuration[0].id

  external_mapping {
    address_space = var.nat_external_mapping
  }

  internal_mapping {
    address_space = var.nat_internal_mapping
  }
}
