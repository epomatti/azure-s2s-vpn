locals {
  name = "vgw-${var.workload}"
}

resource "azurerm_public_ip" "gateway_001" {
  name                = "pip-${local.name}-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"
  zones               = var.zones
  ip_version          = "IPv4"
}

resource "azurerm_virtual_network_gateway" "main" {
  name                = local.name
  location            = var.location
  resource_group_name = var.resource_group_name

  type                                  = "Vpn"
  vpn_type                              = var.vgw_vpn_type
  active_active                         = var.vgw_active_active
  bgp_enabled                           = var.vgw_bgp_enabled
  sku                                   = var.vgw_sku
  generation                            = var.vgw_generation
  bgp_route_translation_for_nat_enabled = var.vgw_bgp_route_translation_for_nat_enabled

  bgp_settings {
    asn = var.vgw_bgp_settings_asn
  }

  ip_configuration {
    name                          = "vnetGatewayConfig001"
    public_ip_address_id          = azurerm_public_ip.gateway_001.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gateway_subnet_id
  }

  # custom_route {
  #   address_prefixes = []
  # }

  timeouts {
    create = "2h"
    update = "2h"
    delete = "2h"
  }
}
