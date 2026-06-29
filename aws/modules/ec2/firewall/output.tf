output "admin_network_interface_id" {
  value = aws_network_interface.admin.id
}

output "wan_network_interface_id" {
  value = aws_network_interface.wan.id
}

output "private_network_interface_id" {
  value = aws_network_interface.private.id
}

output "instance_id" {
  value = aws_instance.default.id
}

output "admin_public_ip" {
  value = aws_eip.admin.public_ip
}

output "wan_public_ip" {
  value = aws_eip.wan.public_ip
}
