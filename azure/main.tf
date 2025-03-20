terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

resource "azurerm_resource_group" "vpn" {
  name     = "rg-${var.workload}-vpn"
  location = var.location
}

resource "azurerm_resource_group" "workload" {
  name     = "rg-${var.workload}-workload"
  location = var.location
}

resource "azurerm_resource_group" "tshoot" {
  name     = "rg-${var.workload}-tshoot"
  location = var.location
}

resource "azurerm_resource_group" "network" {
  name     = "rg-${var.workload}-network"
  location = var.location
}

resource "azurerm_log_analytics_workspace" "default" {
  name                = "log-${var.workload}"
  location            = azurerm_resource_group.tshoot.location
  resource_group_name = azurerm_resource_group.tshoot.name
  sku                 = "PerGB2018"
}

# module "vnet_gateway" {
#   source              = "./modules/vnet/gateway"
#   workload            = var.workload
#   resource_group_name = azurerm_resource_group.vpn.name
#   location            = var.location
#   vnet_cidr_prefix    = var.vnet_gateway_cidr_prefix
# }

# module "vnet_workloads" {
#   source              = "./modules/vnet/workloads"
#   workload            = var.workload
#   resource_group_name = azurerm_resource_group.network.name
#   location            = var.location
#   vnet_cidr_prefix    = var.vnet_workloads_cidr_prefix
#   allowed_public_ips  = var.allowed_public_ips
# }

# module "vnet_peerings" {
#   source              = "./modules/vnet/peerings"
#   resource_group_name = azurerm_resource_group.network.name
#   gateway_vnet_id     = module.vnet_gateway.vnet_id
#   gateway_vnet_name   = module.vnet_gateway.vnet_name
#   workloads_vnet_id   = module.vnet_workloads.vnet_id
#   workloads_vnet_name = module.vnet_workloads.vnet_name
# }

module "vnet" {
  source              = "./modules/vnet/default"
  workload            = var.workload
  resource_group_name = azurerm_resource_group.vpn.name
  location            = var.location
  vnet_cidr_prefix    = var.vnet_gateway_cidr_prefix
  allowed_public_ips  = var.allowed_public_ips
}

module "routes" {
  source              = "./modules/vnet/routes"
  workload            = var.workload
  resource_group_name = azurerm_resource_group.network.name
  location            = var.location
  remote_cidr         = var.lgw_address_space[0]
  workload_subnet_id  = module.vnet.workloads_subnet_id
  gateway_subnet_id   = module.vnet.gateway_subnet_id
}

module "vpn" {
  source              = "./modules/vpn"
  workload            = var.workload
  resource_group_name = azurerm_resource_group.vpn.name
  location            = var.location

  # VGW
  gateway_subnet_id = module.vnet.gateway_subnet_id
  vgw_vpn_type      = var.vgw_vpn_type
  vgw_active_active = var.vgw_active_active
  vgw_enable_bgp    = var.vgw_enable_bgp
  vgw_sku           = var.vgw_sku
  vgw_generation    = var.vgw_generation

  # LGW
  lgw_gateway_address = var.lgw_gateway_address
  lgw_address_space   = var.lgw_address_space

  # VCN
  shared_key = var.vcn_shared_key

  create_gateway_connection = var.create_gateway_connection
}

module "virtual_machine" {
  source              = "./modules/vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.workload.name
  workload            = var.workload
  vm_public_key_path  = var.vm_public_key_path
  vm_admin_username   = var.vm_admin_username
  vm_size             = var.vm_size
  subnet_id           = module.vnet.workloads_subnet_id

  vm_image_publisher = var.vm_image_publisher
  vm_image_offer     = var.vm_image_offer
  vm_image_sku       = var.vm_image_sku
  vm_image_version   = var.vm_image_version
}

module "storage_tshoot" {
  source              = "./modules/storage"
  location            = var.location
  resource_group_name = azurerm_resource_group.tshoot.name
}

module "flow_logs" {
  source                              = "./modules/flowlogs"
  location                            = var.location
  vnet_id                             = module.vnet.vnet_id
  storage_account_id                  = module.storage_tshoot.storage_account_id
  log_analytics_workspace_id          = azurerm_log_analytics_workspace.default.workspace_id
  log_analytics_workspace_resource_id = azurerm_log_analytics_workspace.default.id
}
