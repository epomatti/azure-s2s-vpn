variable "workload" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "allowed_admin_public_ips" {
  type = list(string)
}

variable "vpn_remote_ingress_address_prefixes" {
  type = list(string)
}

variable "vpn_remote_egress_address_prefixes" {
  type = list(string)
}
