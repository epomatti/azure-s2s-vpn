# General
subscription_id    = "00000000-0000-0000-0000-000000000000"
location           = "eastus2"
workload           = "litware"
allowed_public_ips = ["1.2.3.4/32"]

### Virtual Network ###
vnet_cidr_prefix = "10.90"

### Virtual Network Gateway ###
vgw_vpn_type      = "RouteBased"
vgw_active_active = false
vgw_enable_bgp    = false # TODO: Check for P2s
vgw_sku           = "VpnGw2"
vgw_generation    = "Generation2"

### Local Network Gateway ###
create_gateway_connection = false
lgw_gateway_address       = "1.2.3.4"
lgw_address_space         = ["172.16.0.0/16"]
vcn_shared_key            = "0000000000000000000000000000000000000000000000"

### Virtual Machine ###
vm_admin_username  = "azureuser"
vm_public_key_path = ".keys/tmp_rsa.pub"
vm_size            = "Standard_B2ls_v2"
vm_image_publisher = "canonical"
vm_image_offer     = "ubuntu-24_04-lts"
vm_image_sku       = "server"
vm_image_version   = "latest"

### P2S ###
# Windows Desktop
p2s_create_windows_desktop          = true
p2s_windows_desktop_size            = "Standard_B4as_v2"
p2s_windows_desktop_admin_username  = "azureuser"
p2s_windows_desktop_admin_password  = "P@ssw0rd.123"
p2s_windows_desktop_image_publisher = "MicrosoftWindowsDesktop"
p2s_windows_desktop_image_offer     = "Windows-11"
p2s_windows_desktop_image_sku       = "win11-24h2-ent"
p2s_windows_desktop_image_version   = "latest"

# Entra ID
p2s_entraid_tenant_domain         = "<TENANT_DOMAIN>"
p2s_entraid_desktop_user_name     = "vpnuser"
p2s_entraid_desktop_user_password = "P@ssw0rd.123"
