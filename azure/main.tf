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

module "vnet" {
  source              = "./modules/vnet"
  workload            = local.resource_affix
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "virtual_machine" {
  source              = "./modules/vm"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
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
