variable "subscription_id" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "allowed_public_ips" {
  type = list(string)
}

### Virtual Network ###
variable "vnet_gateway_cidr_prefix" {
  type = string
}

variable "vnet_workloads_cidr_prefix" {
  type = string
}

### Virtual Network Gateway ###
variable "vgw_vpn_type" {
  type = string
}

variable "vgw_active_active" {
  type = bool
}

variable "vgw_enable_bgp" {
  type = bool
}

variable "vgw_sku" {
  type = string
}

variable "vgw_generation" {
  type = string
}

### Local Network Gateway ###
variable "lgw_gateway_address" {
  type = string
}

variable "lgw_address_space" {
  type = list(string)
}

### VCN ###
variable "vcn_shared_key" {
  type      = string
  sensitive = false
}

### Virtual Machine ###
variable "vm_admin_username" {
  type = string
}

variable "vm_public_key_path" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "vm_image_publisher" {
  type = string
}

variable "vm_image_offer" {
  type = string
}

variable "vm_image_sku" {
  type = string
}

variable "vm_image_version" {
  type = string
}
