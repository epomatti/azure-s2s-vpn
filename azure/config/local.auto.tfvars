### General ###
subscription_id          = "00000000-0000-0000-0000-000000000000"
location                 = "brazilsouth"
workload                 = "litware"
allowed_admin_public_ips = ["x.x.x.x/32"]

### VPN Gateway ###
vgw_vpn_type                              = "RouteBased"
vgw_active_active                         = false
vgw_bgp_enabled                           = true
vgw_bgp_settings_asn                      = 65515
vgw_sku                                   = "VpnGw2AZ"
vgw_generation                            = "Generation2"
vgw_bgp_route_translation_for_nat_enabled = true

### VPN NAT ###
remote_network_cidr = "172.16.100.0/24"

### VPN Local Gateway ###
lgw_create          = false
lgw_gateway_address = "1.2.3.4"
lgw_address_space   = ["172.16.0.0/12"]

### VPN Gateway Connection ###
vcn_create      = false
vcn_shared_key  = "<secret>"
vcn_bgp_enabled = true