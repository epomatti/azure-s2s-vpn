variable "workload" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vpn_remote_ingress_address_prefixes" {
  type = list(string)
}

variable "vpn_remote_egress_address_prefixes" {
  type = list(string)
}

variable "allowed_admin_public_ips" {
  type = list(string)
}

### Flow Logs
variable "storage_account_id" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "log_analytics_id" {
  type = string
}
