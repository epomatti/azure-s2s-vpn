variable "resource_group_name" {
  type = string
}

variable "workload" {
  type = string
}

variable "location" {
  type = string
}

### Virtual Private Gateway ###
variable "gateway_subnet_id" {
  type = string
}

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

### Local Gateway ###
variable "lgw_gateway_address" {
  type = string
}

variable "lgw_address_space" {
  type = list(string)
}

### Virtual Connection ###
variable "shared_key" {
  type      = string
  sensitive = false
}

variable "create_gateway_connection" {
  type = bool
}