output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "vnet_name" {
  value = azurerm_virtual_network.default.name
}

output "servers_subnet_id" {
  value = azurerm_subnet.servers.id
}

output "servers_subnet_address_prefixes" {
  value = azurerm_subnet.servers.address_prefixes
}
