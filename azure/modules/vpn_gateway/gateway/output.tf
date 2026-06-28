output "vgw_id" {
  value = azurerm_virtual_network_gateway.main.id
}

output "vgw_public_ip_address" {
  value = azurerm_public_ip.gateway_001.ip_address
}
