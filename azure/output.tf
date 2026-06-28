output "vgw_public_ip_address" {
  value = module.gateway.vgw_public_ip_address
}

output "ssh_linux_server" {
  value = "ssh -i .keys/azure azureuser@${module.linux_server.public_ip_address}"
}
