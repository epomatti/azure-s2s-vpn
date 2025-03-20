output "network_interface_id" {
  value = aws_instance.default.primary_network_interface_id
}

output "instance_id" {
  value = aws_instance.default.id
}

output "private_ip" {
  value = aws_instance.default.private_ip
}
