variable "workload" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "virtual_network_gateway_id" {
  type = string
}

variable "shared_key" {
  type      = string
  sensitive = true
}

variable "bgp_enabled" {
  type = bool
}

variable "local_network_gateway_id" {
  type = string
}

variable "ingress_nat_rule_ids" {
  type = list(string)
}

variable "egress_nat_rule_ids" {
  type = list(string)
}
