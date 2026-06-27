resource "azurerm_virtual_network" "default" {
  name                = "vnet-${var.workload}"
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = var.gateway_subnet_address_prefixes
}

resource "azurerm_subnet" "servers" {
  name                 = "servers"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = var.servers_subnet_address_prefixes
}

module "nsg_servers" {
  source                      = "./nsg/servers"
  workload                    = var.workload
  location                    = var.location
  resource_group_name         = var.resource_group_name
  subnet_id                   = azurerm_subnet.servers.id
  allowed_admin_public_ips    = var.allowed_admin_public_ips
  vpn_remote_address_prefixes = var.vpn_remote_address_prefixes
}

module "flow_logs" {
  source                              = "./flow_logs"
  location                            = var.location
  vnet_id                             = azurerm_virtual_network.default.id
  storage_account_id                  = var.storage_account_id
  log_analytics_workspace_id          = var.log_analytics_workspace_id
  log_analytics_workspace_resource_id = var.log_analytics_id
}
