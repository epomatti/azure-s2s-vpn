output "vm_ssh_command" {
  value = "ssh -i .keys/tmp_rsa ${var.vm_admin_username}@${module.virtual_machine.public_ip_address}"
}

output "vgw_public_ip_address" {
  value = module.vpn_gateway.public_ip
}
