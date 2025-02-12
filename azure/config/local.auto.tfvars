# General
subscription_id    = "00000000-0000-0000-0000-000000000000"
location           = "eastus2"
workload           = "litware"
allowed_public_ips = ["1.2.3.4/32"]

### Virtual Network ###
vnet_gateway_cidr_prefix   = "10.90"
vnet_workloads_cidr_prefix = "10.100"

### Virtual Network Gateway ###
vgw_vpn_type      = "RouteBased"
vgw_active_active = false
vgw_enable_bgp    = false
vgw_sku           = "VpnGw2"
vgw_generation    = "Generation2"

### Local Network Gateway ###
lgw_gateway_address = "1.2.3.4"
lgw_address_space   = ["172.16.0.0/16"]

### Virtual Machine ###
vm_admin_username  = "azureuser"
vm_public_key_path = ".keys/tmp_rsa.pub"
vm_size            = "Standard_B2ls_v2"
vm_image_publisher = "canonical"
vm_image_offer     = "ubuntu-24_04-lts"
vm_image_sku       = "server"
vm_image_version   = "latest"
