terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

resource "random_string" "affix" {
  length  = 5
  special = false
  numeric = false
  upper   = false
}

locals {
  affix          = random_string.affix.result
  resource_affix = "${var.workload}-${local.affix}"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.resource_affix}"
  location = var.location
}

module "vnet_gateway" {
  source              = "./modules/vnet/gateway"
  workload            = local.resource_affix
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  vnet_cidr_prefix    = var.vnet_gateway_cidr_prefix
}

module "vnet_workloads" {
  source              = "./modules/vnet/workloads"
  workload            = local.resource_affix
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  vnet_cidr_prefix    = var.vnet_workloads_cidr_prefix
  allowed_public_ips  = var.allowed_public_ips
}

module "vnet_peerings" {
  source              = "./modules/vnet/peerings"
  resource_group_name = azurerm_resource_group.default.name
  gateway_vnet_id     = module.vnet_gateway.vnet_id
  gateway_vnet_name   = module.vnet_gateway.vnet_name
  workloads_vnet_id   = module.vnet_workloads.vnet_id
  workloads_vnet_name = module.vnet_workloads.vnet_name
}

module "vpn_gateway" {
  source              = "./modules/vgw"
  workload            = local.resource_affix
  resource_group_name = azurerm_resource_group.default.name
  location            = var.location
  gateway_subnet_id   = module.vnet_gateway.gateway_subnet_id
  vgw_vpn_type        = var.vgw_vpn_type
  vgw_active_active   = var.vgw_active_active
  vgw_enable_bgp      = var.vgw_enable_bgp
  vgw_sku             = var.vgw_sku
  vgw_generation      = var.vgw_generation
}

module "virtual_machine" {
  source              = "./modules/vm"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  workload            = var.workload
  vm_public_key_path  = var.vm_public_key_path
  vm_admin_username   = var.vm_admin_username
  vm_size             = var.vm_size
  subnet_id           = module.vnet_workloads.workloads_subnet_id

  vm_image_publisher = var.vm_image_publisher
  vm_image_offer     = var.vm_image_offer
  vm_image_sku       = var.vm_image_sku
  vm_image_version   = var.vm_image_version
}
