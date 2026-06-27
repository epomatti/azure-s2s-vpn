### General ###
subscription_id          = "00000000-0000-0000-0000-000000000000"
location                 = "brazilsouth"
workload                 = "litware"
allowed_admin_public_ips = ["x.x.x.x/32"]

### Network ###
vnet_address_space                   = ["10.0.0.0/16"]
vnet_gateway_subnet_address_prefixes = ["10.0.10.0/27"]
vnet_servers_subnet_address_prefixes = ["10.0.20.0/24"]
vnet_vpn_remote_address_prefixes     = ["172.16.0.0/16"]

### VPN Gateway ###
vgw_vpn_type             = "RouteBased"
vgw_active_active        = false
vgw_enable_bgp           = false
vgw_sku                  = "VpnGw2AZ"
vgw_generation           = "Generation2"
vgw_nat_internal_mapping = "172.16.150.0/24"
vgw_nat_external_mapping = "10.0.0.0/24"

### VPN Local Gateway ###
lgw_gateway_address = "x.x.x.x"
lgw_address_space   = ["172.16.0.0/16"]

### VPN Gateway Connection ###
vcn_shared_key  = "<secret>"
vcn_bgp_enabled = false
