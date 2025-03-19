variable "workload" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vpn_gateway_id" {
  type = string
}

variable "local_network_gateway_id" {
  type = string
}

variable "shared_key" {
  type      = string
  sensitive = false
}
