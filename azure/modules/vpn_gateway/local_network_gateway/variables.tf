variable "workload" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "lgw_gateway_address" {
  type = string
}

variable "lgw_address_space" {
  type = list(string)
}
