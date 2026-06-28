output "gateway_subnet_id" {
  value = module.hub.gateway_subnet_id
}

output "servers_subnet_id" {
  value = module.spoke.servers_subnet_id
}

output "servers_subnet_address_prefixes" {
  value = module.spoke.servers_subnet_address_prefixes
}

output "hub_vnet_id" {
  value = module.hub.vnet_id
}

output "hub_vnet_name" {
  value = module.hub.vnet_name
}

output "spoke_vnet_id" {
  value = module.spoke.vnet_id
}

output "spoke_vnet_name" {
  value = module.spoke.vnet_name
}
