output "servers_subnet_id" {
  value = azurerm_subnet.servers.id
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway.id
}
