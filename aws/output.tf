output "ssm_start_session_command_firewall_server" {
  value = "aws ssm start-session --target ${module.firewall.instance_id}"
}

output "pfsense_firewall_host_elastic_public_ip" {
  value = module.firewall.eip_public_ip
}

output "ssm_start_session_command_server_host" {
  value = "aws ssm start-session --target ${module.server.instance_id}"
}

output "server_host_private_ip" {
  value = module.server.private_ip
}
