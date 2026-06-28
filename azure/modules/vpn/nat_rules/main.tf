data "azurerm_virtual_network_gateway" "default" {
  name                = var.vgw_name
  resource_group_name = var.resource_group_name
}

locals {
  virtual_network_gateway_id = data.azurerm_virtual_network_gateway.default.id
  ip_configuration_id        = data.azurerm_virtual_network_gateway.default.ip_configuration[0].id
}

resource "azurerm_virtual_network_gateway_nat_rule" "egress_snat" {
  name                       = "nat-egress"
  resource_group_name        = var.resource_group_name
  virtual_network_gateway_id = local.virtual_network_gateway_id
  mode                       = "EgressSnat"
  type                       = "Static"
  # ip_configuration_id        = local.ip_configuration_id

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
  virtual_network_gateway_id = local.virtual_network_gateway_id
  mode                       = "IngressSnat"
  type                       = "Static"
  # ip_configuration_id        = local.ip_configuration_id

  external_mapping {
    address_space = var.ingress_nat_external_mapping
  }

  internal_mapping {
    address_space = var.ingress_nat_internal_mapping
  }
}
