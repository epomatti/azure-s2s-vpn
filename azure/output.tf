output "server_ssh_command" {
  value = "ssh -i .keys/tmp_rsa ${var.vm_admin_username}@${module.virtual_machine.public_ip_address}"
}

output "vgw_public_ip_address" {
  value = module.vpn.vgw_public_ip
}
