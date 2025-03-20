output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "vnet_cidr_blocks" {
  value = azurerm_virtual_network.default.address_space
}

output "subnet_id" {
  value = azurerm_subnet.default.id
}

output "vnet_name" {
  value = azurerm_virtual_network.default.name
}
