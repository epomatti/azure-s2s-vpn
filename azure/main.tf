terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

locals {
  zones        = [1, 2, 3]
  primary_zone = local.zones[0]

  # Remote NAT Address Prefixes
  remote_nat_ingress_cidr             = "192.168.100.0/24"
  remote_nat_egress_cidr              = "192.168.200.0/24"
  remote_nat_ingress_address_prefixes = [local.remote_nat_ingress_cidr]
  remote_nat_egress_address_prefixes  = [local.remote_nat_egress_cidr]
}

module "resource_groups" {
  source   = "./modules/resource_groups"
  workload = var.workload
  location = var.location
}

module "monitoring" {
  source              = "./modules/monitoring"
  workload            = var.workload
  resource_group_name = module.resource_groups.troubleshoot
  location            = var.location
}

module "storage_troubleshoot" {
  source              = "./modules/storage"
  location            = var.location
  resource_group_name = module.resource_groups.troubleshoot
}

module "network" {
  source                              = "./modules/network"
  workload                            = var.workload
  resource_group_name                 = module.resource_groups.network
  location                            = var.location
  vpn_remote_ingress_address_prefixes = local.remote_nat_ingress_address_prefixes
  vpn_remote_egress_address_prefixes  = local.remote_nat_egress_address_prefixes
  allowed_admin_public_ips            = var.allowed_admin_public_ips

  # Flow Logs
  storage_account_id         = module.storage_troubleshoot.storage_account_id
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  log_analytics_id           = module.monitoring.log_analytics_id
}

### VPN Gateway ###
module "gateway" {
  source               = "./modules/vpn_gateway/gateway"
  workload             = var.workload
  resource_group_name  = module.resource_groups.network
  location             = var.location
  zones                = local.zones
  gateway_subnet_id    = module.network.gateway_subnet_id
  vgw_vpn_type         = var.vgw_vpn_type
  vgw_active_active    = var.vgw_active_active
  vgw_bgp_enabled      = var.vgw_bgp_enabled
  vgw_bgp_settings_asn = var.vgw_bgp_settings_asn
  vgw_sku              = var.vgw_sku
  vgw_generation       = var.vgw_generation

  vgw_bgp_route_translation_for_nat_enabled = var.vgw_bgp_route_translation_for_nat_enabled

  depends_on = [
    module.network
  ]
}

module "routes" {
  source                  = "./modules/network/routes"
  workload                = var.workload
  resource_group_name     = module.resource_groups.network
  location                = var.location
  servers_subnet_id       = module.network.servers_subnet_id
  remote_nat_ingress_cidr = local.remote_nat_ingress_cidr

  depends_on = [
    module.gateway
  ]
}

module "gateway_nat_rules" {
  source                       = "./modules/vpn_gateway/nat_rules"
  workload                     = var.workload
  resource_group_name          = module.resource_groups.network
  location                     = var.location
  vgw_id                       = module.gateway.vgw_id
  ingress_nat_external_mapping = local.remote_nat_ingress_cidr
  ingress_nat_internal_mapping = var.remote_network_cidr
  egress_nat_external_mapping  = local.remote_nat_egress_cidr
  egress_nat_internal_mapping  = module.network.servers_subnet_address_prefixes[0]

  depends_on = [
    module.gateway
  ]
}

module "local_network_gateway" {
  count               = var.lgw_create ? 1 : 0
  source              = "./modules/vpn_gateway/local_network_gateway"
  workload            = var.workload
  resource_group_name = module.resource_groups.network
  location            = var.location
  lgw_gateway_address = var.lgw_gateway_address
  lgw_address_space   = var.lgw_address_space
}

module "vpn_connection" {
  count                      = var.vcn_create ? 1 : 0
  source                     = "./modules/vpn_gateway/connection"
  workload                   = var.workload
  resource_group_name        = module.resource_groups.network
  location                   = var.location
  virtual_network_gateway_id = module.gateway.vgw_id
  shared_key                 = var.vcn_shared_key
  bgp_enabled                = var.vcn_bgp_enabled
  local_network_gateway_id   = module.local_network_gateway[0].local_network_gateway_id
  egress_nat_rule_ids        = module.gateway_nat_rules.egress_nat_rules
  ingress_nat_rule_ids       = module.gateway_nat_rules.ingress_nat_rules
}

module "diagnostic_settings" {
  source                     = "./modules/diagnostic_settings"
  log_analytics_workspace_id = module.monitoring.log_analytics_id
  vgw_id                     = module.gateway.vgw_id
}

module "linux_server" {
  source              = "./modules/virtual_machines/linux_server"
  location            = var.location
  resource_group_name = module.resource_groups.servers
  workload            = var.workload
  subnet_id           = module.network.servers_subnet_id
  zone                = local.primary_zone
}
