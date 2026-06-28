output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "vnet_name" {
  value = azurerm_virtual_network.default.name
}

output "servers_subnet_id" {
  value = azurerm_subnet.servers.id
}
