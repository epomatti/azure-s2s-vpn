output "servers" {
  value = azurerm_resource_group.servers.name
}

output "troubleshoot" {
  value = azurerm_resource_group.troubleshoot.name
}

output "network" {
  value = azurerm_resource_group.network.name
}
