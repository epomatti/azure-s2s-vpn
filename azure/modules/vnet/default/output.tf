output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway.id
}

output "workloads_subnet_id" {
  value = azurerm_subnet.workloads.id
}
output "vnet_name" {
  value = azurerm_virtual_network.default.name
}
