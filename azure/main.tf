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
  source                          = "./modules/network"
  workload                        = var.workload
  resource_group_name             = module.resource_groups.network
  location                        = var.location
  vnet_address_space              = var.vnet_address_space
  gateway_subnet_address_prefixes = var.vnet_gateway_subnet_address_prefixes
  servers_subnet_address_prefixes = var.vnet_servers_subnet_address_prefixes
  vpn_remote_address_prefixes     = var.vnet_vpn_remote_address_prefixes
  allowed_admin_public_ips        = var.allowed_admin_public_ips

  # Flow Logs
  storage_account_id         = module.storage_troubleshoot.storage_account_id
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  log_analytics_id           = module.monitoring.log_analytics_id
}

### VPN Gateway ###
module "gateway" {
  source               = "./modules/vpn/gateway"
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
  source                = "./modules/network/routes"
  workload              = var.workload
  resource_group_name   = module.resource_groups.network
  location              = var.location
  servers_subnet_id     = module.network.servers_subnet_id
  remote_address_prefix = var.vnet_vpn_remote_address_prefixes[0]

  depends_on = [
    module.gateway
  ]
}

module "gateway_nat_rules" {
  source                       = "./modules/vpn/nat_rules"
  workload                     = var.workload
  resource_group_name          = module.resource_groups.network
  location                     = var.location
  vgw_id                       = module.gateway.vgw_id
  ingress_nat_external_mapping = var.vgw_ingress_nat_external_mapping
  ingress_nat_internal_mapping = var.vgw_ingress_nat_internal_mapping
  egress_nat_external_mapping  = var.vgw_egress_nat_external_mapping
  egress_nat_internal_mapping  = var.vgw_egress_nat_internal_mapping

  depends_on = [
    module.gateway
  ]
}

module "local_network_gateway" {
  source              = "./modules/vpn/local_network_gateway"
  workload            = var.workload
  resource_group_name = module.resource_groups.network
  location            = var.location
  lgw_gateway_address = var.lgw_gateway_address
  lgw_address_space   = var.lgw_address_space
}

# module "vpn_connection" {
#   source                     = "./modules/vpn/connection"
#   workload                   = var.workload
#   resource_group_name        = module.resource_groups.network
#   location                   = var.location
#   virtual_network_gateway_id = module.gateway.vgw_id
#   lgw_gateway_address        = var.lgw_gateway_address
#   lgw_address_space          = var.lgw_address_space
#   shared_key                 = var.vcn_shared_key
#   bgp_enabled                = var.vcn_bgp_enabled
# }

# module "linux_server" {
#   source              = "./modules/virtual_machines/linux_server"
#   location            = var.location
#   resource_group_name = module.resource_groups.servers
#   workload            = var.workload
#   subnet_id           = module.vnet.servers_subnet_id
#   zone                = local.primary_zone
# }
