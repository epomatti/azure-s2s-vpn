### General ###
variable "subscription_id" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "allowed_admin_public_ips" {
  type = list(string)
}

### Network ###
variable "vnet_address_space" {
  type = list(string)
}

variable "vnet_gateway_subnet_address_prefixes" {
  type = list(string)
}

variable "vnet_servers_subnet_address_prefixes" {
  type = list(string)
}

variable "vnet_vpn_remote_address_prefixes" {
  type = list(string)
}

### VPN Gateway ###
variable "vgw_vpn_type" {
  type = string
}

variable "vgw_active_active" {
  type = bool
}

variable "vgw_bgp_enabled" {
  type = bool
}

variable "vgw_bgp_settings_asn" {
  type = number
}

variable "vgw_generation" {
  type = string
}

variable "vgw_sku" {
  type = string
}

variable "vgw_bgp_route_translation_for_nat_enabled" {
  type = bool
}

variable "vgw_ingress_nat_external_mapping" {
  type = string
}

variable "vgw_ingress_nat_internal_mapping" {
  type = string
}

variable "vgw_egress_nat_external_mapping" {
  type = string
}

variable "vgw_egress_nat_internal_mapping" {
  type = string
}

### Local Network Gateway ###
variable "lgw_gateway_address" {
  type = string
}

variable "lgw_address_space" {
  type = list(string)
}

variable "vcn_shared_key" {
  type      = string
  sensitive = false
}

variable "vcn_bgp_enabled" {
  type = bool
}



# variable "vnet_cidr_address" {
#   type = string
# }

# variable "vnet_gateway_subnet_cidr" {
#   type = string
# }

# variable "vnet_workloads_subnet_cidr" {
#   type = string
# }

# variable "vnet_cidr_p2s_prefix" {
#   type = string
# }

# ### VPN Gateway ###
# variable "vgw_enabled" {
#   type = bool
# }

# variable "vgw_vpn_type" {
#   type = string
# }

# variable "vgw_active_active" {
#   type = bool
# }

# variable "vgw_enable_bgp" {
#   type = bool
# }

# variable "vgw_sku" {
#   type = string
# }

# variable "vgw_generation" {
#   type = string
# }

# ### Local Network Gateway ###
# variable "vgw_connection_enabled" {
#   type = bool
# }

# variable "lgw_gateway_address" {
#   type = string
# }

# variable "lgw_address_space" {
#   type = list(string)
# }

# variable "vcn_shared_key" {
#   type      = string
#   sensitive = false
# }

# ### Virtual Machine ###
# variable "vm_enabled" {
#   type = bool
# }

# variable "vm_admin_username" {
#   type = string
# }

# variable "vm_public_key_path" {
#   type = string
# }

# variable "vm_size" {
#   type = string
# }

# variable "vm_image_publisher" {
#   type = string
# }

# variable "vm_image_offer" {
#   type = string
# }

# variable "vm_image_sku" {
#   type = string
# }

# variable "vm_image_version" {
#   type = string
# }

# ### Point-to-Site (P2S) ###
# variable "p2s_enabled" {
#   type = bool
# }

# ### Windows Desktop ###

# variable "p2s_create_windows_desktop" {
#   type = bool
# }

# variable "p2s_windows_desktop_size" {
#   type = string
# }

# variable "p2s_windows_desktop_admin_username" {
#   type = string
# }

# variable "p2s_windows_desktop_admin_password" {
#   type      = string
#   sensitive = true
# }

# variable "p2s_windows_desktop_image_publisher" {
#   type = string
# }

# variable "p2s_windows_desktop_image_offer" {
#   type = string
# }

# variable "p2s_windows_desktop_image_sku" {
#   type = string
# }

# variable "p2s_windows_desktop_image_version" {
#   type = string
# }

# ### Entra ID ###
# variable "p2s_entraid_tenant_domain" {
#   type = string
# }

# variable "p2s_entraid_desktop_user_name" {
#   type = string
# }

# variable "p2s_entraid_desktop_user_password" {
#   type      = string
#   sensitive = true
# }
