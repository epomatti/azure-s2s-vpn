output "gateway_subnet_id" {
  value = module.hub.gateway_subnet_id
}

output "servers_subnet_id" {
  value = module.spoke.servers_subnet_id
}
