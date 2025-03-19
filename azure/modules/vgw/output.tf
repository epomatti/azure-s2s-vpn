output "public_ip" {
  value = azurerm_public_ip.main.ip_address
}

output "vgw_id" {
  value = azurerm_virtual_network_gateway.main.id
}
