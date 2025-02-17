output "ssm_start_session_command_firewall_server" {
  value = "aws ssm start-session --target ${module.firewall.instance_id}"
}

output "firewall_host_public_ip" {
  value = module.firewall.public_ip
}
