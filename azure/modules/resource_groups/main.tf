resource "azurerm_resource_group" "servers" {
  name     = "rg-${var.workload}-servers"
  location = var.location
}

resource "azurerm_resource_group" "troubleshoot" {
  name     = "rg-${var.workload}-troubleshoot"
  location = var.location
}

resource "azurerm_resource_group" "network" {
  name     = "rg-${var.workload}-network"
  location = var.location
}
