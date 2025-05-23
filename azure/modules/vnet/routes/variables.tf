variable "resource_group_name" {
  type = string
}

variable "workload" {
  type = string
}

variable "location" {
  type = string
}

variable "remote_cidr" {
  type = string
}

variable "p2s_cidr" {
  type = set(string)
}

variable "workload_subnet_id" {
  type = string
}

variable "gateway_subnet_id" {
  type = string
}
