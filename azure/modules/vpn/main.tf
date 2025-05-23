data "azurerm_client_config" "current" {
}

locals {
  current_tenant_id = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_public_ip" "main" {
  name                = "pip-${var.workload}-vgw"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "main" {
  name                = "vgw-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = var.vgw_vpn_type

  active_active = var.vgw_active_active
  enable_bgp    = var.vgw_enable_bgp

  sku        = var.vgw_sku
  generation = var.vgw_generation

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.main.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gateway_subnet_id
  }

  vpn_client_configuration {
    address_space = var.p2s_vnet_cidr_blocks
    aad_tenant    = "https://login.microsoftonline.com/${local.current_tenant_id}/"
    aad_audience  = "c632b3df-fb67-4d84-bdcf-b95ad541b5c8" # Microsoft-registered
    aad_issuer    = "https://sts.windows.net/${local.current_tenant_id}/"
  }

  custom_route {
    address_prefixes = []
  }
}

resource "azurerm_local_network_gateway" "default" {
  count               = var.create_gateway_connection == true ? 1 : 0
  name                = "lgw-${var.workload}"
  resource_group_name = var.resource_group_name
  location            = var.location
  gateway_address     = var.lgw_gateway_address
  address_space       = var.lgw_address_space
}

resource "azurerm_virtual_network_gateway_connection" "default" {
  count               = var.create_gateway_connection == true ? 1 : 0
  name                = "vcn-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name

  type                = "IPsec"
  connection_protocol = "IKEv2"
  enable_bgp          = false # TODO: Check for P2s

  virtual_network_gateway_id = azurerm_virtual_network_gateway.main.id
  local_network_gateway_id   = azurerm_local_network_gateway.default[0].id

  shared_key = var.shared_key

  # ipsec_policy {
  #   dh_group       = "DHGroup14"
  #   ike_encryption = "GCMAES256"
  #   ike_integrity = "SHA256"
  #   ipsec_encryption = ""
  # }
}
