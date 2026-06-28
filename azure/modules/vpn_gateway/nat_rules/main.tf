resource "azurerm_virtual_network_gateway_nat_rule" "egress_snat" {
  name                       = "nat-egress"
  resource_group_name        = var.resource_group_name
  virtual_network_gateway_id = var.vgw_id
  mode                       = "EgressSnat"
  type                       = "Static"

  external_mapping {
    address_space = var.egress_nat_external_mapping
  }

  internal_mapping {
    address_space = var.egress_nat_internal_mapping
  }
}

resource "azurerm_virtual_network_gateway_nat_rule" "ingress_snat" {
  name                       = "nat-ingress"
  resource_group_name        = var.resource_group_name
  virtual_network_gateway_id = var.vgw_id
  mode                       = "IngressSnat"
  type                       = "Static"

  external_mapping {
    address_space = var.ingress_nat_external_mapping
  }

  internal_mapping {
    address_space = var.ingress_nat_internal_mapping
  }
}
