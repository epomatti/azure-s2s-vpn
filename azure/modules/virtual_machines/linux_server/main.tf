locals {
  name           = "${var.workload}-server"
  admin_username = "azureuser"
}

resource "azurerm_public_ip" "main" {
  name                = "pip-${local.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  zones               = [var.zone]
}

resource "azurerm_network_interface" "main" {
  name                = "nic-${local.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig001"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.16.100.10"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                  = "vm-${local.name}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = "Standard_B2ls_v2"
  admin_username        = local.admin_username
  network_interface_ids = [azurerm_network_interface.main.id]
  zone                  = var.zone

  secure_boot_enabled                                    = true
  vtpm_enabled                                           = true
  bypass_platform_safety_checks_on_user_schedule_enabled = true
  patch_mode                                             = "AutomaticByPlatform"

  custom_data = filebase64("${path.module}/custom_data/cloud_init.yaml")

  admin_ssh_key {
    username   = local.admin_username
    public_key = file(".keys/azure.pub")
  }

  os_disk {
    name                 = "osdisk-${var.workload}"
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-26_04-lts"
    sku       = "server"
    version   = "latest"
  }

  lifecycle {
    ignore_changes = [custom_data]
  }
}
