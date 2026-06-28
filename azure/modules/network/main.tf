data "azurerm_network_watcher" "default" {
  name                = "NetworkWatcher_${var.location}"
  resource_group_name = "NetworkWatcherRG"
}

locals {
  network_watcher_name                = data.azurerm_network_watcher.default.name
  network_watcher_resource_group_name = data.azurerm_network_watcher.default.resource_group_name
}

module "hub" {
  source              = "./hub"
  workload            = var.workload
  location            = var.location
  resource_group_name = var.resource_group_name
}

module "spoke" {
  source              = "./spoke"
  workload            = var.workload
  location            = var.location
  resource_group_name = var.resource_group_name
}

module "nsg_servers" {
  source                              = "./nsg/servers"
  workload                            = var.workload
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  subnet_id                           = module.spoke.servers_subnet_id
  allowed_admin_public_ips            = var.allowed_admin_public_ips
  vpn_remote_ingress_address_prefixes = var.vpn_remote_ingress_address_prefixes
  vpn_remote_egress_address_prefixes  = var.vpn_remote_egress_address_prefixes
}

module "hub_flow_logs" {
  source                              = "./flow_logs"
  name                                = "hub"
  network_watcher_name                = local.network_watcher_name
  network_watcher_resource_group_name = local.network_watcher_resource_group_name
  location                            = var.location
  vnet_id                             = module.hub.vnet_id
  storage_account_id                  = var.storage_account_id
  log_analytics_workspace_id          = var.log_analytics_workspace_id
  log_analytics_workspace_resource_id = var.log_analytics_id
}

module "spoke_flow_logs" {
  source                              = "./flow_logs"
  name                                = "spoke"
  network_watcher_name                = local.network_watcher_name
  network_watcher_resource_group_name = local.network_watcher_resource_group_name
  location                            = var.location
  vnet_id                             = module.spoke.vnet_id
  storage_account_id                  = var.storage_account_id
  log_analytics_workspace_id          = var.log_analytics_workspace_id
  log_analytics_workspace_resource_id = var.log_analytics_id
}
