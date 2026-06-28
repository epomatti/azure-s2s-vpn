### General ###
subscription_id          = "00000000-0000-0000-0000-000000000000"
location                 = "brazilsouth"
workload                 = "litware"
allowed_admin_public_ips = ["x.x.x.x/32"]

### Network ###
vnet_address_space                   = ["10.0.0.0/16"]
vnet_gateway_subnet_address_prefixes = ["10.0.10.0/27"]
vnet_servers_subnet_address_prefixes = ["10.0.20.0/24"]
vnet_vpn_remote_address_prefixes     = ["200.0.0.0/24"]

### VPN Gateway ###
vgw_vpn_type                              = "RouteBased"
vgw_active_active                         = false
vgw_enable_bgp                            = true
vgw_bgp_settings_asn                      = 65515
vgw_sku                                   = "VpnGw2AZ"
vgw_generation                            = "Generation2"
vgw_bgp_route_translation_for_nat_enabled = true
vgw_ingress_nat_external_mapping          = "200.0.0.0/24"
vgw_ingress_nat_internal_mapping          = "10.0.20.0/24"
vgw_egress_nat_external_mapping           = "100.0.0.0/24"
vgw_egress_nat_internal_mapping           = "10.0.20.0/24"

### VPN Local Gateway ###
lgw_gateway_address = "1.2.3.4"
lgw_address_space   = ["172.16.0.0/16"]

### VPN Gateway Connection ###
vcn_shared_key  = "<secret>"
vcn_bgp_enabled = true

